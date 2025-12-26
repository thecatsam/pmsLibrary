 (sp)←sp Venn data;LC;LIB;⎕IO
 ⎕IO←0

 LIB←sp.LIB ⋄ LC←LIB.Color
 data←(23 9 18)
 sp.SetMargins 7×(6,6,0,0)

 sp.SetHeadingFont('Times' 10 LIB.FontStyle.Bold LC.Blue)
 sp.Heading←'[Data=',(⍕data),']'

 sp.VennDiagramStyle←LIB.VennDiagramStyles.(Filled+RedrawOutline+ValueTags)
 sp.SetValueFont('Times' 11 LIB.FontStyle.Bold LC.White)
 sp.ValueTagFormat←'XL⋄#0'
 sp.ValueLineSpacing←100
 sp.SetColors LC.Green LC.Maroon
 sp.SetEdgeStyle(LC.Navy)
 sp.SetXLabels('Female' 'Maths' 'Female⋄and⋄Maths')

 sp.DrawVennDiagram(data[0 2 1])
