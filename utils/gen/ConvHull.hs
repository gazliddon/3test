module ConvHull (convHull) where

import Data.List (sortBy)
import Data.Function (on)
import GazVec

up  = makeGV2 0 1
angleFromVec myUp base a = angleAbs myUp (a - base)

convHull xs =
  
  recur up $ sortByAngle up firstPoint pointsSortedByX

  where

    recur lastAngle (currentPoint:xs)
      | angleFromHere firstPoint <= angleFromHere closest = [firstPoint]
      | otherwise = closest : recur (closest - currentPoint) sorted
      where
        (closest:sorted) = sortByAngle lastAngle currentPoint xs
        angleFromHere = angleFromVec lastAngle currentPoint

    (firstPoint:pointsSortedByX) = sortBy (compare `on` x) xs

sortByAngle myUp base = sortBy (compare `on` angleFromVec myUp base)


