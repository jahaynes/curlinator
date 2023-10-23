module Types where

newtype Var =
    Var Char
        deriving Enum

instance Show Var where
    show (Var c) = [c]
