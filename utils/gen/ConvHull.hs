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
  sortByAngle basis v0 = sortBy (compare `on` getSortAngle basis v0 ) 

  convHull :: [vec] -> [vec]
  convHull xs = recur startPoint hup sortedByX
    where
      ( startPoint : sortedByX ) = initialSort xs

      recur currentPoint dividingLine  xs
        | currentPoint /= startPoint && angle startPoint <= angle closest = [startPoint]
        | otherwise =  closest : recur closest newDividingLine sortedByAngle
        
        where
          (closest : sortedByAngle ) = sortByAngle dividingLine currentPoint xs
          angle = getSortAngle dividingLine currentPoint
          newDividingLine = (closest `sub` currentPoint)


