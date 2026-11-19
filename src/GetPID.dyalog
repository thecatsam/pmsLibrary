r←GetPID;where;libs;Scan
where←⎕SE
:If 3≠where.⎕NC'⍙GetPID'
   :If 'Win'≡3↑1⊃'.'⎕WG'APLVersion'
      '⍙GetPID'⎕NA'U4 kernel32|GetCurrentProcessId'
   :Else
      libs←'/usr/lib/libc.dylib' 'libc.so.6' 'msvcrt.dll'
      where.⎕EX'GetPID'
      Scan←{
        0::∇ 1↓⍵
        0=≢⍵:0
         _←'⍙GetPID'where.⎕NA'I4 ',(⊃⍵),'|getpid'
        3=where.⎕NC'⍙GetPID':1
         ∇ 1↓⍵
      }
   :If ~Scan libs ⋄ 'Could not find getpid in library!'⎕SIGNAL 11 ⋄ :EndIf
   :EndIf
:EndIf
r←where.⍙GetPID
