-- -*-haskell-*-
--  GIMP Toolkit (GTK) Widget TearoffMenuItem
--
--  Author : Axel Simon
--
--  Created: 15 May 2001
--
--  Version $Revision: 1.3 $ from $Date: 2005/02/25 01:11:35 $
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
-- A menu item used to tear off and reattach its menu.
--
module Graphics.UI.Gtk.MenuComboToolbar.TearoffMenuItem (
-- * Description
-- 
-- | a 'TearoffMenuItem' is a special 'MenuItem' which is used to tear off and
-- reattach its menu.
--
-- When its menu is shown normally, the 'TearoffMenuItem' is drawn as a
-- dotted line indicating that the menu can be torn off. Activating it causes
-- its menu to be torn off and displayed in its own window as a tearoff menu.
--
-- When its menu is shown as a tearoff menu, the 'TearoffMenuItem' is drawn
-- as a dotted line which has a left pointing arrow graphic indicating that the
-- tearoff menu can be reattached. Activating it will erase the tearoff menu
-- window.

-- * Class Hierarchy
-- |
-- @
-- |  'GObject'
-- |   +----'Object'
-- |         +----'Widget'
-- |               +----'Container'
-- |                     +----'Bin'
-- |                           +----'Item'
-- |                                 +----'MenuItem'
-- |                                       +----TearoffMenuItem
-- @

-- * Types
  TearoffMenuItem,
  TearoffMenuItemClass,
  castToTearoffMenuItem,

-- * Constructors
  tearoffMenuItemNew
  ) where

import Monad	(liftM)

import System.Glib.FFI
import Graphics.UI.Gtk.Abstract.Object	(makeNewObject)
{#import Graphics.UI.Gtk.Types#}
{#import Graphics.UI.Gtk.Signals#}

{# context lib="gtk" prefix="gtk" #}

--------------------
-- Constructors

-- | Create a new tear off menu item.
--
tearoffMenuItemNew :: IO TearoffMenuItem
tearoffMenuItemNew  = makeNewObject mkTearoffMenuItem $ liftM castPtr
  {#call unsafe tearoff_menu_item_new#}