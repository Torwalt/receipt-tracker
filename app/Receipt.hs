module Receipt
  ( ReceiptComponent (..),
    parse,
    Company,
  )
where

import GHC.TypeLits (Natural)

data Company = Company {compName :: String, compAddress :: String} deriving (Show)

data Item = Item {itemName :: String, itemPrice :: Price, count :: Natural}

data Price = Price {full :: Natural, cents :: Natural, tax :: Bool}

newtype GivenSum = GivenSum {price :: Price}

data ReceiptComponent
  = RCCompany Company
  | RCItem Item
  | RCSum GivenSum

parse :: String -> ReceiptComponent
parse x = RCCompany (Company {compName = "REWE Markt K. Feibig oHG", compAddress = "Auerbacher Str. 10-14 14193 Berlin"})
