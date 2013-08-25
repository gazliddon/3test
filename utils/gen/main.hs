module Main (main) where

import qualified System.Random as R
import qualified Data.List as DL
import qualified Data.Function as DF
import qualified Data.Vec as V
import qualified GazVec as GV
import CommandLine
import qualified ConvHull as CH 


-- Some helpy functions to use Data.Vec
funcsToArray obj funcs = map ($ obj) funcs

makeV3 x y z = V.Vec3F x y z
makeV3FromArray [x,y,z] = makeV3 x y z
arrayFromV3 v = funcsToArray v [x,y,z]  

makeV2 x y = V.Vec2F x y
makeV2FromArray [x,y] = makeV2 x y
arrayFromV2 v = funcsToArray v [x,y]  

x v = V.get V.n0 v
y v = V.get V.n1 v
z v = V.get V.n2 v

-- 2D angle between vectors / ignores z
twopi = 2 * pi
angle v0 v1 = atan2 (x v1) (y v1) - atan2 (x v0) (y v0)
angleAbs v v1 = if a < 0 then twopi + a else a where a = angle v v1
angleFromVec myUp base a = angleAbs myUp (a - base)

-- Build a convex hull from a cloud of random points on x,y plane
-- outputs CW ordered points of hull
convHull :: [V.Vec3F] -> [V.Vec3F]
convHull xs =
  
  recur up $ sortByAngle up firstPoint pointsSortedByX

  where
    up = makeV3 0 1 0

    recur lastAngle (currentPoint:xs)
      | angleFromHere firstPoint <= angleFromHere closest = [firstPoint]
      | otherwise = closest : recur (closest - currentPoint) sorted
      where
        (closest:sorted) = sortByAngle lastAngle currentPoint xs
        angleFromHere =    angleFromVec lastAngle currentPoint

    (firstPoint:pointsSortedByX) = DL.sortBy (compare `DF.on` x) xs

sortFunc myUp base a b = compare (angleFromVec myUp base a) (angleFromVec myUp base b)
sortByAngle myUp base = DL.sortBy (sortFunc myUp base)

--- Support nonsense for generating points and printing things out
into3 (a:b:c:xs) = [a,b,c] : into3 xs
randomPoints seed = map makeV3FromArray $ into3 $ R.randomRs (0,1) (R.mkStdGen seed)
randomPoints2 seed = into3 $ R.randomRs (0,1) (R.mkStdGen seed)

generator fn funs n
  | n == 0 = []
  | otherwise = map ($ v) funs : generator fn funs (n - 1)
  where
    v = fn  $ 1.0 / fromIntegral n

circPoints n =  map makeV3FromArray $ generator (* (2 * pi)) [cos,sin,(*0)] n

braceAndComma xs = "[" ++ (DL.intercalate "," xs) ++ "]"

makeJson v =  braceAndComma $ map show (arrayFromV3 v)
makeHullJson chull = braceAndComma (map makeJson chull)
myHull = head (objList 1)

toJson v = braceAndComma $ map show (GV.gv2intoVec v)
newHull = CH.convHull $ map GV.makeGV2FromVec (take 100 (into3 $ R.randomRs (0,1) (R.mkStdGen seed)))

-- Test
name = "objs"
numOfObjs = 30
seed = 123
complexity = 100

objList seed =  convHull (take complexity (randomPoints seed)) : objList (seed +1)


main =
  let
    finalJSON = name ++ "=" ++ braceAndComma (map makeHullJson (take numOfObjs (objList seed)))
  in do
    putStrLn finalJSON
    putStrLn "Done1"

