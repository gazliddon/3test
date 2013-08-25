module GazVec where

import qualified Data.Vec as V
import Data.Vec ( (:.)((:.)),getElem,Vec2,Vec3 )

type GV2 = Vec2 Double
type GV3 = Vec3 Double

makeGV2 x y = x:.y:.() :: GV2
makeGV3 x y z = x:.y:.z:.() :: GV3

makeGV2FromVec (x:y:_) = makeGV2 x y
makeGV3FromVec (x:y:z:_) = makeGV3 x y z

gv2intoVec v = [(x v),(y v)]
gv3intoVec v = [(x v),(y v),(z v)]


x v = V.get V.n0 v
y v = V.get V.n1 v
z v = V.get V.n2 v
w v = V.get V.n3 v

-- 2D angle between vectors / ignores z
twopi = 2 * pi
angle v0 v1 = atan2 (x v1) (y v1) - atan2 (x v0) (y v0)
angleAbs v v1 = if a < 0 then twopi + a else a where a = angle v v1

