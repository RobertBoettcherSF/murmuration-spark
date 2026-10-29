--  metrics before|after WIDTH HEIGHT SEED [BIRDS=1200] [STEPS=2000]
--  Runs the Starling swirl preset natively and prints the numbers of the
--  README "Flock metrics" table: clusters (>= 5 birds, linked < 50 px with
--  wrap-around, same rule as the page), the three largest, alignment at the
--  end and mean over the last 200 steps, and mean ms/step over those steps.
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Calendar; use Ada.Calendar;
with Ada.Numerics.Long_Elementary_Functions;
use Ada.Numerics.Long_Elementary_Functions;
with Interfaces; use Interfaces;
with Boids.API; use Boids.API;
with Presets;

procedure Metrics is
   K     : constant Presets.Kind := Presets.Kind'Value (Argument (1));
   W     : constant Integer := Integer'Value (Argument (2));
   H     : constant Integer := Integer'Value (Argument (3));
   Seed  : constant Unsigned_32 := Unsigned_32'Value (Argument (4));
   Birds : constant Integer :=
     (if Argument_Count >= 5 then Integer'Value (Argument (5)) else 1200);
   Steps : constant Integer :=
     (if Argument_Count >= 6 then Integer'Value (Argument (6)) else 2000);
   Tail  : constant Integer := Integer'Min (200, Steps);

   function Alignment return Long_Float is
      SX, SY : Long_Float := 0.0;
   begin
      for I in 1 .. Boids.API.Count loop
         declare
            VX : constant Long_Float := Long_Float (Get_VX (I));
            VY : constant Long_Float := Long_Float (Get_VY (I));
            L  : Long_Float := Sqrt (VX * VX + VY * VY);
         begin
            if L = 0.0 then L := 1.0; end if;
            SX := SX + VX / L; SY := SY + VY / L;
         end;
      end loop;
      return Sqrt (SX * SX + SY * SY) / Long_Float (Boids.API.Count);
   end Alignment;

   procedure Clusters is
      N   : constant Integer := Boids.API.Count;
      Par : array (1 .. N) of Integer;
      Sz  : array (1 .. N) of Natural := (others => 0);
      X, Y : array (1 .. N) of Long_Float;
      FW  : constant Long_Float := Long_Float (W);
      FH  : constant Long_Float := Long_Float (H);
      function Find (I : Integer) return Integer is
         R : Integer := I;
      begin
         while Par (R) /= R loop R := Par (R); end loop;
         return R;
      end Find;
      C : Natural := 0;
      Top : array (1 .. 3) of Natural := (others => 0);
   begin
      for I in 1 .. N loop
         Par (I) := I;
         X (I) := Long_Float (Get_X (I)) / 256.0;
         Y (I) := Long_Float (Get_Y (I)) / 256.0;
      end loop;
      for I in 1 .. N loop
         for J in I + 1 .. N loop
            declare
               DX : Long_Float := abs (X (I) - X (J));
               DY : Long_Float := abs (Y (I) - Y (J));
            begin
               DX := Long_Float'Min (DX, FW - DX);
               DY := Long_Float'Min (DY, FH - DY);
               if DX * DX + DY * DY < 2500.0 then
                  declare
                     A : constant Integer := Find (I);
                     B : constant Integer := Find (J);
                  begin
                     if A /= B then Par (A) := B; end if;
                  end;
               end if;
            end;
         end loop;
      end loop;
      for I in 1 .. N loop Sz (Find (I)) := Sz (Find (I)) + 1; end loop;
      for I in 1 .. N loop
         if Sz (I) >= 5 then
            C := C + 1;
            for T in Top'Range loop
               if Sz (I) > Top (T) then
                  for U in reverse T + 1 .. 3 loop Top (U) := Top (U - 1); end loop;
                  Top (T) := Sz (I);
                  exit;
               end if;
            end loop;
         end if;
      end loop;
      Put_Line ("clusters:" & C'Image & "   largest:" & Top (1)'Image
                & Top (2)'Image & Top (3)'Image);
   end Clusters;

   Sum : Long_Float := 0.0;
   T0  : Time;
begin
   Presets.Apply (K, W, H, Birds);
   Start (Seed);
   for S in 1 .. Steps - Tail loop Tick; end loop;
   T0 := Clock;
   for S in 1 .. Tail loop
      Tick;
      Sum := Sum + Alignment;
   end loop;
   declare
      Ms : constant Long_Float :=
        Long_Float (Clock - T0) * 1000.0 / Long_Float (Tail);
   begin
      Put_Line (Presets.Kind'Image (K) & W'Image & " x" & H'Image
                & "  seed" & Seed'Image & ", " & Integer'Image (Boids.API.Count)
                & " birds," & Steps'Image & " steps");
      Clusters;
      Put_Line ("alignment mean of last" & Tail'Image & " steps:"
                & Integer'Image (Integer (Sum / Long_Float (Tail) * 100.0))
                & " %   at end:"
                & Integer'Image (Integer (Alignment * 100.0)) & " %");
      Put_Line ("ms/step over last" & Tail'Image & " steps (incl. metric):"
                & Integer'Image (Integer (Ms * 10.0)) & " /10");
   end;
end Metrics;
