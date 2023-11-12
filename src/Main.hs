module Main where

import Class
import CurlWriter

program :: (Get m, Monad m, Output m) => m ()
program = do
    a <- getJson "127.0.0.1:8080/users"
    b <- getPlain "127.0.0.1:8080/users"
    output a
    output b

main :: IO ()
main = runCurlWriter program >>= putStrLn
