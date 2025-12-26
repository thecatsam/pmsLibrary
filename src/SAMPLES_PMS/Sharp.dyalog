 sh←(fn Sharp)data;me
 me←⊃⎕RSI
 :If 0=me.⎕NC'_SHARP'
     'loading'
     sh←⍎'_SHARP'⎕NS''
     sh.⎕CY'SharpPlot'
 :Else
     sh←me⍎'_SHARP'
 :EndIf

 sh.View sh fn{⍺ ⍺⍺ ⍵}data
