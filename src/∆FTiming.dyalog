∆FTiming
;cmpx;cv;d;data;in;logfile;ok;t1;t2;T1;T2


DYALOG_VERSION←⊃⊃⌽'.'⎕VFI 1⊃'.'⎕WG'APLVersion'
logfile←'∆FTiming.data'
⎕←'Logfile is ',logfile

'cmpx'⎕CY'dfns'

data←(70⍴'*')(∊∆F'{`T ⎕TS}. Dyalog Version { DYALOG_VERSION }')

Say←{
      ⎕←⍵
      ⍎⍵
}
Time←{
    ⎕←'Timing cmpx of ',⍺
    _←⎕WA
    d←↓⎕←cmpx ⍵
    data,←(⊂'>>> ',⍺),d
}

Say'cv←11 30 60'
Say't1←''The temperature is {"I2" $ cv}°C or {"F5.1" $ 32+9×cv÷5}°F'''
T1←1 ∆F t1
'T1'Time'∆F t1' 'T1 ⍬'

Say't2←''The temperature is {"I2" $ `⍵1}°C or {"F5.1" $ 32+9×`⍵1÷5}°F'''
T2←1 ∆F t2
'T2'Time'∆F t2 cv' 'T2 ⊂cv'


Say't3← ''ab`⋄cd`⋄ef{ { ({10⍴`⍵1}⍵)⍳`⍵1}10⍴`⍵1}ab`⋄cd`⋄ef{ { ({10⍴`⍵1}⍵)⍳`⍵1}10⍴`⍵1}ab`⋄cd`⋄ef{ { ({10⍴`⍵1}⍵)⍳`⍵1}10⍴`⍵1}'''
T3←1 ∆F t3
'T3'Time'∆F t3 10' 'T3 ⊂10'

Say't4← ''abc { "one`⋄twin`⋄elephant" } { "one``abc""def"} abc{ "one`⋄twin`⋄elephant" } { "one``abc""def"} '''
T4←1 ∆F t4
'T4'Time'∆F t4' 'T4⍬'

ok←⎕C⍞↓⍨≢⍞←'Do you want to update the log file? [yes]'
:If ~'n'∊ok
     ⎕←'*** Updating log file'
    (⊂data)⎕NPUT logfile 2
:EndIf

in←⎕NGET logfile 2
⎕ED'in'
