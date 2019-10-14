module Nuri.Codegen.Stmt where

import           Control.Monad.RWS                        ( tell
                                                          , execRWS
                                                          )
import           Control.Lens                             ( modifying
                                                          , use
                                                          , view
                                                          )

import           Data.Set.Ordered                         ( (|>)
                                                          , findIndex
                                                          )

import           Text.Megaparsec.Pos                      ( sourceLine )

import           Nuri.Stmt
import           Nuri.ASTNode
import           Nuri.Codegen.Expr

import           Haneul.Builder
import           Haneul.Constant
import qualified Haneul.Instruction            as Inst

compileStmt :: Stmt -> Builder ()
compileStmt stmt@(ExprStmt expr) = do
  compileExpr expr
  tell [(sourceLine (srcPos stmt), Inst.Pop)]
compileStmt stmt@(Return expr) = do
  compileExpr expr
  tell [(sourceLine (srcPos stmt), Inst.Return)]
compileStmt (Assign pos ident expr) = do
  compileExpr expr
  names <- use varNames
  case findIndex ident names of
    Nothing -> do
      modifying varNames (|> ident)
      tell [(sourceLine pos, Inst.Store (length names))]
    Just index -> tell [(sourceLine pos, Inst.Store index)]
compileStmt (If _ _ _ _                         ) = undefined
compileStmt (While _ _                          ) = undefined
compileStmt (FuncDecl pos funcName argNames body) = do
  let funcBuilder = do
        indices <- sequence (addVarName <$> argNames)
        _       <- sequence
          (   (\index -> tell [(sourceLine pos, Inst.Store index)])
          <$> reverse indices
          )
        _ <- sequence (compileStmt <$> body)
        return ()
  (internal, instructions) <- execRWS funcBuilder () <$> get
  let funcObject = ConstFunc
        (FuncObject { _arity          = fromIntegral (length argNames)
                    , _insts          = instructions
                    , _funcConstTable = view constTable internal
                    , _funcVarNames   = view varNames internal
                    }
        )
  funcObjectIndex <- addConstant funcObject
  funcNameIndex   <- addVarName funcName
  tell
    [ (sourceLine pos, Inst.Push funcObjectIndex)
    , (sourceLine pos, Inst.Store funcNameIndex)
    ]
  return ()


