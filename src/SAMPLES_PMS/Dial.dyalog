 {ok}←spLib Dial data
 ;bk;sp;z1;z2;z3;⎕IO
 ⎕IO←0
 sp←0⊃spLib                        ⍝ Passed from Plot via: Dial Plot data
 ⍝ EXTERNAL: System, Causeway      ⍝ Passed by Plot (equiv. to 1⊃spLib)

 ⍝ *** Validate and Normalize <data>
 :If 1≠≢data
     ⎕SIGNAL/'Dial requires a single number between 0 and 100' 11
 :EndIf
 data←0⌈100⌊0.1×⌊0.5+data×10

 bk←System.Color.Snow
⍝ *** Set object specifications
 sp.SetMargins 5 ⋄ sp.SetNewline'⋄'

 sp.Heading←'Execution⋄Progress'{0=≢⍵:⍺ ⋄ ⍵}sp.Heading
 sp.SetPenWidths(2)
 sp.SetAxisStyle System.(Color.Black LineStyle.Solid 2)
 sp.SetXLabelFont System.('Arial' 12 FontStyle.Bold)
 {sp.SetBackground System.(⍵ FillStyle.Solid)}bk
 {sp.SetChartBackground System.(⍵ FillStyle.Solid)}bk
 sp.SetXRange(0,100)
 sp.SetXTickMarks 10 1
  ⋄ z1←⎕NEW System.Zone(0 10 System.Color.Red)
  ⋄ z2←{⎕NEW System.Zone(10 90 ⍵)}bk
  ⋄ z3←⎕NEW System.Zone(90 100 System.Color.LightBlue)
 sp.SetXZones z1 z2 z3
 sp.DialChartStyle←System.DialChartStyles.ArrowLines

 sp.XCaption←(⍕data),'%' ⋄ sp.SetXCaptionFont System.('times' 14 FontStyle.Italic Color.Maroon)

⍝ *** Draw and display the Dial
 sp.DrawDialChart data
 ok←1
