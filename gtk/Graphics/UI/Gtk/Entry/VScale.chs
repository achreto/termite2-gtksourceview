-- -*-haskell-*-
--  GIMP Toolkit (GTK) Widget VScale
--
--  Author : Axel Simon
--
--  Created: 23 May 2001
--
--  Version $Revision: 1.3 $ from $Date: 2005/02/25 01:11:33 $
--
--  Copyright (C) 1999-2005 Axel Simon
--
--  This library is free software; you can redistribute it and/or
--  modify it under the terms of the GNU Lesser General Public
--  License as published by the Free Software Foundation; either
--  version 2.1 of the License, or (at your option) any later version.
--
--  This library is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
--  Lesser General Public License for more details.
--
-- |
-- Maintainer  : gtk2hs-users@lists.sourceforge.net
-- Stability   : provisional
-- Portability : portable (depends on GHC)
--
-- A vertical slider widget for selecting a value from a range.
--
module Graphics.UI.Gtk.Entry.VScale (
-- * Description
-- 
-- | The 'VScale' widget is used to allow the user to select a value using a
-- vertical slider. To create one, use 'hScaleNewWithRange'.
--
-- The position to show the current value, and the number of decimal places
-- shown can be set using the parent 'Scale' class's functions.

-- * Class Hierarchy
-- |
-- @
-- |  'GObject'
-- |   +----'Object'
-- |         +----'Widget'
-- |               +----'Range'
-- |                     +----'Scale'
-- |                           +----VScale
-- @

-- * Types
  VScale,
  VScaleClass,
  castToVScale,

-- * Constructors
  vScaleNew,
  vScaleNewWithRange
  ) where

import Monad	(liftM)

import System.Glib.FFI
import Graphics.UI.Gtk.Abstract.Object	(makeNewObject)
{#import Graphics.UI.Gtk.Types#}
{#import Graphics.UI.Gtk.Signals#}

{# context lib="gtk" prefix="gtk" #}

--------------------
-- Constructors

-- | Create a new VScale widget.
--
vScaleNew :: Adjustment -> IO VScale
vScaleNew adj = makeNewObject mkVScale $ liftM castPtr $
  {#call unsafe vscale_new#} adj

-- | Create a new VScale widget with @min@, @max@ and @step@ values rather than
-- an "Adjustment" object.
--
vScaleNewWithRange :: Double -- ^ Minimum value
                   -> Double -- ^ Maximum value
                   -> Double -- ^ Step increment (tick size) used with keyboard
                             --   shortcuts. Must be nonzero.
                   -> IO VScale
vScaleNewWithRange min max step =
  makeNewObject mkVScale $ liftM castPtr $
  {#call unsafe vscale_new_with_range#} (realToFrac min) (realToFrac max)
    (realToFrac step)