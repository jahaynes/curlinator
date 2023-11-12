module Class where

import Types

class Output m where
    output :: Var -> m ()

class Get m where
    getJson :: String -> m Var
    getPlain :: String -> m Var

class Post m where
    postJson :: String -> m Var

class Json m where

    dot :: String -> Var -> m Var

    arr :: Var -> m Var
