 {ok}←Setup ignore
 ;DIR;utils;UCMD;util;fi;fn;msg;obj;wid;_
 ;Say0;Say1;SayE
 ;⎕IO 

 ⎕IO ⎕ML←0 1 
 ⎕PW←200

 UCMD←⎕SE.UCMD

 wid← 90
 Say1← {⍺←wid-4×2 ⋄ '=== ',' ===',⍨ ⍺↑⍵}
 ⎕←wid⍴'='
 ⎕←Say1 'If Dyalog abnormally terminates, try removing the session log(s)'
 fi← ∊⎕SH 'ls /Users/petermsiegel/.dyalog/session*.*'
 ⎕←Say1 'That is, do:'
 ⎕←Say1 '  ⎕SH ''rm ',fi,''''
 ⎕←wid⍴'='
 ⎕←''

 ⎕←50⍴'-'
 ⎕←'To update, do:'
 ⎕←'⍝    ]file.edit /Users/petermsiegel/MyDyalogLibrary/pmsLibrary/userCmds/Setup.dyalog'
 ⎕←'⍝    ⎕SH ''/Users/petermsiegel/MyDyalogLibrary/pmsLibrary/userCmds/updateMyUcmds'''
 ⎕←'To update ∆F_Publish'
 ⎕←'⍝    ]load ∆F_Publish'
 ⎕←'⍝    ∆F_Publish ''q''    ⍝ or Use ''fq'''
 ⎕←'Then go to Github Desktop and push to Github site'
 ⎕←50⍴'-'

 ⍝ Library directory
 DIR←'/Users/petermsiegel/MyDyalogLibrary/pmsLibrary/src'
 ⍝ Session libraries
 utils←'∆SH' '∆F' '∆D'
 
 
 #.⎕PATH,⍨←(' ⎕SE'↓⍨,0=≢⎕PATH)/⍨ ~' ⎕SE '(1∘∊⍷)' ',' ',⍨⎕PATH
 ok←0

 Say0←{1:⎕←⍵}
 Say1←{1:⎕←'>>> ',⍵}
 SayE←{1:⎕←'--- ','ERROR ',⍵}


 {}UCMD'cd ',DIR
 Say0'Directory now...'
 Say1 UCMD'cd'

 msg←⍬
 Say0'Loading utilities...'
 
 :For util :In utils
     fn←(2+⌈/≢¨utils){t←'"','"',⍨⍵ ⋄ ⍺<≢t:t ⋄ ⍺↑t}util
     :Trap 911
        
         ⎕SE.UCMD'obj←Load -target=⎕SE ',util
         obj←⍕obj
         Say1 (⎕PW-5)↑'Loaded "',obj,'"'
       
     :Else
         SayE'!!!FAILED to load ',util,' into ⎕SE'
     :EndTrap
 :EndFor


 Say0'Setup Complete. ⎕PW←',⍕⎕PW 
 ok←1
