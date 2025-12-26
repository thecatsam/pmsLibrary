 backup;dwsList;fi;fmt;src;timestamp;ts;utf;zip;⎕IO
 ⎕IO←0

 utf←{'UTF-8'⎕UCS ⎕UCS ⍵}¨⊆      ⍝ Show UTF-8-ified filenames ok

 fmt←'I4,2G<99>,<T>,2G<99>,2I0'  ⍝ YYYYMMDD T HHMM (ignore SS MS)
 timestamp←,fmt ⎕FMT⍉⍪ts←⎕TS

 '=====  BACKUP ====='
 '¯'⍴⍨≢⎕←'Date and time: ',(⍕ts)
 zip←'ARCHIVE/pmsLibrary:',timestamp,'.zip'
 src←'pmsLibrary/src/* pmsLibrary/docs/* pmsLibrary/userCmds/*  *.dyalog'  ⍝

 '∘ Dyalog .dyalog (source) files'
 '  Creating zip file: ',zip
 ⎕←utf'  Source files are: ',∊' ',¨1⊃¨⎕NPARTS ⎕SH'ls ',src

 ⍞←'  Backup ',src,'? [yes] '
 :If ~1∊'Nn'∊⍞
      ⋄ sr←'(adding|updating): +' '\(deflated +(\d+\%)\) *' 'PMSLibrary\/' '\.dyalog' ' +'
      ⋄ sn←'' '(↓\1), ' '' '' ' '
     'Stats: ',sr ⎕R sn⊣∊utf ⎕SH'zip ',zip,' ',src
     '∘ Backup complete. Created "',zip,'"'
 :Else
     '∘ Note: dyalog files not backed up.'
 :EndIf

 dwsList←⊆'utilPMS' 'generator'
 '∘ Dyalog .dws (workspace) file(s)'
 '  Backing up to directory ARCHIVE'
 '  Backing up individual dws files:',∊' ',¨dwsList

 ⍞←'  Backup *.dws? [yes] '
 :If ~1∊'Nn'∊⍞
     :For fi :In dwsList
         ⎕SH'cp ',fi,'.dws ARCHIVE/',fi,timestamp,'.dws'
         '∘ ARCHIVED: ',fi,' → ',fi,timestamp
     :EndFor
 :Else
     '∘ Note: dws files not backed up.'
 :EndIf
