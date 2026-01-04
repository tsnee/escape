module Data.Entity (Entity(..), getIndex) where

import Prelude

import Data.Newtype (class Newtype, unwrap)

newtype Entity = Entity Int

derive instance newtypeEntity ∷ Newtype Entity _
derive newtype instance showEntity ∷ Show Entity

getIndex ∷ Entity → Int
getIndex = unwrap
