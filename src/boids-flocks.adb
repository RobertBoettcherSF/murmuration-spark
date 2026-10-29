--  Loop invariants carry the proofs here: each one states what has been
--  established for the birds/cells handled so far.
package body Boids.Flocks with SPARK_Mode is

   ------------------------------------------------------------------
   --  All-pairs search (reference)
   ------------------------------------------------------------------

   procedure Find_Neighbours
     (F : Flock; I : Bird_Index; List : out Index_List; Count : out List_Count)
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

   ------------------------------------------------------------------
   --  Grid
   ------------------------------------------------------------------

   --  Cell size along one axis: at least Radius, and large enough that
   --  there are at most Max_G cells; G = number of cells.
   procedure Axis (Size : World_Size; R : Radius_T;
                   Cs : out Cell_Size; G : out G_Dim)
     with Post => Cs >= R and (G = 1 or else Big (G) * Cs <= Size);

   procedure Axis (Size : World_Size; R : Radius_T;
                   Cs : out Cell_Size; G : out G_Dim)
   is
      Q : Big;
   begin
      Cs := Big'Max (R, Size / Max_G + 1);
      pragma Assert (Cs * Max_G > Size);
      Q := Size / Cs;
      pragma Assert (Q < Max_G);
      pragma Assert (Q * Cs <= Size);
      G := Integer (Big'Max (1, Q));
   end Axis;

   procedure Build_Grid (F : Flock; G : out Grid) is
      C : Cell_Id;
   begin
      G := (others => <>);
      Axis (F.P.Width, F.P.Radius, G.Csx, G.Gx);
      Axis (F.P.Height, F.P.Radius, G.Csy, G.Gy);
      G.Head := (others => 0);
      for J in 1 .. F.N loop
         C := Key (F, G, J);
         pragma Assert (for all J2 in 1 .. F.N =>
                          Key (F, G, J2) = Key (F, G'Loop_Entry, J2));
         G.Next (J) := G.Head (C);
         G.Head (C) := J;
         pragma Assert (for all J2 in 1 .. F.N =>
                          Key (F, G, J2) = Key (F, G'Loop_Entry, J2));
         pragma Assert (for all J2 in 1 .. J - 1 => Key (F, G, J2) /= C
                          or else J2 <= G.Next (J));
         pragma Loop_Invariant (Geometry_OK (F, G));
         pragma Loop_Invariant
           (G.Gx = G'Loop_Entry.Gx and G.Gy = G'Loop_Entry.Gy
            and G.Csx = G'Loop_Entry.Csx and G.Csy = G'Loop_Entry.Csy);
         pragma Loop_Invariant (for all K in J + 1 .. Max_Birds => G.Next (K) = 0);
         pragma Loop_Invariant (Chains_OK (F, G, J));
      end loop;
   end Build_Grid;

   --  Ghost lemmas for the grid. Together they prove the key fact:
   --  a neighbour (distance < Radius <= cell size) is at most one cell
   --  away on each axis, also across the wrap-around seam, where the
   --  last cell may be wider (it absorbs the remainder of Size / Cs).

   --  Close coordinates on a ring lie in the same or an adjacent cell.
   procedure Lemma_Div_Close (X1, X2 : Coord; C : Cell_Size)
     with Ghost, Pre => X2 < X1 + C, Post => X2 / C <= X1 / C + 1;

   procedure Lemma_Div_Close (X1, X2 : Coord; C : Cell_Size) is
   begin
      pragma Assert (C * (X2 / C) <= X2);
      pragma Assert (X1 < C * (X1 / C) + C);
      pragma Assert (C * (X2 / C) < C * (X1 / C + 2));
      if X2 / C >= X1 / C + 2 then
         pragma Assert (C * (X2 / C) >= C * (X1 / C + 2));
      end if;
   end Lemma_Div_Close;

   function Near (A, B, G : Integer) return Boolean is
     (B = (A + G - 1) mod G or B = A or B = (A + 1) mod G)
     with Pre => G in G_Dim and then A in 0 .. G - 1;

   procedure Lemma_Axis_Near
     (X1, X2 : Coord; Size : World_Size; Cs : Cell_Size; G : G_Dim;
      R : Radius_T)
     with Ghost,
          Pre  => X1 < Size and then X2 < Size and then Cs >= R
                  and then (G = 1 or else Big (G) * Cs <= Size)
                  and then abs Torus_Delta (X1, X2, Size) < R,
          Post => Near (Integer (Big'Min (X1 / Cs, Big (G - 1))),
                        Integer (Big'Min (X2 / Cs, Big (G - 1))), G);

   procedure Lemma_Axis_Near
     (X1, X2 : Coord; Size : World_Size; Cs : Cell_Size; G : G_Dim;
      R : Radius_T)
   is
      D : constant Big := Torus_Delta (X1, X2, Size);
   begin
      pragma Assert (abs D < R and R <= Cs);   --  so |D| < Cs
      if G = 1 then
         return;
      end if;
      if D = X2 - X1 then
         Lemma_Div_Close (X1, X2, Cs);
         Lemma_Div_Close (X2, X1, Cs);
      elsif D = X2 - X1 - Size then
         --  X1 near 0, X2 near Size
         pragma Assert (X1 < Cs);
         pragma Assert (X1 / Cs = 0);
         pragma Assert (X2 >= Size - Cs);
         pragma Assert (Size - Cs >= Big (G - 1) * Cs);
         pragma Assert (X2 / Cs >= Big (G - 1));
      else
         pragma Assert (D = X2 - X1 + Size);
         pragma Assert (X2 < Cs);
         pragma Assert (X2 / Cs = 0);
         pragma Assert (X1 >= Size - Cs);
         pragma Assert (Size - Cs >= Big (G - 1) * Cs);
         pragma Assert (X1 / Cs >= Big (G - 1));
      end if;
   end Lemma_Axis_Near;

   procedure Lemma_Neighbour_Close (F : Flock; I, J : Bird_Index)
     with Ghost,
          Pre  => Valid (F) and then I <= F.N and then J <= F.N
                  and then Is_Neighbour (F, I, J),
          Post => abs DX (F, I, J) < F.P.Radius
                  and abs DY (F, I, J) < F.P.Radius;

   procedure Lemma_Neighbour_Close (F : Flock; I, J : Bird_Index) is
      A : constant Big := abs DX (F, I, J);
      B : constant Big := abs DY (F, I, J);
   begin
      pragma Assert (A * A <= Dist2 (F, I, J));
      pragma Assert (B * B <= Dist2 (F, I, J));
      Lemma_Sq_Rev (A, F.P.Radius);
      Lemma_Sq_Rev (B, F.P.Radius);
   end Lemma_Neighbour_Close;

   --  Marks and List describe the same set; every entry is a neighbour;
   --  no duplicates; nothing marked beyond F.N.
   function Inv (F : Flock; I : Bird_Index; Marks : Mark_Array;
                 List : Index_List; Count : List_Count) return Boolean is
     ((for all K in 1 .. Count =>
         List (K) <= F.N and then Is_Neighbour (F, I, List (K))
         and then Marks (List (K)))
      and then (for all K1 in 1 .. Count =>
                  (for all K2 in K1 + 1 .. Count => List (K1) /= List (K2)))
      and then (for all J in Bird_Index =>
                  (if Marks (J) then J <= F.N
                     and then (for some K in 1 .. Count => List (K) = J))))
     with Ghost, Pre => Valid (F) and I <= F.N;

   --  Marks (one Boolean per bird) filter duplicates when fewer than 3
   --  cells per axis make some of the 9 cells coincide.
   --  Walk the chain of cell C and add its unmarked neighbours of I.
   procedure Scan_Cell
     (F : Flock; G : Grid; I : Bird_Index; C : Cell_Id;
      Marks : in out Mark_Array; List : in out Index_List;
      Count : in out List_Count)
     with Pre  => Valid (F) and then I <= F.N and then Grid_OK (F, G)
                  and then Count <= List_Max - F.N
                  and then Inv (F, I, Marks, List, Count),
          Post => Inv (F, I, Marks, List, Count)
                  and then Count <= Count'Old + F.N
                  and then (for all J in 1 .. F.N =>
                              Marks (J) = (Marks'Old (J)
                                or (Key (F, G, J) = C
                                    and then Is_Neighbour (F, I, J))));

   procedure Scan_Cell
     (F : Flock; G : Grid; I : Bird_Index; C : Cell_Id;
      Marks : in out Mark_Array; List : in out Index_List;
      Count : in out List_Count)
   is
      Cur : Bird_Count := G.Head (C);
   begin
      while Cur /= 0 loop
         pragma Loop_Invariant (Cur <= F.N and Key (F, G, Cur) = C);
         pragma Loop_Invariant (Count <= Count'Loop_Entry + (G.Head (C) - Cur));
         pragma Loop_Invariant (Inv (F, I, Marks, List, Count));
         pragma Loop_Invariant
           (for all J in 1 .. F.N =>
              Marks (J) = (Marks'Loop_Entry (J)
                or (J > Cur and then Key (F, G, J) = C
                    and then Is_Neighbour (F, I, J))));
         pragma Loop_Variant (Decreases => Cur);
         if not Marks (Cur) and then Is_Neighbour (F, I, Cur) then
            Count := Count + 1;
            List (Count) := Cur;
            Marks (Cur) := True;
         end if;
         Cur := G.Next (Cur);
      end loop;
   end Scan_Cell;

   --  Ghost (erased from the executable): every neighbour of I sits in
   --  a cell adjacent (or equal) to I's cell on both axes.
   procedure Lemma_All_Near (F : Flock; G : Grid; I : Bird_Index)
     with Ghost,
          Pre  => Valid (F) and then I <= F.N and then Geometry_OK (F, G),
          Post => (for all J in 1 .. F.N =>
                     (if Is_Neighbour (F, I, J) then
                        Near (Cell_X (G, F.B (I).X), Cell_X (G, F.B (J).X), G.Gx)
                        and Near (Cell_Y (G, F.B (I).Y), Cell_Y (G, F.B (J).Y),
                                  G.Gy)));

   procedure Lemma_All_Near (F : Flock; G : Grid; I : Bird_Index) is
   begin
      for J in 1 .. F.N loop
         if Is_Neighbour (F, I, J) then
            Lemma_Neighbour_Close (F, I, J);
            Lemma_Axis_Near (F.B (I).X, F.B (J).X, F.P.Width, G.Csx, G.Gx,
                             F.P.Radius);
            Lemma_Axis_Near (F.B (I).Y, F.B (J).Y, F.P.Height, G.Csy, G.Gy,
                             F.P.Radius);
         end if;
         pragma Loop_Invariant
           (for all L in 1 .. J =>
              (if Is_Neighbour (F, I, L) then
                 Near (Cell_X (G, F.B (I).X), Cell_X (G, F.B (L).X), G.Gx)
                 and Near (Cell_Y (G, F.B (I).Y), Cell_Y (G, F.B (L).Y), G.Gy)));
      end loop;
   end Lemma_All_Near;

   type Cell_List is array (1 .. 9) of Cell_Id;

   procedure Find_Neighbours_Grid
     (F : Flock; G : Grid; I : Bird_Index; Marks : in out Mark_Array;
      List : in out Index_List; Count : out List_Count)
   is
      CX : constant Natural := Cell_X (G, F.B (I).X);
      CY : constant Natural := Cell_Y (G, F.B (I).Y);
      Xs : constant array (1 .. 3) of Natural :=
        ((CX + G.Gx - 1) mod G.Gx, CX, (CX + 1) mod G.Gx);
      Ys : constant array (1 .. 3) of Natural :=
        ((CY + G.Gy - 1) mod G.Gy, CY, (CY + 1) mod G.Gy);
      Cells : Cell_List := (others => 0);
   begin
      for A in 1 .. 3 loop
         for B in 1 .. 3 loop
            Cells ((A - 1) * 3 + B) := Ys (A) * G.Gx + Xs (B);
         end loop;
      end loop;
      pragma Assert
        (for all A in 1 .. 3 => (for all B in 1 .. 3 =>
           Cells ((A - 1) * 3 + B) = Ys (A) * G.Gx + Xs (B)));

      Count := 0;
      for M in 1 .. 9 loop
         Scan_Cell (F, G, I, Cells (M), Marks, List, Count);
         pragma Loop_Invariant (Count <= M * F.N);
         pragma Loop_Invariant (Inv (F, I, Marks, List, Count));
         pragma Loop_Invariant
           (for all J in 1 .. F.N =>
              Marks (J) = (Is_Neighbour (F, I, J)
                and then (for some L in 1 .. M => Key (F, G, J) = Cells (L))));
      end loop;

      --  every neighbour lies in one of the nine cells
      Lemma_All_Near (F, G, I);
      pragma Assert (for all J in 1 .. F.N =>
                       (if Is_Neighbour (F, I, J) then
                          (for some A in 1 .. 3 =>
                             Cell_Y (G, F.B (J).Y) = Ys (A))
                          and (for some B in 1 .. 3 =>
                             Cell_X (G, F.B (J).X) = Xs (B))));
      pragma Assert (for all J in 1 .. F.N =>
                       (if Is_Neighbour (F, I, J) then
                          (for some L in 1 .. 9 => Key (F, G, J) = Cells (L))));
      pragma Assert (for all J in 1 .. F.N =>
                       (if Is_Neighbour (F, I, J) then Marks (J)));
      pragma Assert (for all J in 1 .. F.N =>
                       (if Is_Neighbour (F, I, J) then
                          (for some K in 1 .. Count => List (K) = J)));

      --  clear the marks again
      for K in 1 .. Count loop
         Marks (List (K)) := False;
         pragma Loop_Invariant
           (for all J in Bird_Index =>
              (if Marks (J) then (for some L in K + 1 .. Count => List (L) = J)));
      end loop;
   end Find_Neighbours_Grid;

   ------------------------------------------------------------------
   --  The three rules
   ------------------------------------------------------------------

   --  Sums below are plain integers: the loop invariants bound them by
   --  count * (largest term), which the declared limits keep far from
   --  overflow; v0.1 needed saturating adds (Sat) here instead.

   --  Reynolds steering: desired direction at Max_Speed minus the current
   --  velocity, limited to Max_Force, then weighted.
   function Steer (F : Flock; I : Bird_Index; Desired : Vec; W : Weight_T)
     return Vec
     with Pre  => Valid (F) and then I <= F.N and then Norm2 (Desired) > 0,
          Post => Norm2 (Steer'Result) <= Cap (F.P, W) ** 2
                  and abs Steer'Result.X <= Cap (F.P, W)
                  and abs Steer'Result.Y <= Cap (F.P, W);

   function Steer (F : Flock; I : Bird_Index; Desired : Vec; W : Weight_T)
     return Vec
   is
      D : constant Vec := Rescale (Desired, F.P.Max_Speed);
      S : Vec;
   begin
      Lemma_Comp_Bound (D, F.P.Max_Speed + 1);
      S := Limit ((X => D.X - F.B (I).V.X, Y => D.Y - F.B (I).V.Y),
                  F.P.Max_Force);
      return Limit ((X => S.X * W / 100, Y => S.Y * W / 100), Cap (F.P, W));
   end Steer;

   function Separation (F : Flock; I : Bird_Index;
                        List : Index_List; Count : List_Count) return Vec
   is
      R2 : constant Big := F.P.Sep_Radius ** 2;
      SX, SY : Big := 0;
      D2, TX, TY : Big;
      J : Bird_Index;
      Avg : Vec;
   begin
      if Count = 0 then
         return Zero;
      end if;
      for K in 1 .. Count loop
         J := List (K);
         D2 := Dist2 (F, I, J);
         if D2 < R2 then
            Lemma_Frac (DX (F, I, J), R2 - D2, R2);
            Lemma_Frac (DY (F, I, J), R2 - D2, R2);
            TX := DX (F, I, J) * (R2 - D2) / R2;
            TY := DY (F, I, J) * (R2 - D2) / R2;
            SX := SX - TX;
            SY := SY - TY;
         end if;
         pragma Loop_Invariant (abs SX <= Big (K) * Half_World
                                and abs SY <= Big (K) * Half_World);
      end loop;
      Lemma_Avg (SX, Big (Count), Half_World);
      Lemma_Avg (SY, Big (Count), Half_World);
      Avg := (X => SX / Big (Count), Y => SY / Big (Count));
      if Norm2 (Avg) = 0 then
         return Zero;   --  pushes cancel out: no direction to steer to
      end if;
      return Steer (F, I, Avg, F.P.W_Sep);
   end Separation;

   function Alignment (F : Flock; I : Bird_Index;
                       List : Index_List; Count : List_Count) return Vec
   is
      SX, SY : Big := 0;
      Avg : Vec;
   begin
      if Count = 0 then
         return Zero;
      end if;
      for K in 1 .. Count loop
         SX := SX + F.B (List (K)).V.X;
         SY := SY + F.B (List (K)).V.Y;
         pragma Loop_Invariant (abs SX <= Big (K) * Max_Speed_Lim
                                and abs SY <= Big (K) * Max_Speed_Lim);
      end loop;
      Lemma_Avg (SX, Big (Count), Max_Speed_Lim);
      Lemma_Avg (SY, Big (Count), Max_Speed_Lim);
      Avg := (X => SX / Big (Count), Y => SY / Big (Count));
      if Norm2 (Avg) = 0 then
         return Zero;   --  headings cancel out: nothing to align to
      end if;
      return Steer (F, I, Avg, F.P.W_Ali);
   end Alignment;

   function Cohesion (F : Flock; I : Bird_Index;
                      List : Index_List; Count : List_Count) return Vec
   is
      SX, SY : Big := 0;
      Avg : Vec;
   begin
      if Count = 0 then
         return Zero;
      end if;
      for K in 1 .. Count loop
         SX := SX + DX (F, I, List (K));
         SY := SY + DY (F, I, List (K));
         pragma Loop_Invariant (abs SX <= Big (K) * Half_World
                                and abs SY <= Big (K) * Half_World);
      end loop;
      Lemma_Avg (SX, Big (Count), Half_World);
      Lemma_Avg (SY, Big (Count), Half_World);
      Avg := (X => SX / Big (Count), Y => SY / Big (Count));
      if Norm2 (Avg) = 0 then
         return Zero;   --  already at the centre of the neighbours
      end if;
      return Steer (F, I, Avg, F.P.W_Coh);
   end Cohesion;

   ------------------------------------------------------------------
   --  Step
   ------------------------------------------------------------------

   procedure Step (F : in out Flock) is
      G     : Grid;
      Marks : Mark_Array := (others => False);
      List  : Index_List := (others => 1);
      Count : List_Count;
      A, B, C : Vec;
   begin
      Build_Grid (F, G);
      declare
         Cur : constant Flock := F;   --  this step reads only the old state
      begin
      for I in 1 .. F.N loop
         Find_Neighbours_Grid (Cur, G, I, Marks, List, Count);
         A := Separation (Cur, I, List, Count);
         B := Alignment (Cur, I, List, Count);
         C := Cohesion (Cur, I, List, Count);
         F.Next (I) := Clamp_Speed
           ((X => F.B (I).V.X + A.X + B.X + C.X,
             Y => F.B (I).V.Y + A.Y + B.Y + C.Y),
            F.P.Min_Speed, F.P.Max_Speed);
         pragma Loop_Invariant (F.N = F.N'Loop_Entry and F.P = F.P'Loop_Entry
                                and F.B = F.B'Loop_Entry);
         pragma Loop_Invariant (No_Marks (Marks));
         pragma Loop_Invariant
           (for all K in 1 .. I =>
              Norm2 (F.Next (K)) in F.P.Min_Speed ** 2 .. F.P.Max_Speed ** 2
              and abs F.Next (K).X <= F.P.Max_Speed
              and abs F.Next (K).Y <= F.P.Max_Speed);
      end loop;
      end;

      for I in 1 .. F.N loop
         F.B (I).V := F.Next (I);
         F.B (I).X := Wrap (F.B (I).X + F.B (I).V.X, F.P.Width);
         F.B (I).Y := Wrap (F.B (I).Y + F.B (I).V.Y, F.P.Height);
         pragma Loop_Invariant (F.N = F.N'Loop_Entry and F.P = F.P'Loop_Entry
                                and F.Next = F.Next'Loop_Entry);
         pragma Loop_Invariant
           (for all K in 1 .. F.N =>
              F.B (K).X < F.P.Width and F.B (K).Y < F.P.Height
              and F.B (K).V.X in Vel_Comp and F.B (K).V.Y in Vel_Comp);
         pragma Loop_Invariant
           (for all K in 1 .. I =>
              Norm2 (F.B (K).V) in F.P.Min_Speed ** 2 .. F.P.Max_Speed ** 2);
      end loop;
   end Step;

end Boids.Flocks;
