package body Boids with SPARK_Mode is

   procedure Lemma_Comp_Bound (V : Vec; L : Bound_T) is
   begin
      if abs V.X > L then
         pragma Assert (V.X * V.X >= (L + 1) * (L + 1));
      end if;
      if abs V.Y > L then
         pragma Assert (V.Y * V.Y >= (L + 1) * (L + 1));
      end if;
   end Lemma_Comp_Bound;

   function Isqrt (N : Big) return Big is
      Lo  : Big := 0;
      Hi  : Big := 2 ** 17 + 1;   --  Hi * Hi > 2 ** 34 >= N
      Mid : Big;
   begin
      while Hi - Lo > 1 loop
         pragma Loop_Invariant (0 <= Lo and Lo < Hi and Hi <= 2 ** 17 + 1);
         pragma Loop_Invariant (Lo * Lo <= N and N < Hi * Hi);
         pragma Loop_Variant (Decreases => Hi - Lo);
         Mid := Lo + (Hi - Lo) / 2;
         if Mid * Mid <= N then
            Lo := Mid;
         else
            Hi := Mid;
         end if;
      end loop;
      pragma Assert (Hi = Lo + 1);
      return Lo;
   end Isqrt;

   --  Bring a non-zero vector to 2**30 <= |W|^2 <= 2**33 by exact
   --  doubling, or by halving very long vectors (direction kept up to
   --  rounding). The rescaling below is exact enough only in this window.
   Small : constant := 2 ** 15;
   Big_C : constant := 2 ** 16;
   subtype Norm_Comp is Big range -Big_C .. Big_C;

   procedure Normalise (V : Vec; WX, WY : out Norm_Comp)
     with Pre  => Norm2 (V) > 0,
          Post => WX * WX + WY * WY in 2 ** 30 .. 2 ** 33;

   procedure Normalise (V : Vec; WX, WY : out Norm_Comp) is
      X : Comp := V.X;
      Y : Comp := V.Y;
   begin
      while abs X > Big_C or abs Y > Big_C loop
         pragma Loop_Invariant (abs X > Big_C or abs Y > Big_C);
         pragma Loop_Variant (Decreases => abs X + abs Y);
         X := X / 2;
         Y := Y / 2;
      end loop;
      pragma Assert (X * X + Y * Y > 0);
      while X * X + Y * Y < 2 ** 30 loop
         pragma Loop_Invariant (abs X <= Big_C and abs Y <= Big_C);
         pragma Loop_Invariant (X * X + Y * Y in 1 .. 2 ** 30 - 1);
         pragma Loop_Variant (Increases => X * X + Y * Y);
         pragma Assert (abs X < Small and abs Y < Small);
         X := 2 * X;
         Y := 2 * Y;
      end loop;
      WX := X;
      WY := Y;
   end Normalise;

   ---------------------------------------------------------------
   --  Small arithmetic lemmas (ghost). Each states one non-linear
   --  fact on its own, so the provers see nothing else.
   ---------------------------------------------------------------

   procedure Lemma_Sq_Mono (X, Y : Nat30)
     with Ghost, Pre => X <= Y, Post => X * X <= Y * Y;
   procedure Lemma_Sq_Mono (X, Y : Nat30) is
   begin
      pragma Assert (X * X <= X * Y);
      pragma Assert (X * Y <= Y * Y);
   end Lemma_Sq_Mono;

   procedure Lemma_Sq_Strict (X, Y : Nat30)
     with Ghost, Pre => X < Y, Post => X * X < Y * Y;
   procedure Lemma_Sq_Strict (X, Y : Nat30) is
   begin
      pragma Assert (X * X <= X * Y);
      pragma Assert (X * Y < Y * Y);
   end Lemma_Sq_Strict;

   procedure Lemma_Sq_Rev (X, Y : Nat30) is
   begin
      if X >= Y then
         Lemma_Sq_Mono (X => Y, Y => X);
      end if;
   end Lemma_Sq_Rev;

   procedure Lemma_Frac (D : Delta_T; P, Q : Big) is
   begin
      pragma Assert (abs (D * P) <= abs D * Q);
      pragma Assert (abs (D * P / Q) = abs (D * P) / Q);
      pragma Assert (abs (D * P) / Q <= (abs D * Q) / Q);
   end Lemma_Frac;

   procedure Lemma_Avg (S, C, H : Big) is
   begin
      pragma Assert (abs (S / C) = abs S / C);
      pragma Assert (abs S / C <= (C * H) / C);
   end Lemma_Avg;

   subtype Nat31 is Big range 0 .. 2 ** 31;

   procedure Lemma_Mul_Le (A, B, C : Nat31)
     with Ghost, Pre => A <= B, Post => A * C <= B * C;
   procedure Lemma_Mul_Le (A, B, C : Nat31) is null;

   --  A*C < B*C with C > 0 implies A < B
   subtype Nat35 is Big range 0 .. 2 ** 35;
   subtype Nat26 is Big range 0 .. 2 ** 26;

   procedure Lemma_Mul_Le_B (A, B : Nat35; C : Nat26)
     with Ghost, Pre => A <= B, Post => A * C <= B * C;
   procedure Lemma_Mul_Le_B (A, B : Nat35; C : Nat26) is null;

   procedure Lemma_Mul_Lt_B (A, B : Nat35; C : Nat26)
     with Ghost, Pre => A < B and C > 0, Post => A * C < B * C;
   procedure Lemma_Mul_Lt_B (A, B : Nat35; C : Nat26) is null;

   subtype Nat28 is Big range 0 .. 2 ** 28;
   subtype Nat33 is Big range 0 .. 2 ** 33;

   procedure Lemma_Cancel (A, B : Nat28; C : Nat33)
     with Ghost, Pre => C > 0 and then A * C < B * C, Post => A < B;
   procedure Lemma_Cancel (A, B : Nat28; C : Nat33) is
   begin
      if A >= B then
         pragma Assert (B * C <= A * C);
      end if;
   end Lemma_Cancel;

   subtype Nat14 is Big range 0 .. 2 ** 14;
   procedure Lemma_Sum_Sq (A, B : Nat14)
     with Ghost, Post => (A + B) * (A + B) <= 2 * (A * A + B * B);
   procedure Lemma_Sum_Sq (A, B : Nat14) is
   begin
      pragma Assert ((A - B) * (A - B) >= 0);
      pragma Assert ((A - B) * (A - B) = A * A - 2 * (A * B) + B * B);
      pragma Assert ((A + B) * (A + B) = A * A + 2 * (A * B) + B * B);
   end Lemma_Sum_Sq;

   --  One component: R = W * T / S (truncated toward zero).
   procedure Lemma_Div (W, T, S, R : Big)
     with Ghost,
          Pre  => W in -Big_C .. Big_C and then T in 0 .. Max_Len
                  and then S in Small .. 2 ** 17 and then R = W * T / S,
          Post => abs R * S <= abs W * T and then abs W * T < (abs R + 1) * S
                  and then abs R <= 2 ** 14;
   procedure Lemma_Div (W, T, S, R : Big) is null;

   function Rescale (V : Vec; T : Len_T) return Vec is
      WX, WY : Norm_Comp;
      N, S, RX, RY : Big;
   begin
      Normalise (V, WX, WY);
      N := WX * WX + WY * WY;
      S := Isqrt (N);
      pragma Assert (S >= Small);
      pragma Assert (S * S <= 2 ** 33);
      pragma Assert (S < 2 ** 17);
      RX := WX * T / S;
      RY := WY * T / S;
      if T = 0 then
         pragma Assert (RX = 0 and RY = 0);
         return (X => RX, Y => RY);
      end if;
      Lemma_Div (WX, T, S, RX);
      Lemma_Div (WY, T, S, RY);
      declare
         A  : constant Big := abs RX;
         B  : constant Big := abs RY;
         PX : constant Big := abs WX * T;   --  <= 2**29
         PY : constant Big := abs WY * T;
         Q  : constant Big := A * A + B * B;
         T2 : constant Big := T * T;
         S2 : constant Big := S * S;
      begin
         --  upper bound: Q*S2 <= N*T2 < (S+1)^2*T2 <= (T2+T+1)*S2
         Lemma_Sq_Mono (A * S, PX);
         Lemma_Sq_Mono (B * S, PY);
         pragma Assert (A * A * S2 <= WX * WX * T2);
         pragma Assert (B * B * S2 <= WY * WY * T2);
         pragma Assert (Q * S2 <= N * T2);
         Lemma_Mul_Lt_B (N, (S + 1) * (S + 1), T2);
         pragma Assert (N * T2 < (S + 1) * (S + 1) * T2);
         Lemma_Mul_Le (2 * T + 1, S, T * S);
         pragma Assert (T * S2 >= 2 * S * T2 + T * S);
         pragma Assert (T * S >= T2);
         pragma Assert ((S + 1) * (S + 1) * T2 <= (T2 + T + 1) * S2);
         pragma Assert (Q * S2 < (T2 + T + 1) * S2);
         Lemma_Cancel (Q, T2 + T + 1, S2);
         pragma Assert (Q <= T2 + T);
         Lemma_Comp_Bound ((X => RX, Y => RY), T + 1);
         --  lower bound
         if T >= 2 then
            Lemma_Sq_Strict (PX, (A + 1) * S);
            Lemma_Sq_Strict (PY, (B + 1) * S);
            pragma Assert ((A + 1) * (A + 1) * S2 > WX * WX * T2);
            pragma Assert ((B + 1) * (B + 1) * S2 > WY * WY * T2);
            pragma Assert (((A + 1) * (A + 1) + (B + 1) * (B + 1)) * S2 > N * T2);
            Lemma_Mul_Le_B (S2, N, T2);
            pragma Assert (S2 * T2 <= N * T2);
            pragma Assert (T2 * S2 = S2 * T2);
            pragma Assert (T2 * S2 < ((A + 1) * (A + 1) + (B + 1) * (B + 1)) * S2);
            Lemma_Cancel (T2, (A + 1) * (A + 1) + (B + 1) * (B + 1), S2);
            Lemma_Sum_Sq (A, B);
            pragma Assert ((A + B) * (A + B) <= 2 * Q);
            if Q < (T - 2) * (T - 2) then
               pragma Assert (2 * (A + B) * (2 * (A + B))
                              < 3 * (T - 2) * (3 * (T - 2)));
               Lemma_Sq_Rev (2 * (A + B), 3 * (T - 2));
               pragma Assert (Q + 2 * (A + B) + 2 < T2);
               pragma Assert (False);
            end if;
            pragma Assert (Q >= (T - 2) ** 2);
         end if;
      end;
      return (X => RX, Y => RY);
   end Rescale;

   function Limit (V : Vec; M : Len_T) return Vec is
      R : Vec;
   begin
      if Norm2 (V) <= M * M then
         R := V;
      elsif M = 0 then
         R := Zero;   --  the only vector of length 0
      else
         R := Rescale (V, M - 1);
         pragma Assert (Norm2 (R) <= (M - 1) * (M - 1) + (M - 1));
      end if;
      Lemma_Comp_Bound (R, M);
      return R;
   end Limit;

   function Clamp_Speed (V : Vec; Lo, Hi : Len_T) return Vec is
      R : Vec;
   begin
      if Norm2 (V) in Lo * Lo .. Hi * Hi then
         R := V;
      elsif Norm2 (V) = 0 then
         R := (X => Lo, Y => 0);
      elsif Norm2 (V) > Hi * Hi then
         R := Rescale (V, Hi - 1);
         Lemma_Sq_Mono (Lo, Hi - 3);
      else
         R := Rescale (V, Lo + 2);
         Lemma_Sq_Mono (Lo + 3, Hi);
         pragma Assert ((Lo + 2) * (Lo + 2) + (Lo + 2) <= (Lo + 3) * (Lo + 3));
      end if;
      Lemma_Comp_Bound (R, Hi);
      return R;
   end Clamp_Speed;

   function Torus_Delta (A, B : Coord; Size : World_Size) return Delta_T is
      D : constant Big := B - A;
   begin
      if D > Size / 2 then
         return D - Size;
      elsif D < -(Size / 2) then
         return D + Size;
      else
         return D;
      end if;
   end Torus_Delta;

   function Wrap (P : Big; Size : World_Size) return Coord is
     (P mod Size);

end Boids;
