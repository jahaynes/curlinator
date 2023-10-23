module CurlWriter where

import Class    (Get (..), Output (..))
import Types    (Var (..))

import Control.Monad.Trans.Class      (lift)
import Control.Monad.Trans.State      (StateT, evalStateT, get, put)
import Control.Monad.Trans.Writer.CPS (WriterT, execWriterT, tell)
import Data.String.Interpolate        (i)

newtype CurlWriter m a =
    CurlWriter { unCurlWriter :: WriterT String (StateT Var m) a
               } deriving (Functor, Applicative, Monad)

instance Monad m => Get (CurlWriter m) where
    getRequest url = do
        v <- nextVar
        emit [i|#{v}=$(curl #{url})\n|]
        pure v

instance Monad m => Output (CurlWriter m) where
    output :: Var -> CurlWriter m ()
    output x = emit [i|echo $#{x}\n|]


emit :: Monad m => String -> CurlWriter m ()
emit = CurlWriter . tell

nextVar :: Monad m => CurlWriter m Var
nextVar = CurlWriter . lift $ do
    v <- get
    put $ succ v
    pure v

run :: Monad m => CurlWriter m a -> m String
run p = evalStateT (execWriterT (unCurlWriter p)) (Var 'A')