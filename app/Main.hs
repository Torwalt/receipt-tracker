module Main (main) where

import Control.Exception
import Path
import Receipt (ReceiptComponent (RCCompany), parse)

main :: IO ()
main = do
  let ePath = receiptDirPath
  path <- case ePath of
    Left err -> throwIO err
    Right p -> return p
  contents <- readFile $ toFilePath path
  let components = parse contents
  case components of
    RCCompany c -> print c
    _ -> return ()

receiptDirPath :: Either SomeException (Path Rel File)
receiptDirPath = parseRelFile "receipts/receipt.txt"
