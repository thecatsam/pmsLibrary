 res←{options}msg lines;notify;timeout
 ;alert;buttons;cmd;code;def;defButton;dq;dqE;dqE_R;dqesc
 ;esc;getbtn;hiddenFlag;nb;prompt;promptFlag;quot;time;title;type;⎕IO
 ⍝ Display an applescript msg, appropriately escaped...
 ⍝   [type:1.0 [defButton [timeout]]] msg lines
 ⍝ options: [type: 0] [default: 0 → # types]
 ⍝ type: the type of msg
 ⍝ timeout: if non-zero, abort the msg after <timeout> seconds.
 ⍝          VALID ONLY ON MSG-ONLY CODES 0-3
 ⍝
 ⍝  MESSAGE-ONLY CODES: lines are 1 or more lines to be separated by newlines.
 ⍝    Codes: 0 through 3
 ⍝  PROMPTING CODES: lines[0] is prompt, lines[1] is initial value (default: '')
 ⍝    Codes: 10, 11
 ⍝
 ⍝  type   title             buttons*
 ⍝  1.0  - Information       OK               Returns ⎕NULL on timeout
 ⍝  1.1  - Alert             OK               "
 ⍝  1.2  - Warning           OK               "
 ⍝  1.3  - Error             ERROR            "
 ⍝ ¯1.0  - Notification                       Use notify (terminal-notifier) in place of alert (Apple msgs)
 ⍝                                            If notifications are suppressed, nothing will appear!
 ⍝  2    - Confirm-Cancel    CANCEL  YES      Returns ⎕NULL on cancel/timeout
 ⍝  2.1  - Confirm           NO      YES      "
 ⍝  3    - Select-Cancel     CANCEL  NO   YES Returns ⎕NULL on cancel (no timeout)
 ⍝  10   - Prompt            CANCEL  OK       "
 ⍝  11   - Prompt for pswd   CANCEL  OK       "
 ⍝ * The default button is the last, unless <defButton> is specified
 ⍝ defButton: The default button (default: last button)

 ⎕IO←0

 dq←,'"' ⋄ dqE←dq('\',dq) ⋄ dqE_R←('\\',dq)((6⍴'\'),dq)
 esc←{⍺←0 ⋄ rq←⍺⊃dqE_R ⋄ ∊dq ⎕R rq⊣⊆⍵}   ⍝ Returns vector
 quot←{⍺←0 ⋄ q←⍺⊃dqE ⋄ q,⍵,q}
 code←{'UTF-8'⎕UCS ⎕UCS∊⍵}
 alert←{⍺←0 ⋄ btns defbtn ttl←⍵
     nb←≢btns←⊆btns
     btns←'{','}',⍨1↓∊',',¨quot¨btns
     defbtn←⍕0⌈nb⌊nb defbtn⊃⍨defbtn>0

     cmd←esc'tell app "System Events" to display dialog '
     cmd,←1 quot 1 esc ¯2↓∊lines,¨⊂'\n'
     cmd,←esc' buttons ',btns,' default button ',defbtn,' with title "',ttl,'"'
     cmd,←esc(×⍺)/' giving up after ',⍕⍺
     ⊢cmd←'osascript -e ',quot cmd
 }
 notify←{
 ⍝ Call terminal-notifier on the mac.
 ⍝ msg: A message possibly containing
 ⍝      single quotes, double quotes, newlines (\n), or Unicode characters.
     dqt←'"'
     notifier←'/usr/local/bin/terminal-notifier'

     ⍺←'Notification' ⋄ button msg←⍵
     title←dqt ⎕R'\\\0'⊣⍺
     msg←dqt ⎕R'\\\0'⊣(⊆msg),¨⊂'\n'

     ∊'echo "',msg,'" | ',notifier,' -title "',title,'" -sound default; echo ":',button,'"'
 }
 ⍝ getbtn: Expects string with 'BUTTON: ignore' or 'BUTTON, ignore: ignore'
 ⍝         The latter occurs only with a timeout!
 getbtn←{0≠≢res←1(819⌶){⍵↑⍨⍵⍳','}⍵↓⍨1+⍵⍳':':res ⋄ ⎕NULL}
 prompt←{   ⍝ Prompt for response; ⍺=1: response is hidden from view.
     ⍺←0
     btns defbtn lines←⍵
     nb←≢btns←⊆btns
     btns←'{','}',⍨1↓∊',',¨quot¨btns
     defbtn←⍕0⌈nb⌊nb defbtn⊃⍨defbtn>0

     pr←1 quot 1 esc 0⊃lines
     deftxt←1 quot 1 esc 1⊃lines,⊂''
     cmd←'osascript -e "Tell application \"System Events\"'
     cmd,←' to display dialog ',pr,' with ',(⍺/'hidden'),' answer'
     cmd,←esc' buttons ',btns,' default button ',defbtn
     cmd,←' default answer ',deftxt,'" -e "text returned of result" 2>/dev/null'
     cmd
 }

 lines←,⊆lines
 :If 0=⎕NC'options' ⋄ options←0 0 ⋄ :EndIf
 type defButton timeout←3↑options,0 0

 :Select type
 :Case ¯1
     buttons←'OK' ⋄ title←'Notification' ⋄ promptFlag←¯1
 :CaseList 0 1
     buttons←'OK' ⋄ title←'Information' ⋄ promptFlag←0
 :Case 1.1
     buttons←'OK' ⋄ title←'Alert' ⋄ promptFlag←0
 :Case 1.2
     buttons←'OK' ⋄ title←'Warning' ⋄ promptFlag←0
 :Case 1.3
     buttons←'ERROR' ⋄ title←'Error' ⋄ promptFlag←0
 :Case 2
     buttons←'Cancel' 'Yes' ⋄ title←'Proceed?' ⋄ promptFlag←0
 :Case 2.1
     buttons←'No' 'Yes' ⋄ title←'Select' ⋄ promptFlag←0
 :Case 3
     buttons←'Cancel' 'No' 'Yes' ⋄ title←'Select-Cancel'
 :Case 10 ⍝ 1st line: prompt; 2nd line: default
     buttons←'Cancel' 'OK' ⋄ promptFlag hiddenFlag←1 0
 :Case 11  ⍝ 1st line: prompt; 2nd line: default
     buttons←'Cancel' 'OK' ⋄ promptFlag hiddenFlag←1 1
 :Else
     title←'Domain Error: Unknown msg type: ',⍕type
     1.3 msg title ⋄ title ⎕SIGNAL 11
 :EndSelect

 :If promptFlag=1
     cmd←hiddenFlag prompt buttons defButton lines
 :ElseIf promptFlag=¯1
     cmd←title notify buttons lines
 :Else
     cmd←timeout alert buttons defButton title
 :EndIf

 :Trap 11 1000
     res←getbtn⍣(1≠promptFlag)⊣code ⎕SH cmd
 :Else
     res←⎕NULL   ⍝ A 'CANCEL' treated specially, returning ⎕NULL
 :EndTrap
