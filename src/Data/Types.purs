module Data.Types (Action(..), Frame, Result(..), Seed, TurnCount) where

import Data.Draw (Draw)
import Data.Entity (Entity)
import Data.GridLoc (GridLoc)

data Action = Move Entity GridLoc
type Frame = Array Draw
data Result = Moved Entity GridLoc
type Seed = Int
type TurnCount = Int
