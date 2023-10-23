module HttpClient where

import Control.Monad.IO.Class (MonadIO)

newtype HttpClientIO a =
    HttpClientIO { unHttpClientIO :: IO a
                 } deriving (Functor, Applicative, Monad, MonadIO)
