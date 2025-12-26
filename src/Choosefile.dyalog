 r←ChooseFile;e
⍝ [CV | ⎕NULL] ← ChooseFile
⍝
⍝ Choose a single file in a directory.
⍝   Returns a string, if a file is selected.
⍝   Returns ⎕NULL, if cancelled.
⍝
⍝ LIMITATIONS: This runs only on mac...

⍝ If cancelled, ⎕EN=11. The message is: "Command interpreter returned failure code 1".
 :Trap 11
   ⍝ We use the multi-line approach with activate to avoid the irritating bouncing Finder icon in the background

     e←' -e "tell application \"Finder\""'
     e,←' -e    "activate"'
     e,←' -e    "set fname to POSIX path of (choose file)"'
     e,←' -e    "return fname"'
     e,←' -e "end tell"'

     r←⊃⎕CMD'osascript 2>&1 ',e
 :Else

     r←⎕NULL                                        ⍝ Cancelled...

 :EndTrap
