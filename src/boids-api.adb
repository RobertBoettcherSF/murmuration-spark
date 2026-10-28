package body Boids.API with SPARK_Mode is

   function Clamp (V : Integer; Lo, Hi : Big) return Big is
     (if Big (V) < Lo then Lo elsif Big (V) > Hi then Hi else Big (V))
     with Pre => Lo <= Hi, Post => Clamp'Result in Lo .. Hi;

   procedure Next_Random (Lim : Big; R : out Big)
     with Global => (In_Out => Rng), Pre => Lim >= 1,
          Post => R in 0 .. Lim - 1;

   procedure Next_Random (Lim : Big; R : out Big) is
   begin
      Rng := Rng * 1_664_525 + 1_013_904_223;
      R := Big (Shift_Right (Rng, 8)) mod Lim;
   end Next_Random;

   procedure New_Bird (I : Bird_Index)
     with Global => (In_Out => (Rng, The_Flock)),
          Pre  => Valid (The_Flock),
          Post => Valid (The_Flock) and The_Flock.N = The_Flock.N'Old
                  and The_Flock.P = The_Flock.P'Old
                  and The_Flock.B (I).X < The_Flock.P.Width
                  and The_Flock.B (I).Y < The_Flock.P.Height
                  and The_Flock.B (I).V.X in Vel_Comp
                  and The_Flock.B (I).V.Y in Vel_Comp
                  and (for all K in Bird_Index =>
                         (if K /= I then The_Flock.B (K) = The_Flock.B'Old (K)));

   procedure New_Bird (I : Bird_Index) is
      S : constant Big := The_Flock.P.Max_Speed;
      X, Y, VX, VY : Big;
   begin
      Next_Random (The_Flock.P.Width, X);
      Next_Random (The_Flock.P.Height, Y);
      Next_Random (2 * S + 1, VX);
      Next_Random (2 * S + 1, VY);
      The_Flock.B (I).X := X;
      The_Flock.B (I).Y := Y;
      The_Flock.B (I).V := (X => VX - S, Y => VY - S);
   end New_Bird;

   procedure Set_Param (Index, Value : Integer) is
      P : Params := The_Flock.P;
      Old_N : constant Bird_Count := The_Flock.N;
   begin
      case Index is
         when 1 => P.Width  := Clamp (Value, 64, 4096) * Sub;
         when 2 => P.Height := Clamp (Value, 64, 4096) * Sub;
         when 3 => P.Radius := Clamp (Value, 1, 400) * Sub;
         when 4 => P.Sep_Radius := Clamp (Value, 1, 400) * Sub;
         when 5 => P.W_Sep := Clamp (Value, 0, 400);
         when 6 => P.W_Ali := Clamp (Value, 0, 400);
         when 7 => P.W_Coh := Clamp (Value, 0, 400);
         when 8 => P.Min_Speed := Clamp (Value, 1, Max_Speed_Lim);
         when 9 => P.Max_Speed := Clamp (Value, 1, Max_Speed_Lim);
         when 10 => P.Max_Force := Clamp (Value, 1, 4 * Sub);
         when others => null;
      end case;
      --  keep the parameters consistent
      if P.Min_Speed + 3 > P.Max_Speed then
         if Index = 8 then
            P.Min_Speed := Big'Min (P.Min_Speed, Max_Speed_Lim - 3);
            P.Max_Speed := P.Min_Speed + 3;
         else
            P.Max_Speed := Big'Max (P.Max_Speed, 4);
            P.Min_Speed := P.Max_Speed - 3;
         end if;
      end if;
      if P.Sep_Radius > P.Radius then
         if Index = 4 then
            P.Radius := P.Sep_Radius;
         else
            P.Sep_Radius := P.Radius;
         end if;
      end if;
      --  a smaller world: wrap every bird back inside
      for I in 1 .. The_Flock.N loop
         The_Flock.B (I).X := Wrap (The_Flock.B (I).X, P.Width);
         The_Flock.B (I).Y := Wrap (The_Flock.B (I).Y, P.Height);
         pragma Loop_Invariant (The_Flock.N = Old_N);
         pragma Loop_Invariant
           (for all K in Bird_Index =>
              The_Flock.B (K).V = The_Flock.B'Loop_Entry (K).V);
         pragma Loop_Invariant
           (for all K in 1 .. I =>
              The_Flock.B (K).X < P.Width and The_Flock.B (K).Y < P.Height);
      end loop;
      The_Flock.P := P;
      if Index = 11 then
         declare
            New_N : constant Bird_Count := Integer (Clamp (Value, 0, Max_Birds));
         begin
            --  fill the new slots first, then make them part of the flock
            for I in Old_N + 1 .. New_N loop
               New_Bird (I);
               pragma Loop_Invariant (Valid (The_Flock) and The_Flock.N = Old_N
                                      and The_Flock.P = P);
               pragma Loop_Invariant
                 (for all K in Old_N + 1 .. I =>
                    The_Flock.B (K).X < P.Width and The_Flock.B (K).Y < P.Height
                    and The_Flock.B (K).V.X in Vel_Comp
                    and The_Flock.B (K).V.Y in Vel_Comp);
            end loop;
            The_Flock.N := New_N;
         end;
      end if;
   end Set_Param;

   procedure Start (Seed : Unsigned_32) is
   begin
      Rng := Seed;
      for I in 1 .. The_Flock.N loop
         New_Bird (I);
         pragma Loop_Invariant (Valid (The_Flock));
      end loop;
   end Start;

   procedure Tick is
   begin
      Step (The_Flock);
   end Tick;

   function Count return Integer is (The_Flock.N);

   function Get_X (I : Integer) return Integer is
     (if I in 1 .. Max_Birds then Integer (The_Flock.B (I).X) else 0);
   function Get_Y (I : Integer) return Integer is
     (if I in 1 .. Max_Birds then Integer (The_Flock.B (I).Y) else 0);
   function Get_VX (I : Integer) return Integer is
     (if I in 1 .. Max_Birds then Integer (The_Flock.B (I).V.X) else 0);
   function Get_VY (I : Integer) return Integer is
     (if I in 1 .. Max_Birds then Integer (The_Flock.B (I).V.Y) else 0);

end Boids.API;
