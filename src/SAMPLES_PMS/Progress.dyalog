 {sp}←{label}Progress pct;DISPLAY;WAIT;pct;⎕IO;⎕USING;⎕PATH
⍝ Show progress in percent between 0 and 100
 ⎕IO←0

 :If 1<≢pct
     :If 0=⎕NC'label' ⋄ sp←Progress¨pct
     :Else ⋄ sp←(⊂label)Progress¨pct
     :EndIf
     :Return
 :EndIf

 :If 0=⎕NC'label' ⋄ label←'Progress: ','%',⍨{⍵<0:'-',⍕|⍵ ⋄ ⍕⍵}pct ⋄ :EndIf

 ⍝ Display object ⍵
 DISPLAY←{⍺←0.1 ⋄ _←label(3500⌶)⍵ ⋄ 1:_←⎕DL ⍺}

 ⍝ Expect InitCauseway in top-level dir. Else copy it in...
 :If 0=#.⎕NC'InitCauseway' ⋄ 'InitCauseway'#.⎕CY'Sharpplot' ⋄ :EndIf

 #.InitCauseway ⍬  ⍝ Initialise the Causeway and System namespace in this scope (notice we have localised them, along with ⎕USING)

 sp←⎕NEW #.Causeway.SharpPlot


 sp.SetXRange 0 100
 sp.SetXZones ⎕NEW Causeway.Zone(80 100 System.Drawing.Color.Red Causeway.FillStyle.Solid)
 sp.SetPenWidths 1.5
 sp.DialChartStyle←Causeway.DialChartStyles.ArrowLines

 sp.SetPageLabels⊂label'Engine No.2' 'Engine No.3' 'Engine No.4'
 sp.XCaption←{
     ⍵≤0:'STARTING UP'
     ⍵≥100:'COMPLETE'
     (⍕pct),'%'
 }pct

 sp.SetLabelFont'Arial' 13 System.Drawing.FontStyle.Regular System.Drawing.Color.Black
 sp.SetCaptionFont'Arial' 15 System.Drawing.FontStyle.Bold System.Drawing.Color.Firebrick

 sp.DrawMultiple Causeway.ChartType.DialChart(,0⌈100⌊pct)

 0.01 DISPLAY sp.RenderSvg Causeway.SvgMode.Shadowed
