import           XMonad                             hiding ((|||))
import           XMonad.Layout.CenterMainFluid
import           XMonad.Layout.LayoutCombinators
import           XMonad.Layout.NoBorders
import           XMonad.Layout.PerScreen

import           System.Taffybar.Support.PagerHints (pagerHints)
import           XMonad.Hooks.EwmhDesktops
import           XMonad.Hooks.ManageDocks

import           XMonad.Util.Run

import qualified Data.Map                           as M
import           System.Exit
import qualified XMonad.StackSet                    as W

import           PerScreenRatio
import qualified Tools

import           XMonad.Actions.PhysicalScreens
import           XMonad.Actions.UpdatePointer

import           Graphics.X11.ExtraTypes.XF86
import           XMonad.Util.EZConfig


import           XMonad.Prompt
import           XMonad.Prompt.ConfirmPrompt

main = do
        xmonad $ ewmhFullscreen . ewmh . docks . pagerHints $ def {
          modMask = mod4Mask -- Use Super instead of Alt
          , terminal = Tools.terminal
          , keys = myKeys
          , layoutHook = let
              ultrawideLayout = (CenterMainFluid 1 (3/100) (50/100)) ||| (noBorders Full) ||| tall
              regularLayout = (tall ||| Mirror tall ||| (noBorders Full))
              rotatedLayout = Mirror tall ||| (noBorders Full)
             in avoidStruts $ ifRatioGreater (10/16) (ifRatioGreater (16/10) ultrawideLayout regularLayout) rotatedLayout
          , logHook = updatePointer (0.5, 0.5) (0, 0)
        }

tall = Tall 1 (3/100) (1/2)

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
    , ((modm,               xK_p     ), spawn Tools.rofi_pass)
    , ((modm,               xK_x     ), spawn Tools.rofi_mum)
    , ((modm,               xK_v     ), spawn (Tools.rofi_pulse_select ++ " sink"))
    , ((modm .|. shiftMask, xK_v     ), spawn (Tools.rofi_pulse_select ++ " source"))

    , ((noModMask                 , xF86XK_AudioMute), spawn (Tools.pactl ++ " set-sink-mute @DEFAULT_SINK@ toggle"))
    , ((noModMask                 , xF86XK_AudioLowerVolume), spawn (Tools.pactl ++ " set-sink-volume @DEFAULT_SINK@ -5%"))
    , ((noModMask                 , xF86XK_AudioRaiseVolume), spawn (Tools.pactl ++ " set-sink-volume @DEFAULT_SINK@ +5%"))

    -- For Microsoft Sculpt Keyboard
    , ((modm                 , xK_F2), spawn (Tools.pactl ++ " set-sink-mute @DEFAULT_SINK@ toggle"))
    , ((modm                 , xK_F3), spawn (Tools.pactl ++ " set-sink-volume @DEFAULT_SINK@ -5%"))
    , ((modm                 , xK_F4), spawn (Tools.pactl ++ " set-sink-volume @DEFAULT_SINK@ +5%"))
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
