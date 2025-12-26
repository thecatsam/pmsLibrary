 SharpPlot←NewSharpPlot
 :If 0=⎕NC'Causeway'
     ⎕USING←',system.dll' ',system.drawing.dll' ',sharpplot.dll'
 :AndIf 0=⎕NC'Causeway'
     (System.Drawing←System←Causeway←⎕NS ⍬).⎕CY'sharpplot.dws'
 :EndIf
 SharpPlot←⎕NEW Causeway.SharpPlot
