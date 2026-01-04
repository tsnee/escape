module Data.World (World(..), mkWorld) where

import Prelude

import Components.Position (Position(..))
import Components.Visible (Visible)
import Data.Color (black, white)
import Data.Entity (Entity(..))
import Data.GridLoc (GridLoc(..))
import ParseMap (extractEntitiesFromMap, extractPositionsFromMap, extractVisiblesFromMap, parseMap)

type World =
  { entities ∷ Array Entity
  , positions ∷ Array Position
  , visibles ∷ Array Visible
  }

mkWorld ∷ String → World
mkWorld rawMap = { entities, positions, visibles }
  where
  map = parseMap rawMap
  entities = extractEntitiesFromMap map <> [ Entity 0 ]
  positions = extractPositionsFromMap map <> [ Position (GridLoc 0 0) ]
  visibles = extractVisiblesFromMap map <> [ { glyph: '@', foreground: white, background: black } ]
