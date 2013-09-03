{-# LANGUAGE MultiParamTypeClasses, FlexibleInstances #-}

module GazVec where

import Data.Function (on)
import Data.List (sortBy)
import Data.Vec
import ConvHull 

type GV2 = Vec2 Double
type GV3 = Vec3 Double

makeGV2 x y = x:.y:.() :: GV2
gv2intoVec v = [x v,y v]
makeGV2FromVec (x:y:_) = makeGV2 x y

makeGV3 x y z = x:.y:.z:.() :: GV3
makeGV3FromVec (x:y:z:_) = makeGV3 x y z
gv3intoVec v = [x v,y v,z v]

x v = get n0 v
y v = get n1 v
z v = get n2 v
w v = get n3 v 

gvAngleAbs :: GV2 -> GV2 -> Double
gvAngleAbs a0 a1 = angleAbs (x a0) (y a0) (x a1) (y a1)

-- 2D angle between points
angle x0 y0 x1 y1 = atan2 x1 y1 - atan2 x0 y0
angleAbs x0 y0 x1 y1  =
  if signum a == -1 then
    pi + pi + a
  else a
  where a = angle x0 y0 x1 y1

-- Instantiation of Hullable for GV2
instance Hullable GV2 Double where 
  hup = makeGV2 0 1
  sub a b = a - b
  initialSort = sortBy (compare `on` x)
  angleBetweenVectors = gvAngleAbs

convHullGV2 :: [GV2] -> [GV2]
convHullGV2 = convHull


