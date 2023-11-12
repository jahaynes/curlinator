module Main where

import Class
import CurlWriter

program :: (Get m, Monad m, Output m, Post m) => m ()
program = do
    a <- getJson  "127.0.0.1:8080/users"
    b <- getPlain "127.0.0.1:8080/users"
    c <- postJson "127.0.0.1:8080/users" "A user"
    output a
    output b
    output c

main :: IO ()
main = runCurlWriter program >>= putStrLn
