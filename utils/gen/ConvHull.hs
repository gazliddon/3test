{-# LANGUAGE MultiParamTypeClasses, FlexibleInstances, FunctionalDependencies #-}

module ConvHull  where

import Data.Function (on)
import Data.List (sortBy)

class (Eq vec, Ord sortType) => Hullable vec sortType | vec -> sortType where

  hup :: vec
  sub :: vec -> vec -> vec
  initialSort :: [vec] -> [vec]
  angleBetweenVectors :: vec -> vec -> sortType

  getSortAngle :: vec -> vec -> vec -> sortType
  getSortAngle basis a b = angleBetweenVectors basis (b `sub` a)

  sortByAngle ::  vec -> vec -> [vec] -> [vec]
  sortByAngle basis v0 xs = sortBy (compare `on` getSortAngle basis v0 ) xs

  convHull :: [vec] -> [vec]
  convHull xs = 
      recur startPoint hup initiallySortedPoints
    where
      ( startPoint : initiallySortedPoints ) = initialSort xs

      recur currentPoint lastAngle  xs
        | currentPoint /= startPoint && angleFromCurrrentPoint startPoint <= angleFromCurrrentPoint closest = [startPoint]
        | otherwise =  closest : recur closest (closest `sub` currentPoint) sortedByAngle
        where
          (closest : sortedByAngle ) = sortByAngle lastAngle currentPoint xs
          angleFromCurrrentPoint = getSortAngle lastAngle currentPoint


