 r←msgBox arg;ans;Btns;Caption;choices;evt;hint;Mode;msgbox;N;No;parms;t;Text;Warn
⍝ Return 1, 2 or 3 for buttons pressed
 ⍝ From ⎕SE.SALTUtils .
 :Access Shared Private
 (Caption Text Mode Btns)←arg,(⍴arg)↓0 0 'Warn',('Yes' 'No')(⊂'OK')[Warn←1+arg[3⌊⍴arg]∊'Info' 'Msg']
 :Trap 0 ⍝ Try ⎕WC if no simple cross-platform dialog box
     r←¯60+3503⌶Caption Text Mode Btns
 :Else
     :Trap 0 ⍝ revert to ⍞ if GUI impossible
         {x←÷~3501⌶⍬}'is Ride connected?' ⍝ then no GUI
         'msgbox'⎕WC'msgBox'Caption Text Mode Btns('Event'(evt←61 62 63)1)
         r←4|evt⍳2⊃⎕DQ'msgbox'
     :Else
         Text~←⊂''
         (N No)←Warn⊃¨('nN' 'oO')('n (No)' 'o (OK)')
         choices←'yY',N,(t←3∊⍴Btns)/'cC' ⋄ hint←' y/',(1↑N),(t/'/c'),'? '
         ⎕←((⍴Text),⍳1≠≡,Text)⍴Text
         :While ~1∊ans←choices={⍞←⍵ ⋄ 1↑(⍴,⍵)↓⍞}⍕hint
             ⎕←'** Enter one of y (Yes) or ',No,t/' or c (Cancel)'
         :EndWhile
         r←(∨/3 2⍴ans)⍳1
     :EndTrap
 :EndTrap
