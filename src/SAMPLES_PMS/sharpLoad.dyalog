 {lib}←sharpLoad;lib;new
⍝  To use cross-platform SharpPlot from any workspace, all you need to do is:
⍝      lib ← sharpLoad
⍝      ⎕NEW lib.Causeway.SharpPlot etc.
⍝  For library, tries: #, ⎕THIS, then namespaces in ⎕PATH
 new←1
 :For lib :In ∪⎕THIS ## #
     :If 0≠lib.⎕NC'InitCauseway' ⋄ :AndIf 0≠lib.⎕NC'View'
         new←0 ⋄ :Leave
     :EndIf
 :EndFor
 :If new
     'sharpLoad: initializing ',(lib←#)
     (↑'InitCauseway' 'View')lib.⎕CY'sharpplot'
 :EndIf

⍝ Then a minimal cross-platform SharpPlot script looks like: InitCauseway ⍬
 lib.InitCauseway ⍬

 sp←⎕NEW lib.Causeway.SharpPlot
 sp.SetPenWidths 2.5×?5⍴0
 sp.Heading←'Plot of This vs. That.'
 sp.SetKeyText'Kitkats' 'Mars Bars' 'M&Ms' 'Milkyway' 'Etc'
 sp.DrawLineGraph⊂↓+\¯0.5+?5 100⍴0
 lib.View sp
