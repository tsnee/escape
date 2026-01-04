module Systems (systems) where

import System (System)
import Systems.Movement (movement)
import Systems.Resize (resize)

systems ∷ Array System
systems = [ movement, resize ]
