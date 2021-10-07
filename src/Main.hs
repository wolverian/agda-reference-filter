{-# LANGUAGE OverloadedStrings #-}
module Main where

import qualified Data.HashMap.Strict as HashMap
import Data.HashMap.Strict (HashMap)
import qualified Data.Text as T
import Data.Text (Text)
import Data.Maybe
import Data.List

import System.Environment
import System.Exit

import Text.Pandoc.Definition
import Text.HTML.TagSoup
import Text.Pandoc.Walk
import Text.Pandoc.JSON


main :: IO ()
main = toJSONFilter linkDocument

linkDocument :: Pandoc -> Pandoc
linkDocument (Pandoc meta blocks) =
  let hm = parseSymbolRefs blocks
   in Pandoc meta (walk (link hm) blocks)

link :: HashMap Text Text -> Inline -> Inline
link hm (Code attrs xs)
  | Just sp <- HashMap.lookup xs hm = RawInline (Format "html") sp
link _ x = x

parseSymbolRefs :: [Block] -> HashMap Text Text
parseSymbolRefs = go mempty . concat . mapMaybe getHTML where
  getHTML (RawBlock (Format x) xs)
    | x == "html" = Just (parseTags (T.unpack xs))
  getHTML _ = Nothing

  go map (TagOpen "a" meta:TagText t:TagClose "a":xs)
    | Just id <- lookup "id" meta, Just cls <- lookup "class" meta
    = go (HashMap.insert (T.pack t) (T.pack (renderTags tags)) map) xs
    | otherwise = go map xs
    where
      tags = [ TagOpen "span" [("class", "Agda")], TagOpen "a" meta', TagText t, TagClose "a", TagClose "span" ]
      meta' = filter ((/= "id") . fst) meta
  go map (_:xs) = go map xs
  go map [] = map
