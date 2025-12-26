 resolve←{n←ns
     F←'.'(≠⊆⊢)⍵           ⍝ Split a.b.c into atoms: a |   b    |   c
     p←⌽{⍺,'.',⍵}\F             ⍝ Compress prefix:   a.b.c  |  a.b   |   a
     s←(⊂⍬),¯1↓{⍵,'.',⍺}\⌽F     ⍝ Expand suffix:       ⍬    |   c    |  b.c
     list←↓⍉↑p s                ⍝ Merge             a.b.c ⍬ | a.b c  | a b.c
     ifNot←{0≠≢⍵:⍵ ⋄ ⍺}
     v←''
     ptr←{0::'' ⋄ 2≠n.⎕NC ⍵:'' ⋄ v∘←⎕OR ⍵ ⋄ 2≠n.⎕NC'v':'' ⋄ ¯1=n.⎕NC v:'' ⋄ v}
     process←{
         0=≢⍵:⍺                 ⍝ Not found: Return original string...
         prefix rest←⊃⍵
         2=n.⎕NC prefix:(prefix ifNot ptr prefix),'.',rest
         ⍺ ∇ 1↓⍵
     }

     0≠≢v←ptr ⍵:v
     ⍵ process 1↓list   ⍝   Already checked first item.
 }
