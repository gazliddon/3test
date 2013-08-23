import System.Random
import Data.List
import Data.Function

-- 3d Points - 9 lines for a simple vector class
data Point = Pt {x,y,z :: Float} deriving (Show)
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

    (firstPoint:pointsSortedByX) = sortBy (compare `on` x) xs

sortFunc myUp base a b = compare (angleFromVec myUp base a) (angleFromVec myUp base b)

sortByAngle myUp base = sortBy (sortFunc myUp base)

--- Support nonsense for generating points and printing things out
into3 (a:b:c:xs) = (a,b,c) : into3 xs

randomPoints seed = map (\(x,y,z) -> Pt x y 0) $ into3 $ randomRs (0,1) (mkStdGen seed)

generator:: (Num a) => (a -> a) -> [a -> a] -> Integer -> [[a]]
generator fn funs n
  | n == 0 = []
  | otherwise = (map ($ v) funs) : generator fn funs (n-1)
  where
    floatingN = fromIntegral n
    v = fn (fromIntegral ( 1.0 / floatingN))

circPoints3 n = generator (* (2 * pi)) [(cos),(sin),(* 0.0)] n


cp = map (\[x, y, z] -> (Pt x y z)) (circPoints3 10)


circPoints n 
  | n == 0 = []
  | otherwise = Pt (cos pos) (sin pos) 0 : circPoints (n - 1)
  where
   floatn = fromIntegral n
   pos = (2 * pi / floatn) * floatn

makeJson (Pt x y z) = "[ " ++ show x ++ ", " ++ show y ++ ", " ++ show z ++ "]" 

printHull name chull = do
    putStr $ name ++ " = [\n  "
    putStrLn $ intercalate ",\n  " (map makeJson chull)
    putStr "]\n"

-- Test
main = printHull "obj" $ convHull (take 400 (randomPoints 123))
  
