{-# LANGUAGE MultiParamTypeClasses, FlexibleInstances, FunctionalDependencies #-}

module Main (main) where

import Data.Function (on)
import Data.List (sortBy)
import qualified System.Random as R
import qualified CommandLine as CL
import Data.List (intercalate)
import GazVec

--- Support nonsense for generating points and printing things out
into2 (a:b:xs) = [a,b] : into2 xs
randomPoints seed = map makeGV2FromVec $ into2 $ R.randomRs (0,1) (R.mkStdGen seed)
braceAndComma xs = "[" ++ intercalate "," xs ++ "]\n"
makeJson v =  braceAndComma $ map show (gv2intoVec v)
makeHullJson chull = braceAndComma (map makeJson chull)

-- Instance infomation for convHull w GV2
name = "objs"
numOfObjs = 3
seed = 123
complexity = 100

main =
  let
    objList seed =  convHullGV2 (take complexity (randomPoints seed)) : objList (seed +1)
    finalJSON = name ++ "=" ++ braceAndComma (map makeHullJson (take numOfObjs (objList seed)))
    oneHullPoints = take 9 $ randomPoints 10
    xSortedOneHullPoints = sortBy (compare `on` x) oneHullPoints
    oneHull = convHullGV2 oneHullPoints

    (fst:xs) = xSortedOneHullPoints
    sortedByangle = fst : sortByAngleGV2 (makeGV2 0 1) fst xs
   

  in do
    putStrLn "Original points"
    putStrLn  $ makeHullJson oneHullPoints

    putStrLn "Sorted X"
    putStrLn  $ makeHullJson  xSortedOneHullPoints

    putStrLn "Sorted X and then angle"
    putStrLn  $ makeHullJson sortedByangle

    putStrLn "Hull"
    putStrLn  $ makeHullJson oneHull

