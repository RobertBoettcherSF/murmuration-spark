--  Starling swirl before (v0.2) and after (v0.2.1), set in the same order
--  and with the same scaling (px * 256, rounded) as web/template.html.
--  After differs from Page only in Max_Force (60 vs 59); see tools/README.md.
package Presets is
   type Kind is (Before, After, Page);
   procedure Apply (K : Kind; Width, Height, Birds : Integer);
end Presets;
