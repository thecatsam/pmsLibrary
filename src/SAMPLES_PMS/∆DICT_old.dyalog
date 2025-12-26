 ∆DICT←{
     ⍺←''   ⍝ Default is character null-string. 
            ⍝ Use ⍺:⎕NULL etc to distinguish from typical values...
     set←{⍺←dict
         d(n v)←⍺ ⍵
         p←d.keys⍳⊂n
         p<≢d.keys:(p⊃d.values)←v
         d.keys,←⊂n
         1:_←v⊣d.values,←⊂v
     }
     get←{⍺←dict
         d n←⍺ ⍵
         p←d.keys⍳⊂n
         p<≢d.keys:p⊃values
         d.default
     }
     dict←⎕NS''
     dict.dict←dict
     dict.(keys values ⎕IO ⎕ML default)←⍬ ⍬ 0 1 ⍺
     dict.set←set
     dict.get←get
     dict
 }
