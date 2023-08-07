import           XMonad                          hiding ((|||))
import           XMonad.Layout.LayoutCombinators

import           XMonad.Hooks.EwmhDesktops
import           XMonad.Hooks.ManageDocks

import           XMonad.Util.Run

import qualified Data.Map                        as M
import           System.Exit
import qualified XMonad.StackSet                 as W

import qualified Tools

import           XMonad.Actions.PhysicalScreens

import           XMonad.Util.EZConfig


import           XMonad.Prompt
import           XMonad.Prompt.ConfirmPrompt

-- Imports for Polybar --
import qualified Codec.Binary.UTF8.String        as UTF8
import qualified DBus                            as D
import qualified DBus.Client                     as D
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.FadeInactive       (fadeInactiveLogHook)

main :: IO ()
main = mkDbusClient >>= main'

main' :: D.Client -> IO ()
main' dbus =
        xmonad $ ewmhFullscreen . ewmh . docks $ def {
          modMask = mod4Mask -- Use Super instead of Alt
          , terminal = Tools.terminal
          , keys = myKeys
          , layoutHook = avoidStruts (tall ||| Mirror tall ||| Full)
          , logHook            = myPolybarLogHook dbus
        }

tall = Tall 1 (3/100) (1/2)


------------------------------------------------------------------------
-- Polybar settings (needs DBus client).
--
mkDbusClient :: IO D.Client
mkDbusClient = do
  dbus <- D.connectSession
  D.requestName dbus (D.busName_ "org.xmonad.log") opts
  return dbus
 where
  opts = [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]

-- Emit a DBus signal on log updates
dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str =
  let opath  = D.objectPath_ "/org/xmonad/Log"
      iname  = D.interfaceName_ "org.xmonad.Log"
      mname  = D.memberName_ "Update"
      signal = D.signal opath iname mname
      body   = [D.toVariant $ UTF8.decodeString str]
  in  D.emit dbus $ signal { D.signalBody = body }

polybarHook :: D.Client -> PP
polybarHook dbus =
  let wrapper c s | s /= "NSP" = wrap ("%{F" <> c <> "} ") " %{F-}" s
                  | otherwise  = mempty
      blue   = "#2E9AFE"
      gray   = "#7F7F7F"
      orange = "#ea4300"
      purple = "#9058c7"
      red    = "#722222"
  in  def { ppOutput          = dbusOutput dbus
          , ppCurrent         = wrapper blue
          , ppVisible         = wrapper gray
          , ppUrgent          = wrapper orange
          , ppHidden          = wrapper gray
          , ppHiddenNoWindows = wrapper red
          , ppTitle           = wrapper purple . shorten 90
          }

myPolybarLogHook dbus = myLogHook <+> dynamicLogWithPP (polybarHook dbus)

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = fadeInactiveLogHook 0.9

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
  [
    -- launch a terminal
    ((modm,                 xK_Return), spawn $ XMonad.terminal conf)
    , ((modm,                 xK_t), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_d     ), spawn Tools.dmenu)

    -- lock the screen
    , ((modm,               xK_Escape ), spawn Tools.lock)

    -- lock the screen
    , ((noModMask,          xK_Pause ), spawn Tools.lock)

    -- Screenshot whole screen
    , ((noModMask,          xK_Print ), spawn Tools.screenshot_full)

    -- Screenshot selection
    , ((shiftMask,          xK_Print ), spawn Tools.screenshot_selection)

    -- Show clipmenu
    , ((modm,               xK_c     ), spawn Tools.clipboard)

    -- close focused window
    , ((modm .|. shiftMask, xK_q     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm .|. shiftMask, xK_Tab     ), windows W.focusUp  )

    -- Move focus to the previous window
    , ((modm,               xK_odiaeresis     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_a     ), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_odiaeresis     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm .|. shiftMask, xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_p     ), confirmPrompt amberXPConfig "exit" $ io exitSuccess)

    -- PTT
    , ((noModMask,          xK_Scroll_Lock ), spawn Tools.toggle_mute)
    , ((modm,          xK_y     ), spawn Tools.toggle_mute)

    , ((modm,               xK_b     ), spawn Tools.rofi_bluetooth)
    , ((modm,               xK_x     ), spawn "mum-rofi") -- TODO: Get from Tools once I know how
    ]
    ++

    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((modm .|. mask, key), f sc)
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, mask) <- [(viewScreen horizontalScreenOrderer, 0), (sendToScreen horizontalScreenOrderer, shiftMask)]]
