 dictDemo;d;enter;lines;words
 require'Dict'

 'Enter lines...'
 enter←,⍞ ⋄ lines←''
 :While 0≠≢enter
     lines,←enter,' '
     enter←,⍞
 :EndWhile
 lines←' '@(∊∘',./?();.[]-:"''')⊣lines

 words←' '(≠⊆⊢)⊣lines←'\w'⎕R'\l0'⊣lines
 d←∆DICT ⍬

 d.inc words
 d.hprint
