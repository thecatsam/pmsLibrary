 Gant;Causeway;lib;System;html;mark;plotTitle;sharpName;sp;top;vdata;⎕IO

 ⎕IO←1
⍝ For titles, you can use HTML entities like &lt; or &mdash;
⍝ For some reason, the entity &Newline; does NOT work (fixed here!)
⍝ \n        → newline
⍝ \\n       → '\n'
⍝ &Newline; → newline
  ⋄ html←{'(?<!\\)\\n' '\\n' '&Newline;'⎕R'\n' 'n' '\n'⊣⍵}
 plotTitle←html'plotTitle'{0=⎕NC ⍺:⍵ ⋄ ⎕OR ⍺}'Work Schedule'

⍝ *** Load SharpLib library
 sharpName top←'__SharpLib'#
 System←Causeway←lib←{
     ⍵:top⍎sharpName
     'SharpPlot.dws'{
         ⍵⊣⍵.⎕CY ⍺⊣⍵.System.Drawing←⍵.System←⍵.Causeway←⍵
     }⍎sharpName top.⎕NS''
 }0≠top.⎕NC sharpName

 sp←⎕NEW lib.SharpPlot
 sp.SetNewline'⋄'

 sp.Heading←plotTitle
 todo←'' 'Clear ground' 'Dig drains' 'Lay foundations' 'Concrete floors'
 sp.SetYLabels(todo)

 startwk←24 28 34 50
 endwk←30 36 48 54
 ydata←1 2 3 4

 sp.MarginLeft←72
 sp.YAxisStyle←lib.YAxisStyles.(ForceZero+GridLines)
 sp.SetXTickMarks(5)

 sp.DrawGanttChart ydata startwk endwk

 {}3500⌶sp.RenderSvg lib.SvgMode.FixedAspect ⍝ Stretchable or Shadowed
 ⍝lib.View sp
