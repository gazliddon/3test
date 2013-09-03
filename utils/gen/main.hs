
module Main (main) where

import Data.Function (on)
import qualified System.Random as R
import qualified CommandLine as CL
import Data.List (intercalate, sortBy)

import GazVec

--- Support nonsense for generating points and printing things out
into2 (a:b:xs) = [a,b] : into2 xs
randomPoints seed = map makeGV2FromVec $ into2 $ R.randomRs (0,1) (R.mkStdGen seed)
braceAndComma xs = "[" ++ intercalate "," xs ++ "]\n"
hullAsJson =  braceAndComma . map show . gv2intoVec

-- Instance infomation for convHull w GV2
objList seed complexity =  (convHullGV2 . take complexity . randomPoints) seed : objList (seed +1) complexity
objsToJson name numOfObjs seed complexity = braceAndComma . map hullAsJson . take numOfObjs $ objList seed complexity

makeIt comLine =
  let
    ( seed, complexity, name, numOfObjs ) = (CL.seed comLine, CL.complexity comLine, "obj", CL.numOfObjs comLine)
  in
    ( objsToJson name numOfObjs seed complexity, "oof")

writeIt ( contents : fileName) = "wrote " ++ fileName

commandLineToFile comLine
  | CL.outFile comLine == "" = ("error","No file to write")
  | otherwise = (writeIt . makeIt) comLine

main = do
    comLine <- CL.commandLine
    putStrLn (commandLineToFile comLine)


