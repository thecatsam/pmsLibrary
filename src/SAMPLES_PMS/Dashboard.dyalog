 {sp}←sp Dashboard data4;LIB;⎕IO

 ⎕IO←1
 LIB←sp.LIB
 sp.SetXRange 0 100
 sp.SetXZones ⎕NEW LIB.Zone(80 100 LIB.Color.Red LIB.FillStyle.Solid)
 sp.SetPenWidths 1.5
 sp.DialChartStyle←LIB.DialChartStyles.ArrowLines

 sp.SetPageLabels(⊂'Phase '),¨⍕¨⍳≢data4
 sp.XCaption←'Completion %'
 sp.SetXTickMarks 10 1

 sp.SetLabelFont'Arial' 13
 sp.SetCaptionFont'Arial' 15 LIB.FontStyle.Bold LIB.Color.Firebrick

 sp.DrawMultiple LIB.ChartType.DialChart(data4)
