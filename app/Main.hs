module Main (main) where

import Control.Exception (IOException, try)
import Receipt (parse)

main :: IO ()
main = do
  eContents <- readFileE "receipts/receipt.txt"
  case eContents of
    Left err -> putStrLn ("Failed to read receipt: " ++ show err)
    Right contents ->
      mapM_ print (parse contents)

readFileE :: FilePath -> IO (Either IOException String)
readFileE fp = try (readFile fp)
