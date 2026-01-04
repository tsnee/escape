module Systems.Movement (movement) where

import Prelude

import Components.Position (Position(..))
import Data.Action (Action(..))
import Data.Array (snoc, updateAt, (!!))
import Data.Entity (Entity, getIndex)
import Data.GridLoc (GridLoc(..))
import Data.InputEvent (InputEvent(..))
import Data.Key (Key(..))
import Data.List.Lazy (foldl)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Model (Model)
import Data.Queue (Queue, toArray)
import Data.Result (Result(..))
import System (System, Phase)

movement :: System
movement = { plan, execute, resolve }

plan :: Phase (Queue InputEvent) (Array Action)
plan model inputQ = bind (toArray inputQ) $ handleKeypress model

execute :: Phase (Array Action) (Array Result)
execute _ actions = bind actions f
  where
  f :: Action -> Array Result
  f (Move e loc) = [ Moved e loc ]

resolve :: Phase (Array Result) Model
resolve model results = foldl f model results
  where
  f :: Model -> Result -> Model
  f m (Moved e loc) = m { world = model.world { positions = fromMaybe model.world.positions $ updateAt (getIndex e) (Position loc) model.world.positions } }

handleKeypress :: Model -> InputEvent -> Array Action
handleKeypress model (KeyDown UpperLeft) = act model (-1) (-1)
handleKeypress model (KeyDown Up) = act model 0 (-1)
handleKeypress model (KeyDown UpperRight) = act model 1 (-1)
handleKeypress model (KeyDown Right) = act model 1 0
handleKeypress model (KeyDown LowerRight) = act model 1 1
handleKeypress model (KeyDown Down) = act model 0 1
handleKeypress model (KeyDown LowerLeft) = act model (-1) 1
handleKeypress model (KeyDown Left) = act model (-1) 0
handleKeypress _ _ = []

act :: Model -> Int -> Int -> Array Action
act model dx dy = foldl f [] model.world.entities
  where
  f :: Array Action -> Entity -> Array Action
  f acc e = case model.world.positions !! (getIndex e) of
    Just (Position (GridLoc x y)) -> snoc acc $ Move e $ GridLoc (x + dx) (y + dy)
    Nothing -> acc
