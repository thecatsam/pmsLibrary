r←piTimes n
:IF 1≠≢n 
   r←piTimes¨n 
:Else
  ::STATIC piN←⎕NULL SimpleDict '' ⊣⎕SE.UCMD 'require Dict'
  :IF ⎕NULL≢r←piN.get n   ⍝ ⎕NULL if  n is missing.
      ⎕←'cached ',n
      :return
  :ENDIF
  r←○n
  piN.set n r
:Endif
