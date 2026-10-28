--  Boids: bounded integer vector maths for the murmuration.
--  All quantities are integers in "units"; one screen pixel = Sub units.
--  Integer (fixed-point) arithmetic is used instead of Float so that every
--  bound below is exact and provable without floating-point rounding.
package Boids with SPARK_Mode is

   Sub       : constant := 256;            --  units per pixel
   Max_Birds : constant := 2000;

   type Big is range -2 ** 62 .. 2 ** 62 - 1;

   Max_World : constant := 4096 * Sub;      --  largest world side (units)
   Min_World : constant := 64 * Sub;
   subtype World_Size is Big range Min_World .. Max_World;
   subtype Coord is Big range 0 .. Max_World - 1;

   Half_World : constant := Max_World / 2;
   subtype Delta_T is Big range -Half_World .. Half_World;

   Comp_Max : constant := 2 ** 20;
   subtype Comp is Big range -Comp_Max .. Comp_Max;

   type Vec is record
      X, Y : Comp := 0;
   end record;

   Zero : constant Vec := (0, 0);

   function Norm2 (V : Vec) return Big is (V.X * V.X + V.Y * V.Y);

   --  Largest length the vector functions are asked for (16 px = 4096).
   Max_Len : constant := 2 ** 13;
   subtype Len_T is Big range 0 .. Max_Len;

   --  If |V| <= L then each component is at most L.
   subtype Bound_T is Big range 0 .. 2 ** 14;
   procedure Lemma_Comp_Bound (V : Vec; L : Bound_T)
     with Ghost, Pre => Norm2 (V) <= L * L,
          Post => abs V.X <= L and abs V.Y <= L;

   subtype Nat30 is Big range 0 .. 2 ** 30;

   --  X*X < Y*Y implies X < Y (for non-negative X, Y)
   procedure Lemma_Sq_Rev (X, Y : Nat30)
     with Ghost, Pre => X * X < Y * Y, Post => X < Y;

   --  |D * P / Q| <= |D| when 0 <= P <= Q
   procedure Lemma_Frac (D : Delta_T; P, Q : Big)
     with Ghost, Pre => Q in 1 .. 2 ** 40 and then P in 0 .. Q,
          Post => abs (D * P / Q) <= abs D;

   --  |S| <= C * H, C >= 1 implies |S / C| <= H
   procedure Lemma_Avg (S, C, H : Big)
     with Ghost, Pre => C in 1 .. 2 ** 16 and then H in 0 .. 2 ** 24
                        and then abs S <= C * H,
          Post => abs (S / C) <= H;

   --  Integer square root (floor).
   function Isqrt (N : Big) return Big
     with Pre  => N in 0 .. 2 ** 34,
          Post => Isqrt'Result in 0 .. 2 ** 17
                  and then Isqrt'Result * Isqrt'Result <= N
                  and then N < (Isqrt'Result + 1) * (Isqrt'Result + 1);

   --  V (non-zero) rescaled to length T, within integer rounding:
   --  (T-2)^2 <= |R|^2 <= T^2 + T.
   function Rescale (V : Vec; T : Len_T) return Vec
     with Pre  => Norm2 (V) > 0,
          Post => Norm2 (Rescale'Result) <= T * T + T
                  and then (if T >= 2 then Norm2 (Rescale'Result) >= (T - 2) ** 2);

   --  V shortened if needed so that |V| <= M (Euclidean).
   function Limit (V : Vec; M : Len_T) return Vec
     with Post => Norm2 (Limit'Result) <= M * M
                  and then abs Limit'Result.X <= M and then abs Limit'Result.Y <= M;

   --  V rescaled if needed so that Lo <= |V| <= Hi (Euclidean).
   --  A zero vector has no direction; it becomes (Lo, 0).
   function Clamp_Speed (V : Vec; Lo, Hi : Len_T) return Vec
     with Pre  => 1 <= Lo and Lo + 3 <= Hi,
          Post => Norm2 (Clamp_Speed'Result) in Lo * Lo .. Hi * Hi
                  and then abs Clamp_Speed'Result.X <= Hi
                  and then abs Clamp_Speed'Result.Y <= Hi;

   --  Shortest signed offset from A to B on a ring of the given size.
   function Torus_Delta (A, B : Coord; Size : World_Size) return Delta_T
     with Pre  => A < Size and B < Size,
          Post => abs Torus_Delta'Result <= Size / 2
                  and then (Torus_Delta'Result - (B - A)) in -Size | 0 | Size;

   --  Bring P back into [0, Size).
   function Wrap (P : Big; Size : World_Size) return Coord
     with Pre  => P in -2 ** 40 .. 2 ** 40,
          Post => Wrap'Result < Size and then (Wrap'Result - P) mod Size = 0;

end Boids;
