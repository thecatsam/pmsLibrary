 trueish←{
  ⍝ Returns 1 if ⍵ is such that
  ⍝    ⍵≢0, ⍵≢,0, ⍵≢'', ~0∊⍴⍵, 0≠≢⍵
     0≡∊⍵:0
     0=⍴⍴⍵:1  ⍝ scalar that's not 0
     0∊⍴⍵:0   ⍝ includes '' (vector where ⍴⍵ is 0)
     1
 }
