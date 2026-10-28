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

   Comp_Max : constant := 2 ** 24;
   subtype Comp is Big range -Comp_Max .. Comp_Max;

   type Vec is record
      X, Y : Comp := 0;
   end record;

   Zero : constant Vec := (0, 0);

   function Norm2 (V : Vec) return Big is (V.X * V.X + V.Y * V.Y);

   --  Saturate a value into Comp.
   function Sat (X : Big) return Comp is
     (if X > Comp_Max then Comp_Max elsif X < -Comp_Max then -Comp_Max else X);

   --  Integer square root (floor); only used as a scaling hint.
   function Isqrt (N : Big) return Big
     with Pre  => N >= 0 and N <= 2 ** 50,
          Post => Isqrt'Result in 0 .. 2 ** 26;

   Max_Limit : constant := 2 ** 20;
   subtype Limit_T is Big range 0 .. Max_Limit;

   --  Scale V down so that |V| <= M (Euclidean).
   function Limit (V : Vec; M : Limit_T) return Vec
     with Post => Norm2 (Limit'Result) <= M * M;

   --  Scale V so that Lo <= |V| <= Hi (Euclidean).
   function Clamp_Speed (V : Vec; Lo, Hi : Limit_T) return Vec
     with Pre  => 1 <= Lo and Lo <= Hi,
          Post => Norm2 (Clamp_Speed'Result) in Lo * Lo .. Hi * Hi;

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
