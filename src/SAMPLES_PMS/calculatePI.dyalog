 pi←{
     ⎕FR←645
     n←⍵+2|⍵
     dblFactorial←{⎕IO←1 ⋄ (-2|⍵)+2×⍳⌈⍵÷2}
     dup←{⍵⍴⍨2×≢⍵}
 ⍝ Divide one by one to avoid the overflow and slowness of ⎕FR←1287
 ⍝ of ×/(×/2...)÷(×/¯1↓...)
     ×/(2,dup dblFactorial n)÷¯1↓dup dblFactorial n+1
 }
