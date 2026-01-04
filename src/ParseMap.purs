module ParseMap (extractEntitiesFromMap, extractPositionsFromMap, extractVisiblesFromMap, parseMap) where

import Components.Position (Position(..))
import Components.Visible (Visible)
import Data.Entity (Entity(..))
import Data.GameMap (GameMap(..))

extractEntitiesFromMap ∷ GameMap → Array Entity
extractEntitiesFromMap _ = []

extractPositionsFromMap ∷ GameMap → Array Position
extractPositionsFromMap _ = []

extractVisiblesFromMap ∷ GameMap → Array Visible
extractVisiblesFromMap _ = []

parseMap ∷ String → GameMap
parseMap _ = GameMap
