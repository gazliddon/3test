module Gaz.Vec3 ( Vec3
                , sub
                , add
                , dot
                , scalarMultiply
                , scalarDivide
                , lenSqr
                , len
                , unit) where

data Vec3 = V3 {x,y,z :: Float} deriving (Show)

fromArray [xx,yy,zz] = V3 xx yy zz
sub (V3 x y z) (V3 x1 y1 z1) = V3 (x-x1) (y-y1) (z-z1)
add (V3 x y z) (V3 x1 y1 z1) = V3 (x+x1) (y+y1) (z+z1)
dot (V3 x y z) (V3 x1 y1 z1) = x*x1 + y*y1 + z*z1 
scalarMultiply val (V3 x y z) = V3 (x*val) (y*val) (z*val)
scalarDivide val = scalarMultiply (1/val)
lenSqr p = dot p p
len p = sqrt $ lenSqr p
unit p = scalarDivide (len p) p

