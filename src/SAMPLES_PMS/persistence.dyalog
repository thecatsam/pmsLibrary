 persistence←{
   ⍝  1  persistence n  - checks for persistence, returns (degree of persistence) values
   ⍝ [0] persistence n -    "     "       "     , returns (degree of persistence)
   ⍝  n: Always an integer, not a string.

     ⍺←0
     1<≢⍵:↑⍺ ∇¨⍵

     ⎕PP←34        ⍝ Use 34-bits of precision (use more if 128-bit dec floats used...)
     verbose←⍺     ⍝ Defaults to 0.
     list←{
         s←⍕⍵            ⍝ String format never has leading 0.
         1≥≢s:⍺
         s2←×/⎕D⍳s       ⍝ Determine ×/s, where s are digits in ⍵
         (⍺,s2)∇ s2      ⍝ Add s2 to accumulator in ⍺.
     }⍨⍵                 ⍝ Primes the accumulating list ⍺ with [⍵]
     verbose:(≢list)list
     ≢list
 }
