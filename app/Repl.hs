module Repl where

import Control.Lens
  ( makeLenses,
    view,
  )
import Control.Lens.TH ()
import Data.Binary (encode)
import Data.Text (strip)
import qualified Data.Set.Ordered as S
import Haneul.Builder
import Haneul.BuilderInternal
import Haneul.Serial ()
import Nuri.Codegen.Stmt
import Nuri.Parse.Stmt
import Nuri.Stmt
import System.IO (hFlush)
import Text.Megaparsec
  ( eof,
    errorBundlePretty,
    runParserT,
  )
import Text.Pretty.Simple (pPrint)
import Prelude hiding (writeFile)

newtype ReplState = ReplState {_prompt :: Text}

$(makeLenses ''ReplState)

newtype Repl a = Repl {unRepl :: StateT ReplState IO a}
  deriving (Monad, Functor, Applicative, MonadState ReplState, MonadIO)

parseInput :: Text -> String -> MaybeT IO (NonEmpty Stmt)
parseInput input fileName = do
  case evalState (runParserT (parseStmts <* eof) fileName input) defaultDecls of
    Left err -> do
      (liftIO . putTextLn . toText . errorBundlePretty) err
      hoistMaybe Nothing
    Right parseResult -> return parseResult

printResult :: (NonEmpty Stmt) -> IO ()
printResult stmts = do
  (liftIO . pPrint) stmts
  let program =
        ( internalToFuncObject
            . runBuilder
              defaultInternal
                { _internalGlobalVarNames = S.fromList (snd <$> defaultDecls)
                }
            . compileStmts
        )
          stmts

  putStrLn "---------------"
  pPrint program
  putStrLn "---------------"

  let encodedProgram = encode program
  writeFileLBS "./test.hn" encodedProgram

repl :: Repl ()
repl = forever $ do
  st <- get
  liftIO $ do
    putText (view prompt st)
    hFlush stdout
  input <- strip <$> liftIO getLine
  liftIO $ when (input == ":quit") exitSuccess
  result <- (liftIO . runMaybeT . parseInput input) "(반응형)"
  case result of
    Just stmts -> liftIO (printResult stmts)
    Nothing -> pass

runRepl :: Repl a -> ReplState -> IO a
runRepl f = evalStateT (unRepl f)
