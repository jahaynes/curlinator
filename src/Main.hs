module Main where

import Class
import CurlWriter

program :: (Get m, Monad m, Output m) => m ()
program = do
    a <- getRequest "https://johnhaynes.dev"
    b <- getRequest "https://johnhaynes.dev"
    output a
    output b

main :: IO ()
main = run program >>= putStrLn
