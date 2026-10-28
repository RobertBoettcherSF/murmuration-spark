--  Smoke test: fixed seed, a few hundred steps, nothing crashes and every
--  bird stays in the world with its speed clamped (checked explicitly
--  below; built with run-time checks on, contracts are proven statically).
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Long_Elementary_Functions;
use Ada.Numerics.Long_Elementary_Functions;
with Boids; use Boids;
with Boids.Flocks; use Boids.Flocks;
with Boids.API; use Boids.API;

procedure Smoke is
   Steps : constant := 500;
   Bad   : Natural := 0;
begin
   Set_Param (1, 1280);
   Set_Param (2, 720);
   Set_Param (11, 600);
   Start (42);
   for S in 1 .. Steps loop
      Tick;
      for I in 1 .. The_Flock.N loop
         declare
            B  : Bird renames The_Flock.B (I);
            N2 : constant Big := Norm2 (B.V);
         begin
            if B.X >= The_Flock.P.Width or B.Y >= The_Flock.P.Height
              or N2 < The_Flock.P.Min_Speed ** 2
              or N2 > The_Flock.P.Max_Speed ** 2
            then
               Bad := Bad + 1;
            end if;
         end;
      end loop;
   end loop;
   --  order parameter: |average heading|, 1 = all birds aligned
   declare
      SX, SY : Long_Float := 0.0;
   begin
      for I in 1 .. The_Flock.N loop
         declare
            V : constant Vec := The_Flock.B (I).V;
            L : constant Long_Float :=
              Long_Float (V.X) ** 2 + Long_Float (V.Y) ** 2;
         begin
            SX := SX + Long_Float (V.X) / Sqrt (L);
            SY := SY + Long_Float (V.Y) / Sqrt (L);
         end;
      end loop;
      Put_Line ("alignment after" & Steps'Image & " steps:"
                & Long_Float'Image (Sqrt (SX ** 2 + SY ** 2)
                                    / Long_Float (The_Flock.N)));
   end;
   if Bad = 0 then
      Put_Line ("SMOKE PASS: 600 birds," & Steps'Image & " steps, all in bounds");
   else
      Put_Line ("SMOKE FAIL:" & Bad'Image & " violations");
      raise Program_Error;
   end if;
end Smoke;
