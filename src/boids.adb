package body Boids with SPARK_Mode is

   function Isqrt (N : Big) return Big is
      Lo : Big := 0;
      Hi : Big := 2 ** 26;   --  (2**26)**2 > 2**50 >= N
      Mid : Big;
   begin
      while Hi - Lo > 1 loop
         pragma Loop_Invariant (0 <= Lo and Lo < Hi and Hi <= 2 ** 26);
         pragma Loop_Variant (Decreases => Hi - Lo);
         Mid := Lo + (Hi - Lo) / 2;
         if Mid * Mid <= N then
            Lo := Mid;
         else
            Hi := Mid;
         end if;
      end loop;
      return Lo;
   end Isqrt;

   function Scale (V : Vec; Num, Den : Big) return Vec
     with Pre => Num in 0 .. Max_Limit + 2 and Den >= 1;

   function Scale (V : Vec; Num, Den : Big) return Vec is
     (X => Sat (V.X * Num / Den), Y => Sat (V.Y * Num / Den));

   function Limit (V : Vec; M : Limit_T) return Vec is
      N : constant Big := Norm2 (V);
      R : Vec;
   begin
      if N <= M * M then
         return V;
      end if;
      R := Scale (V, M, Isqrt (N) + 1);
      if Norm2 (R) <= M * M then
         return R;
      end if;
      return Zero;   --  fallback, never expected; keeps the bound exact
   end Limit;

   function Clamp_Speed (V : Vec; Lo, Hi : Limit_T) return Vec is
      N : constant Big := Norm2 (V);
      R : Vec;
   begin
      if N in Lo * Lo .. Hi * Hi then
         return V;
      elsif N = 0 then
         return (X => Lo, Y => 0);
      elsif N > Hi * Hi then
         R := Scale (V, Hi, Isqrt (N) + 1);
      else
         R := Scale (V, Lo + 2, Big'Max (1, Isqrt (N)));
      end if;
      if Norm2 (R) in Lo * Lo .. Hi * Hi then
         return R;
      end if;
      return (X => Lo, Y => 0);   --  fallback; keeps the bound exact
   end Clamp_Speed;

   function Torus_Delta (A, B : Coord; Size : World_Size) return Delta_T is
      D : constant Big := B - A;
   begin
      if D > Size / 2 then
         return D - Size;
      elsif D < -(Size / 2) then
         return D + Size;
      else
         return D;
      end if;
   end Torus_Delta;

   function Wrap (P : Big; Size : World_Size) return Coord is
     (P mod Size);

end Boids;
