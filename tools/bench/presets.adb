with Boids.API; use Boids.API;
package body Presets is
   procedure Apply (K : Kind; Width, Height, Birds : Integer) is
   begin
      Set_Param (11, 0);
      Set_Param (1, Width);
      Set_Param (2, Height);
      Set_Param (9, 1024);                                --  vmax 4
      Set_Param (8, (if K = Before then 512 else 640));   --  vmin 2 / 2.5
      Set_Param (3, (if K = Before then 50 else 110));    --  radius
      Set_Param (4, (if K = Before then 16 else 40));     --  personal space
      Set_Param (5, (if K = Before then 150 else 300));   --  separation %
      Set_Param (6, (if K = Before then 100 else 250));   --  alignment %
      Set_Param (7, (if K = Before then 100 else 250));   --  cohesion %
      Set_Param (10, (case K is             --  max force, px * 256
                         when Before => 31,     --  0.12
                         when After  => 60,     --  0.234: what the README table used
                         when Page   => 59));   --  round (0.23 * 256), what the page sends
      Set_Param (11, Birds);
   end Apply;
end Presets;
