--  The flock and the three Reynolds rules: separation, alignment, cohesion,
--  plus two neighbour searches: all-pairs (the reference) and a uniform
--  grid (used by Step), both proven to return exactly the neighbour set.
package Boids.Flocks with SPARK_Mode is

   ------------------------------------------------------------------
   --  Parameters (all in units, 1 px = Sub = 256 units)
   ------------------------------------------------------------------

   subtype Bird_Count is Integer range 0 .. Max_Birds;
   subtype Bird_Index is Integer range 1 .. Max_Birds;

   Max_Radius : constant := 400 * Sub;          --  400 px
   subtype Radius_T is Big range Sub .. Max_Radius;
   subtype Weight_T is Big range 0 .. 400;      --  percent, 100 = default
   Max_Speed_Lim : constant := 16 * Sub;        --  16 px per step
   subtype Speed_T is Big range 1 .. Max_Speed_Lim;
   subtype Force_T is Big range 1 .. 4 * Sub;
   subtype Vel_Comp is Big range -Max_Speed_Lim .. Max_Speed_Lim;

   type Params is record
      Width, Height : World_Size := 1024 * Sub;
      Radius        : Radius_T   := 40 * Sub;   --  neighbour radius
      Sep_Radius    : Radius_T   := 16 * Sub;   --  personal space
      W_Sep, W_Ali, W_Coh : Weight_T := 100;
      Min_Speed     : Speed_T    := 2 * Sub;
      Max_Speed     : Speed_T    := 4 * Sub;
      Max_Force     : Force_T    := Sub / 8;
   end record;

   --  Max_Speed >= Min_Speed + 3 units (3/256 px) leaves room for the
   --  integer rounding of Clamp_Speed.
   function Valid_Params (P : Params) return Boolean is
     (P.Min_Speed + 3 <= P.Max_Speed and P.Sep_Radius <= P.Radius);

   ------------------------------------------------------------------
   --  The flock and its invariant. Valid (F) is the precondition and
   --  postcondition of almost everything: parameters consistent, birds
   --  inside the world, velocities bounded.
   ------------------------------------------------------------------

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

   function Vel_Bounded (F : Flock) return Boolean is
     (for all I in 1 .. F.N =>
        F.B (I).V.X in Vel_Comp and F.B (I).V.Y in Vel_Comp);

   function Valid (F : Flock) return Boolean is
     (Valid_Params (F.P) and In_World (F) and Vel_Bounded (F));

   function Speeds_Clamped (F : Flock) return Boolean is
     (for all I in 1 .. F.N =>
        Norm2 (F.B (I).V) in F.P.Min_Speed ** 2 .. F.P.Max_Speed ** 2);

   ------------------------------------------------------------------
   --  Geometry and the neighbour relation (the specification that both
   --  searches are proven against).
   ------------------------------------------------------------------

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

   ------------------------------------------------------------------
   --  Neighbour lists. Exact_Set is the Gold property: the list holds
   --  every neighbour of I, only neighbours, and none twice.
   ------------------------------------------------------------------

   --  A grid search may visit up to 9 cells; with fewer than 3 cells per
   --  axis some are visited twice (duplicates are filtered by marks).
   List_Max : constant := 9 * Max_Birds;
   subtype List_Count is Integer range 0 .. List_Max;
   type Index_List is array (1 .. List_Max) of Bird_Index;

   function Exact_Set (F : Flock; I : Bird_Index; List : Index_List;
                       Count : List_Count) return Boolean is
     ((for all K in 1 .. Count =>
         List (K) <= F.N and then Is_Neighbour (F, I, List (K)))
      and then (for all K1 in 1 .. Count =>
                  (for all K2 in K1 + 1 .. Count => List (K1) /= List (K2)))
      and then (for all J in 1 .. F.N =>
                  (if Is_Neighbour (F, I, J) then
                     (for some K in 1 .. Count => List (K) = J))))
     with Ghost, Pre => Valid (F) and I <= F.N;

   --  All-pairs neighbour search (reference); the result is exactly the
   --  neighbour set, in increasing order.
   procedure Find_Neighbours
     (F : Flock; I : Bird_Index; List : out Index_List; Count : out List_Count)
     with Pre  => Valid (F) and I <= F.N,
          Post => Count <= F.N
            and then (for all K in 1 .. Count =>
                        List (K) <= F.N and then Is_Neighbour (F, I, List (K)))
            and then (for all K in 1 .. Count - 1 => List (K) < List (K + 1))
            and then (for all J in 1 .. F.N =>
                        (if Is_Neighbour (F, I, J) then
                           (for some K in 1 .. Count => List (K) = J)));

   ------------------------------------------------------------------
   --  Uniform grid. Why: all-pairs costs N^2 distance tests per step
   --  (2000 birds: 4 million). With cells at least Radius wide, every
   --  neighbour lies in the bird's own cell or one of the 8 around it,
   --  so only those 9 cells are scanned (6x faster at 1200-2000 birds).
   --  Cells at least Radius wide, at most 64 x 64 cells.
   --  Each cell holds a chain of its birds in decreasing index order:
   --  Head (C) is the highest bird in cell C, Next (J) the next lower
   --  bird in the same cell as J (0 = end).
   ------------------------------------------------------------------
   Max_G : constant := 64;
   subtype G_Dim is Integer range 1 .. Max_G;
   subtype Cell_Id is Integer range 0 .. Max_G * Max_G - 1;
   subtype Cell_Size is Big range 1 .. Max_World;
   type Head_Array is array (Cell_Id) of Bird_Count;
   type Next_Array is array (Bird_Index) of Bird_Count;
   type Mark_Array is array (Bird_Index) of Boolean;

   type Grid is record
      Gx, Gy   : G_Dim     := 1;
      Csx, Csy : Cell_Size := 1;
      Head     : Head_Array := (others => 0);
      Next     : Next_Array := (others => 0);
   end record;

   function Geometry_OK (F : Flock; G : Grid) return Boolean is
     (G.Csx >= F.P.Radius and G.Csy >= F.P.Radius
      and (G.Gx = 1 or else Big (G.Gx) * G.Csx <= F.P.Width)
      and (G.Gy = 1 or else Big (G.Gy) * G.Csy <= F.P.Height));

   function Cell_X (G : Grid; X : Coord) return Natural is
     (Integer (Big'Min (X / G.Csx, Big (G.Gx - 1))));
   function Cell_Y (G : Grid; Y : Coord) return Natural is
     (Integer (Big'Min (Y / G.Csy, Big (G.Gy - 1))));

   function Key (F : Flock; G : Grid; J : Bird_Index) return Cell_Id is
     (Cell_Y (G, F.B (J).Y) * G.Gx + Cell_X (G, F.B (J).X));

   --  Chains_OK: the chains built from birds 1 .. Upto are complete and
   --  correct: walking Head/Next of cell C visits exactly the birds whose
   --  Key is C (no bird skipped between two links).
   function Chains_OK (F : Flock; G : Grid; Upto : Bird_Count) return Boolean is
     ((for all C in Cell_Id =>
         G.Head (C) <= Upto
         and then (if G.Head (C) /= 0 then Key (F, G, G.Head (C)) = C)
         and then (for all J in G.Head (C) + 1 .. Upto => Key (F, G, J) /= C))
      and then
      (for all J in 1 .. Upto =>
         G.Next (J) < J
         and then (if G.Next (J) /= 0 then
                     Key (F, G, G.Next (J)) = Key (F, G, J))
         and then (for all J2 in G.Next (J) + 1 .. J - 1 =>
                     Key (F, G, J2) /= Key (F, G, J))))
     with Ghost, Pre => Upto <= F.N;

   function Grid_OK (F : Flock; G : Grid) return Boolean is
     (Geometry_OK (F, G) and then Chains_OK (F, G, F.N))
     with Ghost;

   procedure Build_Grid (F : Flock; G : out Grid)
     with Pre  => Valid (F),
          Post => Grid_OK (F, G);

   function No_Marks (M : Mark_Array) return Boolean is
     (for all J in Bird_Index => not M (J));

   --  Grid neighbour search: the same set as Find_Neighbours (as a set:
   --  no duplicates, every entry a neighbour, every neighbour present).
   --  Marks is scratch space, all False before and after.
   procedure Find_Neighbours_Grid
     (F : Flock; G : Grid; I : Bird_Index; Marks : in out Mark_Array;
      List : in out Index_List; Count : out List_Count)
     with Pre  => Valid (F) and then I <= F.N and then Grid_OK (F, G)
                  and then No_Marks (Marks),
          Post => Exact_Set (F, I, List, Count) and then No_Marks (Marks);

   ------------------------------------------------------------------
   --  The three Reynolds rules. Each averages over the neighbour list,
   --  turns the average into a desired velocity of length Max_Speed,
   --  and returns the steering force (desired - current), capped.
   --    Separation: away from neighbours inside Sep_Radius, weighted
   --                by closeness.
   --    Alignment:  towards the neighbours' mean velocity.
   --    Cohesion:   towards the neighbours' centre.
   --  A zero average (no neighbours, or pushes cancelling) gives Zero.
   ------------------------------------------------------------------

   --  Force cap of a rule with weight W (percent): Max_Force * W / 100.
   function Cap (P : Params; W : Weight_T) return Len_T is
     (P.Max_Force * W / 100);

   function List_OK (F : Flock; List : Index_List; Count : List_Count)
     return Boolean is
     (for all K in 1 .. Count => List (K) <= F.N);

   function Separation (F : Flock; I : Bird_Index;
                        List : Index_List; Count : List_Count) return Vec
     with Pre  => Valid (F) and I <= F.N and List_OK (F, List, Count),
          Post => Norm2 (Separation'Result) <= Cap (F.P, F.P.W_Sep) ** 2
                  and abs Separation'Result.X <= Cap (F.P, F.P.W_Sep)
                  and abs Separation'Result.Y <= Cap (F.P, F.P.W_Sep);

   function Alignment (F : Flock; I : Bird_Index;
                       List : Index_List; Count : List_Count) return Vec
     with Pre  => Valid (F) and I <= F.N and List_OK (F, List, Count),
          Post => Norm2 (Alignment'Result) <= Cap (F.P, F.P.W_Ali) ** 2
                  and abs Alignment'Result.X <= Cap (F.P, F.P.W_Ali)
                  and abs Alignment'Result.Y <= Cap (F.P, F.P.W_Ali);

   function Cohesion (F : Flock; I : Bird_Index;
                      List : Index_List; Count : List_Count) return Vec
     with Pre  => Valid (F) and I <= F.N and List_OK (F, List, Count),
          Post => Norm2 (Cohesion'Result) <= Cap (F.P, F.P.W_Coh) ** 2
                  and abs Cohesion'Result.X <= Cap (F.P, F.P.W_Coh)
                  and abs Cohesion'Result.Y <= Cap (F.P, F.P.W_Coh);

   --  One simulation step for the whole flock (uses the grid search).
   --  All new velocities are computed from the old state first, then
   --  every bird moves and wraps (so bird order does not matter).
   procedure Step (F : in out Flock)
     with Pre  => Valid (F),
          Post => Valid (F) and Speeds_Clamped (F)
                  and F.N = F.N'Old and F.P = F.P'Old;

end Boids.Flocks;
