module ParseMap (parseMap) where

import Prelude

import Components.Positioned (Positioned(..))
import Data.Color as Color
import Data.Either (Either)
import Data.Entity (Entity(..), succ)
import Data.Foldable (foldl)
import Data.GridLoc (GridLoc(..))
import Data.List.Lazy (singleton)
import Data.Queue (Queue(..), enqueue)
import Data.String.CodePoints as CP
import Data.String.Regex (Regex, regex, split)
import Data.String.Regex.Flags as Flags
import Data.Tuple (Tuple(..))
import Data.World (World, WorldBuilder, build, empty)

type Error = String

newtype RowNum = RowNum Int

parseMap ∷ String → Either Error World
parseMap stringMap =
  let
    buildGrid ∷ Regex → World
    buildGrid eol = build builder
      where
      rows = split eol stringMap
      cpMap = map CP.toCodePointArray rows
      firstRow = RowNum 0
      Tuple builder _ = foldl buildRow (Tuple empty firstRow) cpMap

    buildRow ∷ Tuple WorldBuilder RowNum → Array CP.CodePoint → Tuple WorldBuilder RowNum
    buildRow (Tuple wb (RowNum row)) cps = Tuple wb' nextRowNum
      where
      firstColumn = 0
      startOfRow = GridLoc firstColumn row
      Tuple wb' _ = foldl buildColumn (Tuple wb startOfRow) cps
      nextRowNum = RowNum (row + 1)

    buildColumn ∷ Tuple WorldBuilder GridLoc → CP.CodePoint → Tuple WorldBuilder GridLoc
    buildColumn (Tuple wb loc@(GridLoc x y)) cp
      | cp == CP.codePointFromChar '@' = player wb loc
      | cp == CP.codePointFromChar '#' = wall wb loc
      | cp == CP.codePointFromChar '+' = door wb loc
      | otherwise = Tuple wb $ GridLoc (x + 1) y
  in
    do
      eol ← regex "\r?\n" Flags.global
      pure $ buildGrid eol

player ∷ WorldBuilder → GridLoc → Tuple WorldBuilder GridLoc
player wb loc = Tuple wb'' loc'
  where
  Tuple wb' loc' = tile '@' wb loc
  wb'' = wb' { players = Queue (singleton (Tuple wb.nextEntity unit)) }

wall ∷ WorldBuilder → GridLoc → Tuple WorldBuilder GridLoc
wall = tile '#'

door ∷ WorldBuilder → GridLoc → Tuple WorldBuilder GridLoc
door = tile '+'

tile ∷ Char → WorldBuilder → GridLoc → Tuple WorldBuilder GridLoc
tile glyph wb loc@(GridLoc x y) = Tuple wb' loc'
  where
  entity = wb.nextEntity
  wb' = wb
    { entities = enqueue wb.entities $ Tuple entity unit
    , positions = enqueue wb.positions $ Tuple entity $ Positioned loc
    , visibles = enqueue wb.visibles $ Tuple entity { glyph: glyph, foreground: Color.white, background: Color.black }
    , nextEntity = succ entity
    }
  loc' = GridLoc (x + 1) y
