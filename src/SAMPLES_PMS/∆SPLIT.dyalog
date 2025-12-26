 ∆SPLIT←{⍺←0 ⋄ splitLTB←⍺ ⋄ ⎕IO ⎕ML←0 1
 ⍝ Split char vec ⍵ on blanks except within balanced quotes "" or '', which are then ignored.
 ⍝ Leading and trailing blanks are ignored unless ⍺=1
     NL←⊃⌽⎕TC
     '("[^"]*")+|(''[^'']*'')+' '^\h+' '\h+$' '\h+' '$'⎕R{
         m p←⍵.(Match PatternNum)
         p=0:1↓¯1↓m
         p∊1 2:splitLTB⊃''NL
         p∊3 4:NL
         ∘UNREACHABLE∘
     }⊣⊆⍵
 }
