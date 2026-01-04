module Data.Entity (Entity(..), succ) where

import Prelude

import Data.Newtype (class Newtype)

newtype Entity = Entity Int

derive instance newtypeEntity ∷ Newtype Entity _
derive newtype instance eqEntity ∷ Eq Entity
derive newtype instance ordEntity ∷ Ord Entity
derive newtype instance showEntity ∷ Show Entity

succ ∷ Entity → Entity
succ (Entity i) = Entity $ i + 1
