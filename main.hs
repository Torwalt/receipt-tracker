module Main where

-- | The entry point of the program
main :: IO ()
main = putStrLn "Hello, World!"

data UserInput a
  = FromKeyboard a
  | FromTextToSpeech a

data Address = Address
  { street :: String,
    postalCode :: String
  }

myAddress = Address {street = "asd", postalCode = "foo"}

otherAddress = myAddress {street = "das"}

firstInput = FromKeyboard "a"
secondInput = FromKeyboard 2

myCity = street myAddress
