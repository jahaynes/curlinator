module Class where

import Types

class Output m where
    output :: Var -> m ()

class Get m where
    getRequest :: String -> m Var

class Post m where
    postRequest :: String -> m Var