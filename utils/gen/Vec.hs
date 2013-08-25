module GazVec (Vec3) where

import qualified Data.Vec as V

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

