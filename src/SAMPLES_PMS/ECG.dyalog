 {∆}←sp ECG ∆;LIB;_;count

 LIB←sp.LIB
 sp.Heading←'Daily Volatility of 3 Stock Prices'

 count←125+?150
 bp←LIB.VectorMath.Difference count{400+¯75+(÷⍵)*⍨?⍺⍴⌊150*⍵}2.1
 kelda←LIB.VectorMath.Difference count{400+¯75+(÷⍵)*⍨?⍺⍴⌊150*⍵}1.5
 hbos←LIB.VectorMath.Difference count{400+45×1○(÷⍵)*⍨?⍺⍴⌊150*⍵}2

 sp.YAxisStyle←LIB.YAxisStyles.GridLines
 sp.IAxisStyle←LIB.IAxisStyles.PlainAxis

 sp.SetYLabels'Kelda' 'BP' 'HBOS'
 sp.IAllowance←1.5
 sp.IIntercept←0

 _←sp.DrawTraceChart kelda bp hbos
