module Main (main) where

import qualified System.Random as R
import qualified Data.List as DL
import qualified Data.Function as DF

-- 3d Points - 9 lines for a simple vector class

data Point = Pt {x,y,z :: Float} deriving (Show)
fromArray [xx,yy,zz] = Pt xx yy zz
sub (Pt x y z) (Pt x1 y1 z1) = Pt (x-x1) (y-y1) (z-z1)
add (Pt x y z) (Pt x1 y1 z1) = Pt (x+x1) (y+y1) (z+z1)
dot (Pt x y z) (Pt x1 y1 z1) = x*x1 + y*y1 + z*z1 
scalarMultiply val (Pt x y z) = Pt (x*val) (y*val) (z*val)
scalarDivide val = scalarMultiply (1/val)
lenSqr p = dot p p
len p = sqrt $ lenSqr p
unit p = scalarDivide (len p) p


-- 2D angle between vectors / ignores z
twopi = 2 * pi
angle (Pt x y _) (Pt x1 y1 _) = atan2 x1 y1 - atan2 x y

angleAbs v v1 
  | a < 0 = twopi +a
  | otherwise = a
  where a = angle v v1

angleFromVec myUp base a = angleAbs myUp (a `sub` base)

-- Build a convex hull from a cloud of random points on x,y plane
-- outputs CW ordered points of hull
convHull xs =

  recur (Pt 0 1 0) $ sortByAngle (Pt 0 1 0) firstPoint pointsSortedByX

  where
    recur lastAngle (currentPoint:xs)
      | angleFromHere firstPoint <= angleFromHere closest = [firstPoint]
      | otherwise = closest : recur (sub closest currentPoint) sorted
      where
        (closest:sorted) = sortByAngle lastAngle currentPoint xs
        angleFromHere =    angleFromVec lastAngle currentPoint

    (firstPoint:pointsSortedByX) = DL.sortBy (compare `DF.on` x) xs

sortFunc myUp base a b = compare (angleFromVec myUp base a) (angleFromVec myUp base b)
sortByAngle myUp base = DL.sortBy (sortFunc myUp base)

--- Support nonsense for generating points and printing things out
into3 (a:b:c:xs) = (a,b,c) : into3 xs
randomPoints seed = map (\(x,y,z) -> Pt x y 0) $ into3 $ R.randomRs (0,1) (R.mkStdGen seed)

generator fn funs n
  | n == 0 = []
  | otherwise = (map ($ v) funs) : generator fn funs (n - 1)
  where
    v = fn  $ 1.0 / (fromIntegral n)

circPoints n = map fromArray $ generator (* (2 * pi)) [cos,sin,(*0)] n
cp = circPoints 10

makeJson (Pt x y z) = "[ " ++ show x ++ ", " ++ show y ++ ", " ++ show z ++ "]" 

hullStr chull = do
    "[" ++ (DL.intercalate "," (map makeJson chull)) ++ "]"

-- Test
name = "objs"
numOfObjs = 30
seed = 123
complexity = 100

objList seed =  convHull (take complexity (randomPoints seed)) : objList (seed +1)

main =
  let
    wrapBrace x = "[" ++ x ++ "]"
    hullToStr h = wrapBrace $ concatMap makeJson h
    hullStr = name ++ "=" ++ (wrapBrace $ concatMap hullToStr (take numOfObjs (objList seed)))
  in do
    putStrLn hullStr

