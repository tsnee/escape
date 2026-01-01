module GameLogic (step, view) where

import Prelude

import Data.Array (head, (!!))
import Data.Draw (Draw(..))
import Data.InputEvent (InputEvent(..))
import Data.Key (Key(..))
import Data.List.Lazy (foldl)
import Data.Maybe (Maybe(..))
import Data.Model (Model)
import Data.Point (Point(..))
import Data.Queue (Queue, toList)
import Data.String.CodeUnits as SCU
import Data.Types (Frame)
import Data.Unfoldable (fromMaybe)
import Debug (spy)

step :: Queue InputEvent -> Model -> Model
step inputQ model = foldl f model (toList inputQ)
  where
  f :: Model -> InputEvent -> Model
  f m (KeyDown Up) = g m 0 (-1)
  f m (KeyDown Down) = g m 0 1
  f m (KeyDown Left) = g m (-1) 0
  f m (KeyDown Right) = g m 1 0
  f m _ = m

  g :: Model -> Int -> Int -> Model
  g m dx dy =
    let
      pos = case head m.world.positions of
        Just (Point x y) -> Point (x + dx) (y + dy)
        Nothing -> Point 0 0
      new = [ pos ]
    in
      { elapsed: m.elapsed + 1, seed: m.seed, world: { entities: m.world.entities, positions: new, visibles: m.world.visibles } }

view :: Model -> Frame
view { world } = bind world.entities $ fromMaybe <<< drawEntity
  where
  drawEntity :: Int -> Maybe Draw
  drawEntity i = do
    point <- world.positions !! i
    -- point <- spy "Positions " $ world.positions !! i
    visible <- world.visibles !! i
    -- visible <- spy "Visibles " $ world.visibles !! i
    pure $ DrawText point visible.foreground $ SCU.singleton visible.glyph
