module Data.World (World(..), mkWorld) where

import Components.Position (Position)
import Components.Visible (Visible)
import Data.Color (black, white)
import Data.List.Lazy (List)
import Data.List.Lazy as List
import Data.Point (Point(..))

type World =
  { entities :: List Int
  , positions :: Array Position
  , visibles :: Array Visible
  }

mkWorld :: World
mkWorld =
  { entities: List.singleton (0)
  , positions: [ Point 0 0 ]
  , visibles: [ { glyph: '@', foreground: white, background: black } ]
  }
