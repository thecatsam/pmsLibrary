 msg2←{
     _←⎕SE.UCMD'require ∆Here'
     osascript←{
         11::'CANCEL'
         m←'<<MSG>>' '"' ''''⎕R ⍺'\\"' ''''''⊣⍵
         m←∊'"','"',⍨m,¨⎕UCS 13
         r←⎕SH ⎕←'osascript -s s -e ',m
         ⊃'"(.*)"'⎕S'\1'⊣r
     }

     ⍵ osascript ⍙HERE
⍝ tell app "Finder"
⍝      activate
⍝      display dialog "<<MSG>>"
⍝         buttons ["Dont Continue", "Continue"]
⍝ end tell

 }
