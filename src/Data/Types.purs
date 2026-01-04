module Data.Types (Action(..), Frame, PlayerControlled, Result(..), Seed, TurnCount) where

import Prelude

import Data.Draw (Draw)
import Data.Entity (Entity)
import Data.GridLoc (GridLoc)

data Action = Move Entity GridLoc | ResizeCanvas Int Int
type Frame = Array Draw
type PlayerControlled = Unit
data Result = Moved Entity GridLoc | ResizedCanvas Int Int
type Seed = Int
type TurnCount = Int
