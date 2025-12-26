 {null}←ScatterPlot(x y)
 require'sharpPlot'
 sp lib←sharpPlot

 area←1326,782,312,1460,1056,752,1120,904,1654,735,565,346,698,775,696
 area,←741,432,517,747,914,603,1292,551,1383,1580,754,850,518,634
 price←60500,47500,46000,110000,148000,65000,79950,54000,120000,85000
 price,←65000,55000,70000,82500,78500,49950,46950,46950,77000,102000,37500,68000
 price,←65000,145000,98000,75000,96500,53950,75000

 sp.Heading←'Does Area Affect Price?'
 sp.YAxisStyle←lib.YAxisStyles.AtEndCaption
 sp.YCaption←'Price\n(£Thou)'
 sp.YFactor←1000
 sp.XCaption←'Floor Area(sq ft)'

 ⍝ sp.DrawScatterPlot x y←price area
 sp.DrawScatterPlot x y
 null←sp.Show
