 assert←{
     ⍵=1:_←0
     0::⎕SIGNAL/'Unexpected assertion failure'⎕EN⊣⎕←↑⎕DMX.DM
     ⍺←⍬ ⋄ ⎕SIGNAL⊂('EM' 'Assertion failure')('EN' 911),(0≠≢⍺)/⊂'Message'(⍕⍺)
⍝ [⍺←⍬] assert ⍵.
⍝ "If ⍵ is true, returns shy 0; else ⎕SIGNALS (EN) 'Assertion failure" with error num (EN) 911,
⍝  and an optional Message field (⍕⍺)."
⍝  ⍵: boolean scalar or one-element vector
⍝  ⍺: 0-length or omitted [IGNORE]; char or num scalar/vector [forms ⎕DMX.Message].
⍝  ←: shy 0 if ⍵, else ⎕SIGNALs.
 }
