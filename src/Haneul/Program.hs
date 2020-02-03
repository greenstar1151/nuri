module Haneul.Program where

import           Control.Lens                             ( makeLenses
                                                          , view
                                                          )
import           Control.Monad.RWS                        ( execRWS )

import           Haneul.Builder
import           Haneul.BuilderInternal
import           Haneul.Instruction
import           Haneul.Constant

data Program = Program { _programConstTable :: ConstTable, _programCode :: Code }
  deriving (Eq, Show)

toProgram :: BuilderInternal -> Builder () -> Program
toProgram internal result =
  let (internal', code) = execRWS result () internal
  in  Program (view internalConstTable internal') (clearMarks internal' code)

$(makeLenses ''Program)
