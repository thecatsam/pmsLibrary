 calcBI←{⎕IO←0
     num←'\'~⍨∊⎕SH'echo "5^4^3^2" |bc'
     expected20_20←'62060698786608744707' '92256259918212890625'
     actual20_20←20 ¯20↑¨⊂num
     ⎕←'We calculated 5*4*3*2'
     ⎕←'The expected first and last 20 digits are:'expected20_20
     ⎕←'The actual first and last 20 digits are  :'actual20_20
     ⎕←'Are the actuals in agreement? ',(actual20_20≡expected20_20)⊃'No' 'Yes'
     ⎕←'Length of result is:'(≢num)
     1:_←num
 }
