{-# LANGUAGE CPP #-}
-- -*-haskell-*-
--  GIMP Toolkit (GTK) Widget SourceView
--
--  Author : Peter Gavin
--  derived from sourceview bindings by Axel Simon and Duncan Coutts
--
--  Created: 18 December 2008
--
--  Copyright (C) 2004-2008 Peter Gavin, Duncan Coutts, Axel Simon
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
module Graphics.UI.Gtk.SourceView.SourceLanguage (
-- * Types
  SourceLanguage,
  SourceLanguageClass,

-- * Methods
  castToSourceLanguage,
  sourceLanguageGetId,
  sourceLanguageGetName,
  sourceLanguageGetSection,
  sourceLanguageGetHidden,
  sourceLanguageGetMetadata,
  sourceLanguageGetMimeTypes,
  sourceLanguageGetGlobs,

-- * Attributes
  sourceLanguageHidden,
  sourceLanguageId,
  sourceLanguageName,
  sourceLanguageSection
  ) where

import Control.Monad	(liftM)
import Data.Maybe (fromMaybe)

import System.Glib.FFI
import System.Glib.UTFString
{#import System.Glib.Properties#}
import System.Glib.Attributes
{#import Graphics.UI.Gtk.SourceView.Types#}
{#import Graphics.UI.Gtk.SourceView.SourceStyleScheme#}

{# context lib="gtk" prefix="gtk" #}


-- methods

-- | Returns the ID of the language. The ID is not locale-dependent.
--
sourceLanguageGetId :: SourceLanguage
                    -> IO String -- ^ returns  the ID of language. The returned string is owned by language and should not be freed or modified.
sourceLanguageGetId sl =
  {#call unsafe source_language_get_id#} sl >>= peekUTFString

-- | Returns the localized name of the language.
--
sourceLanguageGetName :: SourceLanguage 
                      -> IO String -- ^ returns  the name of language. The returned string is owned by language and should not be freed or modified.
sourceLanguageGetName sl =
  {#call unsafe source_language_get_name#} sl >>= peekUTFString

-- | Returns the localized section of the language. Each language belong to a section (ex. HTML belogs to
-- the Markup section).
--
sourceLanguageGetSection :: SourceLanguage 
                         -> IO String -- ^ returns  the section of language. The returned string is owned by language and should not be freed or modified.
sourceLanguageGetSection sl =
  {#call unsafe source_language_get_section#} sl >>= peekUTFString

-- | Returns whether the language should be hidden from the user.
--
sourceLanguageGetHidden :: SourceLanguage 
                        -> IO Bool -- ^ returns  'True' if the language should be hidden, 'False' otherwise. 
sourceLanguageGetHidden sl = liftM toBool $
  {#call unsafe source_language_get_hidden#} sl

-- |
--
sourceLanguageGetMetadata :: SourceLanguage 
                          -> String  -- ^ @name@     metadata property name.
                          -> IO String -- ^ returns  value of property name stored in the metadata of language or emtpy if language doesn't contain that metadata
sourceLanguageGetMetadata sl name = do
  withUTFString name ({#call unsafe source_language_get_metadata#} sl) >>= peekUTFString

-- | Returns the mime types associated to this language. This is just an utility wrapper around
-- 'sourceLanguageGetMetadata ' to retrieve the "mimetypes" metadata property and split it into
-- an array.
--
sourceLanguageGetMimeTypes :: SourceLanguage 
                           -> IO [String] -- ^ returns  an array containing the mime types or emtpy if no mime types are found. The        
sourceLanguageGetMimeTypes sl = do
  mimeTypesArray <- {#call unsafe source_language_get_mime_types#} sl
  mimeTypes <- liftM (fromMaybe []) $ maybePeek peekUTFStringArray0 mimeTypesArray
  {# call g_strfreev #} mimeTypesArray
  return mimeTypes

-- | Returns the globs associated to this language. This is just an utility wrapper around
-- 'sourceLanguageGetMetadata' to retrieve the "globs" metadata property and split it into an
-- array.
--
sourceLanguageGetGlobs :: SourceLanguage 
                       -> IO [String] -- ^ returns  an array containing the globs or empty if no globs are found. 
sourceLanguageGetGlobs sl = do
  globsArray <- {#call unsafe source_language_get_globs#} sl
  globs <- liftM (fromMaybe []) $ maybePeek peekUTFStringArray0 globsArray
  {# call g_strfreev #} globsArray
  return globs

-- | Whether the language should be hidden from the user.
-- 
-- Default value: 'False'
--
sourceLanguageHidden :: ReadAttr SourceLanguage Bool
sourceLanguageHidden = readAttrFromBoolProperty "hidden"

-- | Language id.
-- 
-- Default value: \"\"
--
sourceLanguageId :: ReadAttr SourceLanguage String
sourceLanguageId = readAttrFromStringProperty "id"

-- | Language name.
-- 
-- Default value: \"\"
--
sourceLanguageName :: ReadAttr SourceLanguage String
sourceLanguageName = readAttrFromStringProperty "name"

-- | Language section.
-- 
-- Default value: \"\"
--
sourceLanguageSection :: ReadAttr SourceLanguage String
sourceLanguageSection = readAttrFromStringProperty "section"
