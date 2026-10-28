--  The functions the browser calls (WebAssembly exports). All in SPARK:
--  inputs are clamped to their legal ranges before they reach the flock.
with Interfaces; use Interfaces;
with Boids.Flocks; use Boids.Flocks;

package Boids.API with SPARK_Mode is

   The_Flock : Flock;
   Rng       : Unsigned_32 := 1;

   --  Index: 1 Width px, 2 Height px, 3 Radius px, 4 Sep radius px,
   --  5 W_Sep %, 6 W_Ali %, 7 W_Coh %, 8 Min speed (1/256 px),
   --  9 Max speed (1/256 px), 10 Max force (1/256 px), 11 Bird count.
   procedure Set_Param (Index, Value : Integer)
     with Export, Convention => C, External_Name => "mf_set_param",
          Pre  => Valid (The_Flock),
          Post => Valid (The_Flock);

   procedure Start (Seed : Unsigned_32)
     with Export, Convention => C, External_Name => "mf_start",
          Pre  => Valid (The_Flock),
          Post => Valid (The_Flock);

   procedure Tick
     with Export, Convention => C, External_Name => "mf_tick",
          Pre  => Valid (The_Flock),
          Post => Valid (The_Flock) and Speeds_Clamped (The_Flock);

   function Count return Integer
     with Export, Convention => C, External_Name => "mf_count";

   --  Position / velocity of bird I (1-based) in 1/256 px.
   function Get_X (I : Integer) return Integer
     with Export, Convention => C, External_Name => "mf_x";
   function Get_Y (I : Integer) return Integer
     with Export, Convention => C, External_Name => "mf_y";
   function Get_VX (I : Integer) return Integer
     with Export, Convention => C, External_Name => "mf_vx";
   function Get_VY (I : Integer) return Integer
     with Export, Convention => C, External_Name => "mf_vy";

end Boids.API;
