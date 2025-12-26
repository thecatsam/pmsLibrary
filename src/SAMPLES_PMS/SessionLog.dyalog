 lines←SessionLog all;⎕IO
 ⍝   lines@VS ←  SessionLog all@bool:1|0
 ⍝   all=1: Returns current Dyalog session log as a vector of char vectors
 ⍝   all=0: Returns user input lines only...

 ⎕IO←0

 lines←⎕SE ⎕WG all⊃'Input' 'Log'
