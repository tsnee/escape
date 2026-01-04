module Load (loadText) where

import Prelude

import Effect.Aff (Aff)
import Fetch (Method(..), fetch)

loadText :: String -> Aff String
loadText url = do
  { text } <- fetch url { method: GET }
  text
