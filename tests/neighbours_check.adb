--  Brute-force cross-check of Find_Neighbours: on random flocks, compare its
--  list with an independent, naive computation (Long_Float distances with
--  explicit wrap-around) for every bird. The uniform-grid search must give
--  exactly the same set as the all-pairs search.
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Discrete_Random;
with Boids; use Boids;
with Boids.Flocks; use Boids.Flocks;

procedure Neighbours_Check is
   subtype R is Integer range 0 .. Integer'Last;
   package Rnd is new Ada.Numerics.Discrete_Random (R);
   G : Rnd.Generator;
   F : Flock;
   List : Index_List;
   Count : List_Count;
   GList : Index_List;
   GCount : List_Count;
   Gr : Grid;
   Marks : Mark_Array := (others => False);
   Grid_Mismatch : Natural := 0;
   Mismatch, Pairs : Natural := 0;

   function Ring (A, B, Size : Long_Float) return Long_Float is
      D : constant Long_Float := abs (A - B);
   begin
      return Long_Float'Min (D, Size - D);
   end Ring;
begin
   Rnd.Reset (G, 7);
   for Trial in 1 .. 200 loop
      F.P.Width  := Big (64 + Rnd.Random (G) mod 1500) * Sub;
      F.P.Height := Big (64 + Rnd.Random (G) mod 1000) * Sub;
      F.P.Radius := Big (1 + Rnd.Random (G) mod (if Trial mod 4 = 0 then 400 else 120)) * Sub
                    + Big (Rnd.Random (G) mod Sub);
      F.P.Sep_Radius := Sub;
      F.N := 1 + Rnd.Random (G) mod (if Trial <= 3 then Max_Birds else 400);
      for I in 1 .. F.N loop
         F.B (I).X := Big (Rnd.Random (G)) mod F.P.Width;
         F.B (I).Y := Big (Rnd.Random (G)) mod F.P.Height;
      end loop;
      Build_Grid (F, Gr);
      for I in 1 .. F.N loop
         Find_Neighbours (F, I, List, Count);
         Find_Neighbours_Grid (F, Gr, I, Marks, GList, GCount);
         declare
            type Counts is array (1 .. Max_Birds) of Natural;
            In_A, In_G : Counts := (others => 0);
         begin
            for K in 1 .. Count loop
               In_A (List (K)) := In_A (List (K)) + 1;
            end loop;
            for K in 1 .. GCount loop
               In_G (GList (K)) := In_G (GList (K)) + 1;
            end loop;
            if In_A /= In_G or Count /= GCount then
               Grid_Mismatch := Grid_Mismatch + 1;
            end if;
         end;
         declare
            In_List : array (1 .. Max_Birds) of Boolean := (others => False);
         begin
            for K in 1 .. Count loop
               In_List (List (K)) := True;
            end loop;
            for J in 1 .. F.N loop
               declare
                  DX : constant Long_Float := Ring (Long_Float (F.B (I).X),
                    Long_Float (F.B (J).X), Long_Float (F.P.Width));
                  DY : constant Long_Float := Ring (Long_Float (F.B (I).Y),
                    Long_Float (F.B (J).Y), Long_Float (F.P.Height));
                  Expect : constant Boolean :=
                    I /= J and DX * DX + DY * DY < Long_Float (F.P.Radius) ** 2;
               begin
                  Pairs := Pairs + 1;
                  if Expect /= In_List (J) then
                     Mismatch := Mismatch + 1;
                  end if;
               end;
            end loop;
         end;
      end loop;
   end loop;
   if Mismatch = 0 and Grid_Mismatch = 0 then
      Put_Line ("NEIGHBOURS PASS: 200 random flocks," & Pairs'Image
                & " pairs; all-pairs = naive brute force, grid = all-pairs");
   else
      Put_Line ("NEIGHBOURS FAIL:" & Mismatch'Image & " naive," & Grid_Mismatch'Image & " grid mismatches");
      raise Program_Error;
   end if;
end Neighbours_Check;
