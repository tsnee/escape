module Data.Model (Model(..)) where

import Data.Types (Seed, TurnCount)
import Data.World

type Model =
  { world :: World
  , seed :: Seed
  , elapsed :: TurnCount
  }
