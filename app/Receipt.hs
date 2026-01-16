module Receipt
  ( ReceiptComponent (..),
    parse,
  )
where

import Data.Char (isSpace)
import Data.List (dropWhileEnd)
import GHC.TypeLits (Natural)

data Company = Company {compName :: String, compAddress :: String} deriving (Show)

data Item = Item {itemName :: String, itemPrice :: Price, count :: Natural} deriving (Show)

data Price = Price {full :: Natural, cents :: Natural, tax :: Bool} deriving (Show)

newtype GivenSum = GivenSum {price :: Price} deriving (Show)

data ReceiptComponent
  = RCCompany Company
  | RCItem Item
  | RCSum GivenSum
  deriving (Show)

type Step a = [String] -> (a, [String])

type ParseStep = Step [ReceiptComponent]

parse :: String -> [ReceiptComponent]
parse s = runSteps [parseCompanyStep] (map trim $ lines s)

runSteps :: [ParseStep] -> [String] -> [ReceiptComponent]
runSteps [] _ = []
runSteps (s : ss) ls =
  let (comps, ls') = s ls
   in comps ++ runSteps ss ls'

parseCompanyStep :: ParseStep
parseCompanyStep (name : a1 : a2 : rest) = ([RCCompany (Company name (unwords [a1, a2]))], rest)
parseCompanyStep ls = ([RCCompany (Company "" "")], ls)

trim :: String -> String
trim = dropWhileEnd isSpace . dropWhile isSpace
