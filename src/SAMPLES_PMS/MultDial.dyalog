 {sp}←MultDial;Causeway;InitCauseway;DISPLAY;System;WAIT;cur;⎕IO;⎕USING;⎕PATH
 ⎕IO←0
⍝ Dashboard as an array of dials

 ⍝ Display object ⍵, then wait ⍺ seconds. Returns 1 if ok. 0 if interrupted
 DISPLAY←{⍺←0.1 ⋄ 1000::0 ⋄ _←(3500⌶)⍵ ⋄ 1⊣⎕DL ⍺}

 ⍝ Expect InitCauseway in top-level dir. Else copy it in...
 :If 0=#.⎕NC'InitCauseway' ⋄ 'InitCauseway'#.⎕CY'Sharpplot' ⋄ :EndIf

 #.InitCauseway ⍬  ⍝ Initialise the Causeway and System namespace in this scope (notice we have localised them, along with ⎕USING)
 cur←0
 :While 1
     sp←⎕NEW Causeway.SharpPlot

     sp.SetXRange 0 100
     sp.SetXZones ⎕NEW Causeway.Zone(80 100 System.Drawing.Color.Red Causeway.FillStyle.Solid)
     sp.SetPenWidths 2.5
     sp.DialChartStyle←Causeway.DialChartStyles.ArrowLines

     sp.SetPageLabels⊂'Engine No.1' 'Engine No.2' 'Engine No.3' 'Engine No.4'
     sp.XCaption←'Coolant &deg;C'

     sp.SetLabelFont'Arial' 13 System.Drawing.FontStyle.Regular System.Drawing.Color.Black
     sp.SetCaptionFont'Arial' 15 System.Drawing.FontStyle.Bold System.Drawing.Color.Firebrick

     sp.DrawMultiple Causeway.ChartType.DialChart(,0⌈100⌊cur)

     :If ~0.5 DISPLAY sp.RenderSvg Causeway.SvgMode.Shadowed ⋄ :Leave ⋄ :EndIf

     cur+←4{×?⍺:⍵ ⋄ -⍵}?11

 :Until cur>110
