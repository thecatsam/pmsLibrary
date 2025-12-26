 CF←{

⍝ [CV | cancelObj] ← ChooseFile cancelObj          ⍝ ⍵ is ignored.
⍝
⍝ Choose a single file in a directory.
⍝ Returns a string, if a file is selected.
⍝   Returns cancelObj, if cancelled.
⍝
⍝  We use the multi-line approach with ¨activate¨  to avoid
⍝  dealing with the irritating bouncing Finder icon in the background
⍝
⍝ This runs only on mac...

⍝ If cancelled, ⎕EN=11. The message is: "Command interpreter returned failure code 1"
     11::⍵

     ⊃∘⎕CMD{
         r←'osascript 2>&1 '
         r,←' -e "tell application\"Finder\""'
         r,←' -e "activate "'
         r,←' -e "set fname to POSIX path of(choose file)"'
         r,←' -e "return fname "'
         r,←' -e "end tell "'
         ⍺⍺ r
     }⍬

 }
