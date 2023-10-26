module CurlWriter where

import Class    (Get (..), Json (..), Output (..))
import Types    (Var (..))

import Control.Monad.Trans.Class      (lift)
import Control.Monad.Trans.State      (StateT, evalStateT, get, put)
import Control.Monad.Trans.Writer.CPS (WriterT, execWriterT, tell)
import Data.String.Interpolate        (i)

newtype CurlWriter m a =
    CurlWriter { unCurlWriter :: WriterT String (StateT Var m) a
               } deriving (Functor, Applicative, Monad)

instance Monad m => Get (CurlWriter m) where
    getJson url = do
        v <- nextVar
        emit [i|#{v}=$(curl -H "Accept: application/json" #{url})\n|]
        pure v

instance Monad m => Output (CurlWriter m) where

    output x = emit [i|echo "$#{x}"\n|]

instance Monad m => Json (CurlWriter m) where
    
    dot path vIn = do
        vOut <- nextVar
        emit [i|#{vOut}=$(echo "$#{vIn}" | jq .#{path})\n|] 
        pure vOut

    arr vIn = do
        vOut <- nextVar
        emit [i|#{vOut}=$(echo "$#{vIn}" | jq .[])\n|] 
        pure vOut

emit :: Monad m => String -> CurlWriter m ()
emit = CurlWriter . tell

nextVar :: Monad m => CurlWriter m Var
nextVar = CurlWriter . lift $ do
    v <- get
    put $ succ v
    pure v

run :: Monad m => CurlWriter m a -> m String
run p = evalStateT (execWriterT $ do
                        tell "#!/bin/bash\n\n"
                        unCurlWriter p) (Var 'A')
