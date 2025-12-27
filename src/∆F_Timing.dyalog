∆F_Timing
;cmpx;cv;d;data;in;logfile;t1;t2;T1;T2


DYALOG_VERSION←⊃⊃⌽'.'⎕VFI 1⊃'.'⎕WG'APLVersion'
logfile←'∆F_Timing.data'
⎕←'Logfile is ',logfile

'cmpx'⎕CY'dfns'

data←(70⍴'*')(∊∆F'{`T ⎕TS}. Dyalog Version { DYALOG_VERSION }')

Time←{
    ⎕←'Timing cmpx of ',⍺
    d←↓cmpx ⍵
    data,←(⊂'>>> ',⍺),d
}

cv←11 30 60
t1←'The temperature is {"I2" $ cv}°C or {"F5.1" $ 32+9×cv÷5}°F'
T1←1 ∆F t1
'T1'Time'∆F t1' 'T1 ⍬'

   t2←'The temperature is {"I2" $ `⍵1}°C or {"F5.1" $ 32+9×`⍵1÷5}°F'
   T2←1 ∆F t2
'T2'Time'∆F t2 cv' 'T2 ⊂cv'

(⊂data)⎕NPUT logfile 2

in←⎕NGET logfile 2
⎕ED'in'
