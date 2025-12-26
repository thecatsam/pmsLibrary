 (sp)←sp Trace data;Lib

 Lib←sp.Lib

 sp.Heading←'Inventory in Processing Vessels'

  ⋄ ⎕SHADOW'raw part done'
 raw←+\0 0 0 0 1 1 1 1 0 0 0 0 ¯1 ¯1 ¯1 0 0 0 0 1 1 1 1 1 0 0 0 0
 part←+\4 0 0 0 ¯1 ¯1 ¯1 0 0 0 0 0 1 1 1 0 0 0 0 1 1 1 0 0 ¯1 ¯1 ¯1 0
 done←+\2 0 0 0 1 1 1 0 0 0 0 0 ¯1 0 ¯1 ¯1 ¯1 0 0 0 0 0 0 0 1 1 1 0

 sp.IIntercept←0
 sp.TraceChartStyle←Lib.TraceChartStyles.SurfaceShading

 sp.SetYLabels'Raw' 'Part⋄Done' 'Finished'
 sp.SetXTickMarks(1)

 sp.XAxisStyle←Lib.XAxisStyles.(ArrowedAxis+CenteredCaption)
 sp.XCaption←'Days forward from today'

 sp.YCaption←'Vessel'
 sp.YAxisStyle←Lib.YAxisStyles.AtEndCaption

 sp.SetFillStyles(Lib.FillStyle.GradientBottom)

 sp.DrawTraceChart raw part done
