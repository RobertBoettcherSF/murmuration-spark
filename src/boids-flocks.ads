--  The flock and the three Reynolds rules: separation, alignment, cohesion.
package Boids.Flocks with SPARK_Mode is

   subtype Bird_Count is Integer range 0 .. Max_Birds;
   subtype Bird_Index is Integer range 1 .. Max_Birds;

   Max_Radius : constant := 400 * Sub;          --  400 px
   subtype Radius_T is Big range Sub .. Max_Radius;
   subtype Weight_T is Big range 0 .. 400;      --  percent, 100 = default
   Max_Speed_Lim : constant := 16 * Sub;        --  16 px per step
   subtype Speed_T is Big range 1 .. Max_Speed_Lim;
   subtype Force_T is Big range 1 .. 4 * Sub;

   type Params is record
      Width, Height : World_Size := 1024 * Sub;
      Radius        : Radius_T   := 40 * Sub;   --  neighbour radius
      Sep_Radius    : Radius_T   := 16 * Sub;   --  personal space
      W_Sep, W_Ali, W_Coh : Weight_T := 100;
      Min_Speed     : Speed_T    := 2 * Sub;
      Max_Speed     : Speed_T    := 4 * Sub;
      Max_Force     : Force_T    := Sub / 8;
   end record;

   function Valid_Params (P : Params) return Boolean is
     (P.Min_Speed <= P.Max_Speed and P.Sep_Radius <= P.Radius);

   type Bird is record
      X, Y : Coord := 0;
      V    : Vec   := Zero;
   end record;

   type Bird_Array is array (Bird_Index) of Bird;
   type Vec_Array  is array (Bird_Index) of Vec;

   type Flock is record
      N    : Bird_Count := 0;
      P    : Params;
      B    : Bird_Array;
      Next : Vec_Array;     --  scratch: velocities of the next step
   end record;

   --  Every bird of the flock lies inside the world.
   function In_World (F : Flock) return Boolean is
     (for all I in 1 .. F.N => F.B (I).X < F.P.Width and F.B (I).Y < F.P.Height);

   function Valid (F : Flock) return Boolean is
     (Valid_Params (F.P) and In_World (F));

   function Speeds_Clamped (F : Flock) return Boolean is
     (for all I in 1 .. F.N =>
        Norm2 (F.B (I).V) in F.P.Min_Speed ** 2 .. F.P.Max_Speed ** 2);

   function DX (F : Flock; I, J : Bird_Index) return Delta_T is
     (Torus_Delta (F.B (I).X, F.B (J).X, F.P.Width))
     with Pre => Valid (F) and I <= F.N and J <= F.N;

   function DY (F : Flock; I, J : Bird_Index) return Delta_T is
     (Torus_Delta (F.B (I).Y, F.B (J).Y, F.P.Height))
     with Pre => Valid (F) and I <= F.N and J <= F.N;

   --  Squared torus distance between birds I and J.
   function Dist2 (F : Flock; I, J : Bird_Index) return Big is
     (DX (F, I, J) ** 2 + DY (F, I, J) ** 2)
     with Pre => Valid (F) and I <= F.N and J <= F.N;

   --  The definition of a neighbour: another bird closer than Radius.
   function Is_Neighbour (F : Flock; I, J : Bird_Index) return Boolean is
     (I /= J and then Dist2 (F, I, J) < F.P.Radius ** 2)
     with Pre => Valid (F) and I <= F.N and J <= F.N;

   type Index_List is array (Bird_Index) of Bird_Index;

   --  All-pairs neighbour search; the result is exactly the neighbour set,
   --  in increasing order (so without duplicates).
   procedure Find_Neighbours
     (F : Flock; I : Bird_Index; List : out Index_List; Count : out Bird_Count)
     with Pre  => Valid (F) and I <= F.N,
          Post => Count <= F.N
            and then (for all K in 1 .. Count =>
                        List (K) <= F.N and then Is_Neighbour (F, I, List (K)))
            and then (for all K in 1 .. Count - 1 => List (K) < List (K + 1))
            and then (for all J in 1 .. F.N =>
                        (if Is_Neighbour (F, I, J) then
                           (for some K in 1 .. Count => List (K) = J)));


   --  Force cap of a rule with weight W (percent): Max_Force * W / 100.
   function Cap (P : Params; W : Weight_T) return Limit_T is
     (P.Max_Force * W / 100);

   function Separation (F : Flock; I : Bird_Index;
                        List : Index_List; Count : Bird_Count) return Vec
     with Pre  => Valid (F) and I <= F.N and Count <= F.N
                  and (for all K in 1 .. Count => List (K) <= F.N),
          Post => Norm2 (Separation'Result) <= Cap (F.P, F.P.W_Sep) ** 2;

   function Alignment (F : Flock; I : Bird_Index;
                       List : Index_List; Count : Bird_Count) return Vec
     with Pre  => Valid (F) and I <= F.N and Count <= F.N
                  and (for all K in 1 .. Count => List (K) <= F.N),
          Post => Norm2 (Alignment'Result) <= Cap (F.P, F.P.W_Ali) ** 2;

   function Cohesion (F : Flock; I : Bird_Index;
                      List : Index_List; Count : Bird_Count) return Vec
     with Pre  => Valid (F) and I <= F.N and Count <= F.N
                  and (for all K in 1 .. Count => List (K) <= F.N),
          Post => Norm2 (Cohesion'Result) <= Cap (F.P, F.P.W_Coh) ** 2;

   --  One simulation step for the whole flock.
   procedure Step (F : in out Flock)
     with Pre  => Valid (F),
          Post => Valid (F) and Speeds_Clamped (F)
                  and F.N = F.N'Old and F.P = F.P'Old;

end Boids.Flocks;
