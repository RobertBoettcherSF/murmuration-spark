--  steptime BIRDS [RADIUS_PX=50] [WIDTH=1280] [HEIGHT=720] [SEED=42]
--  The README "Speed" table: default parameters except radius and count,
--  100 warm-up steps, then the mean wall time of 200 steps.
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Calendar; use Ada.Calendar;
with Interfaces; use Interfaces;
with Boids.API; use Boids.API;

procedure Steptime is
   function Arg (I, D : Integer) return Integer is
     (if Argument_Count >= I then Integer'Value (Argument (I)) else D);
   T0 : Time;
begin
   Set_Param (1, Arg (3, 1280));
   Set_Param (2, Arg (4, 720));
   Set_Param (3, Arg (2, 50));
   Set_Param (11, Arg (1, 1200));
   Start (Unsigned_32 (Arg (5, 42)));
   for S in 1 .. 100 loop Tick; end loop;
   T0 := Clock;
   for S in 1 .. 200 loop Tick; end loop;
   Put_Line (Integer'Image (Boids.API.Count) & " birds:"
             & Integer'Image (Integer (Long_Float (Clock - T0) * 5000.0))
             & " /1000 ms/step (mean of 200 after 100 warm-up)");
end Steptime;
