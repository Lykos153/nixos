{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}

-----------------------------------------------------------------------------
-- |
-- Module      :  XMonad.Layout.PerScreenRatio
-- Copyright   :  (c) Edward Z. Yang, Silvio Ankermann
-- License     :  BSD-style (see LICENSE)
--
-- Maintainer  :  <silvio@booq.org>
-- Stability   :  unstable
-- Portability :  unportable
--
-- Configure layouts based on the ratio of your screen; use your
-- favorite multi-column layout for wide screens and a full-screen
-- layout for small ones.
-----------------------------------------------------------------------------

module PerScreenRatio
    ( -- * Usage
      -- $usage
      PerScreenRatio,
      ifRatioGreater
    ) where

import           GHC.Float
import           XMonad
import qualified XMonad.StackSet as W

import           Data.Maybe      (fromMaybe)

-- $usage
-- You can use this module by importing it into your ~\/.xmonad\/xmonad.hs file:
--
-- > import XMonad.Layout.PerScreenRatio
--
-- and modifying your layoutHook as follows (for example):
--
-- > layoutHook = ifRatioGreater (16/9) (Tall 1 (3/100) (1/2) ||| Full) Full
--
-- Replace any of the layouts with any arbitrarily complicated layout.
-- ifRatioGreater can also be used inside other layout combinators.

ifRatioGreater :: (LayoutClass l1 a, LayoutClass l2 a)
               => Float   -- ^ target screen ratio
               -> (l1 a)      -- ^ layout to use when the screen ratio is big enough
               -> (l2 a)      -- ^ layout to use otherwise
               -> PerScreenRatio l1 l2 a
ifRatioGreater w = PerScreenRatio w False

data PerScreenRatio l1 l2 a = PerScreenRatio Float Bool (l1 a) (l2 a) deriving (Read, Show)

-- | Construct new PerScreenRatio values with possibly modified layouts.
mkNewPerScreenRatioT :: PerScreenRatio l1 l2 a -> Maybe (l1 a) ->
                      PerScreenRatio l1 l2 a
mkNewPerScreenRatioT (PerScreenRatio w _ lt lf) mlt' =
    (\lt' -> PerScreenRatio w True lt' lf) $ fromMaybe lt mlt'

mkNewPerScreenRatioF :: PerScreenRatio l1 l2 a -> Maybe (l2 a) ->
                      PerScreenRatio l1 l2 a
mkNewPerScreenRatioF (PerScreenRatio w _ lt lf) mlf' =
    (\lf' -> PerScreenRatio w False lt lf') $ fromMaybe lf mlf'

instance (LayoutClass l1 a, LayoutClass l2 a, Show a) => LayoutClass (PerScreenRatio l1 l2) a where
    runLayout (W.Workspace i p@(PerScreenRatio w _ lt lf) ms) r
        | ratio >  w          = do (wrs, mlt') <- runLayout (W.Workspace i lt ms) r
                                   return (wrs, Just $ mkNewPerScreenRatioT p mlt')
        | otherwise           = do (wrs, mlt') <- runLayout (W.Workspace i lf ms) r
                                   return (wrs, Just $ mkNewPerScreenRatioF p mlt')
        where ratio = castWord32ToFloat (rect_width r) / castWord32ToFloat (rect_height r)

    handleMessage (PerScreenRatio w bool lt lf) m
        | bool      = handleMessage lt m >>= maybe (return Nothing) (\nt -> return . Just $ PerScreenRatio w bool nt lf)
        | otherwise = handleMessage lf m >>= maybe (return Nothing) (\nf -> return . Just $ PerScreenRatio w bool lt nf)

    description (PerScreenRatio _ True  l1 _) = description l1
    description (PerScreenRatio _ _     _ l2) = description l2
