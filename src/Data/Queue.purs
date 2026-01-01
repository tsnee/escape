module Data.Queue (Queue, enqueue, make, toList) where

import Prelude

import Data.List.Lazy (List, nil, reverse, (:))

data Queue a = Queue (List a)

instance showQueue :: Show a => Show (Queue a) where
  show (Queue xs) = show xs

make :: forall a. Queue a
make = Queue nil

enqueue :: forall a. Queue a -> a -> Queue a
enqueue (Queue xs) x = Queue $ x : xs

toList :: Queue ~> List
toList (Queue xs) = reverse xs
