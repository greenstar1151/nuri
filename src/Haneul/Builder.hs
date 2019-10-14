module Haneul.Builder where

import           Control.Monad.RWS                        ( RWS )
import           Control.Lens                             ( makeLenses
                                                          , modifying
                                                          , use
                                                          )
import           Control.Lens.TH                          ( )
import           Data.Set.Ordered                         ( OSet
                                                          , (|>)
                                                          , findIndex
                                                          )

import           Text.Megaparsec.Pos                      ( Pos )

import           Haneul.Instruction
import           Haneul.Constant

data BuilderInternal = BuilderInternal {_constTable :: OSet Constant, _varNames :: OSet Text}
  deriving (Eq, Show)

$(makeLenses ''BuilderInternal)

addVarName :: Text -> Builder Int
addVarName ident = do
  modifying varNames (|> ident)
  names <- use varNames
  let (Just index) = findIndex ident names
  return index

addConstant :: Constant -> Builder Int
addConstant value = do
  modifying constTable (|> value)
  names <- use constTable
  let (Just index) = findIndex value names
  return index

type Builder = RWS () [(Pos, Instruction)] BuilderInternal
