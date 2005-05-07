-- -*-haskell-*-
--  GIMP Toolkit (GTK) Class TreePath
--
--  Author : Duncan Coutts
--
--  Created: 14 April 2005
--
--  Version $Revision: 1.1 $ from $Date: 2005/04/20 03:51:38 $
--
--  Copyright (C) 2005 Axel Simon, Duncan Coutts
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
-- TODO: the following varargs functions were not bound
--   gtk_tree_path_new_from_indices
--
-- |
-- Maintainer  : gtk2hs-users@lists.sourceforge.net
-- Stability   : provisional
-- Portability : portable (depends on GHC)
--
-- 
--
module Graphics.UI.Gtk.TreeList.TreePath (

-- * Types
  TreePath,
  NativeTreePath(..),

-- * Internal Utils
  withTreePath,
  peekTreePath,
  fromTreePath,
  ) where

import Monad	(liftM)

import System.Glib.FFI
{#import Graphics.UI.Gtk.Types#}

{# context lib="gtk" prefix="gtk" #}

-- | TreePath : a list of indices to specify a subtree or node in the
-- hierarchical 'TreeStore' database.
--
type TreePath = [Int]

{#pointer * TreePath as NativeTreePath newtype#}

nativeTreePathFree :: NativeTreePath -> IO ()
nativeTreePathFree =
  {# call unsafe tree_path_free #}

nativeTreePathNew :: IO NativeTreePath
nativeTreePathNew =
 liftM NativeTreePath
 {# call unsafe tree_path_new #}

withTreePath :: TreePath -> (NativeTreePath -> IO a) -> IO a
withTreePath tp act = do
  nativePath <- nativeTreePathNew
  mapM_ ({#call unsafe tree_path_append_index#} nativePath . fromIntegral) tp
  res <- act nativePath
  nativeTreePathFree nativePath
  return res

nativeTreePathGetIndices :: NativeTreePath -> IO [Int]
nativeTreePathGetIndices tp = do
  depth <- liftM fromIntegral $ {# call unsafe tree_path_get_depth #} tp
  arrayPtr <- {# call unsafe tree_path_get_indices #} tp
  if (depth==0 || arrayPtr==nullPtr)
    then return []
    else liftM (map fromIntegral) $ peekArray depth arrayPtr

peekTreePath :: Ptr NativeTreePath -> IO TreePath
peekTreePath tpPtr | tpPtr==nullPtr = return []
		   | otherwise =
  nativeTreePathGetIndices (NativeTreePath tpPtr)

fromTreePath :: Ptr NativeTreePath -> IO TreePath
fromTreePath tpPtr | tpPtr==nullPtr = return []
		   | otherwise = do
  path <- nativeTreePathGetIndices (NativeTreePath tpPtr)
  nativeTreePathFree (NativeTreePath tpPtr)
  return path