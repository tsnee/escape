module Systems.Movement (movement) where

import Prelude

import Component (entities, lookup, replaceAt)
import Components.Positioned (Positioned(..))
import Data.Array (snoc)
import Data.Entity (Entity)
import Data.GridLoc (GridLoc(..))
import Data.InputEvent (InputEvent(..))
import Data.Key (Key(..))
import Data.List.Lazy (foldl)
import Data.Maybe (Maybe, fromMaybe)
import Data.Model (Model)
import Data.Queue (Queue, toArray)
import Data.Types (Action(..), Result(..))
import System (Phase, System)

movement ∷ System
movement = { plan, execute, resolve }

plan ∷ Phase (Queue InputEvent) (Array Action)
plan model inputQ = bind (toArray inputQ) $ handleKeypress model

execute ∷ Phase (Array Action) (Array Result)
execute _ actions = bind actions f
  where
  f ∷ Action → Array Result
  f (Move e loc) = [ Moved e loc ]
  f _ = []

resolve ∷ Phase (Array Result) Model
resolve model results = foldl f model results
  where
  f ∷ Model → Result → Model
  f m (Moved e loc) =
    m
      { world = m.world
          { positions = replaceAt e (Positioned loc) m.world.positions }
      }
  f m _ = m

handleKeypress ∷ Model → InputEvent → Array Action
handleKeypress model (KeyDown UpperLeft) = act model (-1) (-1)
handleKeypress model (KeyDown Up) = act model 0 (-1)
handleKeypress model (KeyDown UpperRight) = act model 1 (-1)
handleKeypress model (KeyDown Right) = act model 1 0
handleKeypress model (KeyDown LowerRight) = act model 1 1
handleKeypress model (KeyDown Down) = act model 0 1
handleKeypress model (KeyDown LowerLeft) = act model (-1) 1
handleKeypress model (KeyDown Left) = act model (-1) 0
handleKeypress _ _ = []

act ∷ Model → Int → Int → Array Action
act model dx dy = foldl movePlayer [] allEntities
  where
  allEntities = entities model.world.entities

  movePlayer ∷ Array Action → Entity → Array Action
  movePlayer acc = fromMaybe acc <<< maybeMovePlayer acc

  maybeMovePlayer ∷ Array Action → Entity → Maybe (Array Action)
  maybeMovePlayer acc e = do
    lookup e model.world.players
    Positioned (GridLoc x y) ← lookup e model.world.positions
    let
      newLoc = GridLoc (x + dx) (y + dy)
      action = Move e newLoc
      acc' = snoc acc action
    pure acc'
