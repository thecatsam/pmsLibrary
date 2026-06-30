G←{
    '.'≠⊃w←NoLB ⍵:'' 0
    w←1↓w
    w←NoLB w
    len←Span w
    nm←len↑w
    '←'=⊃'∘ '~⍨len↓w:nm 1
     nm 0
  }
