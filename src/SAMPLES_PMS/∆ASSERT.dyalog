 ∆ASSERT←{
     ⍵:_←0
     ⍺←'assertion failed'
     ⍺ ⎕SIGNAL 911

⍝       [msg] ∆ASSERT  cond
⍝    If cond=1, returns shy 0 fast.
⍝    Otherwise, signals 911 with message ⍺ (default: 'assertion failed')
⍝    To trap and report in caller:
⍝           911: ↑⎕DMX.DM
 }
