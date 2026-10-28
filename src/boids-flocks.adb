package body Boids.Flocks with SPARK_Mode is

   procedure Find_Neighbours
     (F : Flock; I : Bird_Index; List : out Index_List; Count : out Bird_Count)
   is
   begin
      List := (others => 1);
      Count := 0;
      for J in 1 .. F.N loop
         if Is_Neighbour (F, I, J) then
            Count := Count + 1;
            List (Count) := J;
         end if;
         pragma Loop_Invariant (Count <= J);
         pragma Loop_Invariant
           (for all K in 1 .. Count =>
              List (K) <= J and then Is_Neighbour (F, I, List (K)));
         pragma Loop_Invariant
           (for all K in 1 .. Count - 1 => List (K) < List (K + 1));
         pragma Loop_Invariant
           (for all L in 1 .. J =>
              (if Is_Neighbour (F, I, L) then
                 (for some K in 1 .. Count => List (K) = L)));
      end loop;
   end Find_Neighbours;

   --  V scaled to length M (approximately); zero stays zero.
   function Set_Length (V : Vec; M : Limit_T) return Vec is
     (if Norm2 (V) = 0 then Zero
      else (X => Sat (V.X * M / (Isqrt (Norm2 (V)) + 1)),
            Y => Sat (V.Y * M / (Isqrt (Norm2 (V)) + 1))));

   --  Reynolds steering: desired direction at Max_Speed minus the current
   --  velocity, limited to Max_Force, then weighted.
   function Steer (F : Flock; I : Bird_Index; Desired : Vec; W : Weight_T)
     return Vec
     with Pre  => Valid (F) and I <= F.N,
          Post => Norm2 (Steer'Result) <= Cap (F.P, W) ** 2;

   function Steer (F : Flock; I : Bird_Index; Desired : Vec; W : Weight_T)
     return Vec
   is
      D : constant Vec := Set_Length (Desired, F.P.Max_Speed);
      S : constant Vec := Limit ((X => Sat (D.X - F.B (I).V.X),
                                  Y => Sat (D.Y - F.B (I).V.Y)), F.P.Max_Force);
   begin
      return Limit ((X => Sat (S.X * W / 100), Y => Sat (S.Y * W / 100)),
                    Cap (F.P, W));
   end Steer;

   function Separation (F : Flock; I : Bird_Index;
                        List : Index_List; Count : Bird_Count) return Vec
   is
      R2  : constant Big := F.P.Sep_Radius ** 2;
      Sum : Vec := Zero;
      D2  : Big;
   begin
      for K in 1 .. Count loop
         D2 := Dist2 (F, I, List (K));
         if D2 < R2 then
            Sum := (X => Sat (Sum.X - DX (F, I, List (K)) * (R2 - D2) / R2),
                    Y => Sat (Sum.Y - DY (F, I, List (K)) * (R2 - D2) / R2));
         end if;
      end loop;
      if Norm2 (Sum) = 0 then
         return Zero;
      end if;
      return Steer (F, I, Sum, F.P.W_Sep);
   end Separation;

   function Alignment (F : Flock; I : Bird_Index;
                       List : Index_List; Count : Bird_Count) return Vec
   is
      Sum : Vec := Zero;
   begin
      if Count = 0 then
         return Zero;
      end if;
      for K in 1 .. Count loop
         Sum := (X => Sat (Sum.X + F.B (List (K)).V.X),
                 Y => Sat (Sum.Y + F.B (List (K)).V.Y));
      end loop;
      return Steer (F, I, Sum, F.P.W_Ali);
   end Alignment;

   function Cohesion (F : Flock; I : Bird_Index;
                      List : Index_List; Count : Bird_Count) return Vec
   is
      Sum : Vec := Zero;
   begin
      if Count = 0 then
         return Zero;
      end if;
      for K in 1 .. Count loop
         Sum := (X => Sat (Sum.X + DX (F, I, List (K))),
                 Y => Sat (Sum.Y + DY (F, I, List (K))));
      end loop;
      return Steer (F, I, Sum, F.P.W_Coh);
   end Cohesion;

   procedure Step (F : in out Flock) is
      List  : Index_List;
      Count : Bird_Count;
      A, B, C : Vec;
   begin
      for I in 1 .. F.N loop
         Find_Neighbours (F, I, List, Count);
         A := Separation (F, I, List, Count);
         B := Alignment (F, I, List, Count);
         C := Cohesion (F, I, List, Count);
         F.Next (I) := Clamp_Speed
           ((X => Sat (F.B (I).V.X + A.X + B.X + C.X),
             Y => Sat (F.B (I).V.Y + A.Y + B.Y + C.Y)),
            F.P.Min_Speed, F.P.Max_Speed);
         pragma Loop_Invariant (F.N = F.N'Loop_Entry and F.P = F.P'Loop_Entry
                                and F.B = F.B'Loop_Entry);
         pragma Loop_Invariant
           (for all K in 1 .. I =>
              Norm2 (F.Next (K)) in F.P.Min_Speed ** 2 .. F.P.Max_Speed ** 2);
      end loop;

      for I in 1 .. F.N loop
         F.B (I).V := F.Next (I);
         F.B (I).X := Wrap (F.B (I).X + F.B (I).V.X, F.P.Width);
         F.B (I).Y := Wrap (F.B (I).Y + F.B (I).V.Y, F.P.Height);
         pragma Loop_Invariant (F.N = F.N'Loop_Entry and F.P = F.P'Loop_Entry
                                and F.Next = F.Next'Loop_Entry);
         pragma Loop_Invariant
           (for all K in 1 .. F.N =>
              F.B (K).X < F.P.Width and F.B (K).Y < F.P.Height);
         pragma Loop_Invariant
           (for all K in 1 .. I =>
              Norm2 (F.B (K).V) in F.P.Min_Speed ** 2 .. F.P.Max_Speed ** 2);
      end loop;
   end Step;

end Boids.Flocks;
