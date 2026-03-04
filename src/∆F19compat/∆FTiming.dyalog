∆FTiming
 ;logfile 
  
logfile←'∆FTiming.data'
⎕←'Logfile is ',logfile

:Select ⊃⎕C ⍞↓⍨ ≢⍞←'T(ime or P(lot? [Time] '
  :Case 'p' 
     ⎕SHADOW 'lines; f1; t; V'~';'
      V← {⊃⌽⎕VFI ⍵}¨
      ⎕←'plotting'
      OUT←⍬
      lines← ⊃⎕NGET logfile 1 
      :FOR t :in 't1' 't2 cv' 't3 10' 't4'
          OUT,← ⊂V ('∆F\s+',t,'\s+→\s+([\d\.E¯]+)') ⎕S '\1'⊣lines 
      :ENdFor
       OUT←OUT[¯1+1 2 4 3] 
       ⎕←']plot OUT -type=tower'
      :RETURN
  :Caselist 't '
      ⋄
  :Else  
      ⎕←'Invalid!'
      :REturn 
:EndSelect 

:Trap 1000
  ⎕SHADOW '; cmpx; cv; d; data; in; ok; t1; t2; t3; t4; DYALOG_VERSION'~';'
  ⎕SHADOW '; Cmpx; Say; T1; T2; T3; T4; Time'~';'  
    DYALOG_VERSION←⊃⊃⌽'.'⎕VFI 1⊃'.'⎕WG'APLVersion'

    'cmpx'⎕CY'dfns' ⋄ Cmpx← cmpx 

    data←(70⍴'*')(∊∆F'{`T ⎕TS}. Dyalog Version { DYALOG_VERSION }')

    Say←{
          ⎕←⍵
          ⍎⍵
    }
    Time←{
        ⎕←'Timing Cmpx of ',⍺
        _←⎕WA
        d←↓⎕←Cmpx ⍵
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

    ⎕←'To update the log file, be sure the battery is not in LOW POWER MODE'
    ok←⎕C⍞↓⍨≢⍞←'Do you want to update the log file? [yes] '
    ⎕←''
    :If ~'n'∊ok
        ⎕←'*** Updating log file'
        (⊂data)⎕NPUT logfile 2
    :EndIf

    in←⎕NGET logfile 2
    ⎕ED'in'
    ⎕←'To make any changes to the log file, execute the statement below.'
    ⎕←'   ]file.edit ',logfile

:Else   
   ⎕←'∆FTiming was interrupted. Nothing saved!'
:EndTrap 