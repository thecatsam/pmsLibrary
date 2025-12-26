Rogue version
;lines;good;ok;pat;pids

:If 0=1↑0⍴version ⋄ :AndIf 18≤version ⋄ :AndIf version≤30
:AndIf version=⌊version
    lines←⎕SH'ps -eax | grep Dyalog'

    pat←'^.{25}/Applications/Dyalog-',(⍕version),'\.\d+'
    good←pat ⎕S'\0'⊣lines
    pids←{⊃⌽⎕VFI 5↑⍵}¨good
    :If ×≢good
        ⎕←'Apps found'
        ⎕←↑good
        ok←'y'=1↑' '~⍨⍞↓⍨≢⍞←'Delete? '
        :If ok
            ⎕←'Deleting: ',pids
            {}⎕SH'kill ',⍕pids
            {}⎕DL 1
            {}⎕SH'kill -9 ',⍕pids
        :Else
            ⎕←'Nothing deleted (per user request)'
        :EndIf
    :Else
        ⎕←'No matching apps found'
    :EndIf
:Else
    ⎕←'The version must be an integer between 18 and 30'
:EndIf
