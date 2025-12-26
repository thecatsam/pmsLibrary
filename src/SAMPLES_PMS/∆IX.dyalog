 ∆IX←{
    ⍝    ix ∆IX obj,
    ⍝    If an index i for a dimension is ⎕NULL,
    ⍝       it will be replaced by ⍳(the i-th element of ⍴obj), i.e. ⍳i⊃⍴obj
    ⍝    If no ⎕NULL axes, ∆IX is a synonym for ⌷
    ⍝
    ⍝    ⎕IO inherited from caller.
    ⍝
    ⍝       obj←⍳5 5 5    ⍝ ⎕IO←0
    ⍝       4 ⎕NULL 3 ∆IX obj
    ⍝    4 0 3  4 1 3  4 2 3  4 3 3  4 4 3
    ⍝       (4 ⎕NULL 3 ∆IX obj)≡obj[4;;3]
    ⍝    1

     ⍵⌷⍨⍺{⎕NULL≡⍺:⍳⍵ ⋄ ⍺}¨⍴⍵

 }
