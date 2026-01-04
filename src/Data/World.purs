module Data.World (World(..), mkWorld) where

import Components.Position (Position(..))
import Components.Visible (Visible)
import Data.Color (black, white)
import Data.GridLoc (GridLoc(..))
import Data.Entity (Entity(..))

type World =
  { entities :: Array Entity
  , positions :: Array Position
  , visibles :: Array Visible
  }

mkWorld :: World
mkWorld =
  { entities: [ Entity 0 ]
  , positions: [ Position (GridLoc 0 0) ]
  , visibles: [ { glyph: '@', foreground: white, background: black } ]
  }
