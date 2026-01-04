module Data.Model (Model(..), resize) where

import Data.World

import Data.Types (Seed, TurnCount)

type Model =
  { world ∷ World
  , visibleWidth ∷ Int
  , visibleHeight ∷ Int
  , seed ∷ Seed
  , elapsed ∷ TurnCount
  }

resize ∷ Model → Int → Int → Model
resize m width height = m { visibleWidth = width, visibleHeight = height }
