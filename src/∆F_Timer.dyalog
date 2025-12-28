 ∆F_Timer
 ;cmpx
 ;C;T
 ;msg;i;t
 ;⍙Fapl

 'cmpx'⎕CY'dfns'

 ⎕SE.UCMD']load ∆F -t=⎕SE'
 C←11 30 60

⍝ Here's our ∆F String t
 t←'The temperature is {"I2" $ C}°C or {"F5.1" $ F← 32+9×C÷5}°F'

⍝  Let's precompute a dfn T, given ∆F String t.
⍝  It has everything needed to generate the output,
⍝  except the external variables or additional arguments needed.
 T←1 ∆F t

 msg←(⎕UCS 13),'With comments'
 :For i :In ⍳2
⍝  Compare the performance of the two formats…
⍝  The precomputed version is about 17 times faster, in this run.
     ⎕←msg
     ⎕←'Testing ',t
     ⎕←'cmpx "∆F t" "T ⍬"'
     cmpx'∆F t' 'T ⍬'
     ⎕←'Original...'
     ⎕←'  ∆F t → 1.7E¯4 |   0% ⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕'
     ⎕←'   T ⍬ → 1.0E¯5 | -94% ⎕⎕'

     SRC∘←'^\h*⍝.*' '''[^'']*''' '⍝.*$'⎕R'' '&' ''⊣⎕SRC ⎕SE.⍙Fapl
     SRC←(0≠≢¨SRC)/SRC
     ⎕SE.⎕FIX SRC
     msg←(⎕UCS 13),'Without comments'
 :EndFor
