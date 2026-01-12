module Receipt
  ( ReceiptComponent (..),
    parseNoop,
    parse,
    Company,
  )
where

import GHC.TypeLits (Natural)

parseNoop :: String -> ReceiptComponent
parseNoop x = RCCompany (Company {compName = "REWE Markt K. Feibig oHG", compAddress = "Auerbacher Str. 10-14 14193 Berlin"})

data Company = Company {compName :: String, compAddress :: String} deriving (Show)

data Item = Item {itemName :: String, itemPrice :: Price, count :: Natural} deriving (Show)

data Price = Price {full :: Natural, cents :: Natural, tax :: Bool} deriving (Show)

newtype GivenSum = GivenSum {price :: Price} deriving (Show)

data ReceiptComponent
  = RCCompany Company
  | RCItem Item
  | RCSum GivenSum
  deriving (Show)

parse :: String -> [ReceiptComponent]
parse = pure . RCCompany . parseCompany . lines

parseCompany :: [String] -> Company
parseCompany (name : a1 : a2 : _ ) = Company name (unwords [a1, a2])
parseCompany _ = Company {compName = "", compAddress = ""}
