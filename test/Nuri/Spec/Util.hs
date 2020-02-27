{-# OPTIONS_GHC -Wno-missing-signatures #-}
module Nuri.Spec.Util where


import           Text.Megaparsec.Pos

import           Nuri.Expr
import           Nuri.Stmt
import           Nuri.Literal

initPos :: Pos
initPos = pos1

litNone = Lit initPos LitNone
litInteger v = Lit initPos (LitInteger v)
litChar v = Lit initPos (LitChar v)
litReal v = Lit initPos (LitReal v)
litBool v = Lit initPos (LitBool v)
ifExpr = If initPos
binaryOp = BinaryOp initPos
unaryOp = UnaryOp initPos
var = Var initPos
funcCall = FuncCall initPos
lambda = Lambda initPos

funcDecl = FuncDecl initPos
constDecl = ConstDecl initPos

funcDeclStmt = ((DeclStmt .) .) . funcDecl
constDeclStmt = (DeclStmt .) . constDecl
