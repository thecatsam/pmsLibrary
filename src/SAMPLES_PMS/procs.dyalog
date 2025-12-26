 {pActive}←{opts}procs template;pAll;pDescendants;pMatched;pTemp;res
⍝ Finds process and children matching a process grep pattern
⍝     template: a regular expression passed to 'ps -Ax | grep ...'
⍝     opts:     If 1, verbosely reports on
⍝                     template, matching task procids, descendant task procids.
⍝               If 0, simply returns as below.
⍝ Returns:
⍝  On success: Two sets of 0 or more ordered process numbers.     ⎕NC 2
⍝              <matching task procids> <descendant procids>
⍝  On error:   ⍬ ⍬
⍝              If opts=1, reports no such processes.

 :If 0=≢template
     template←'/Applications/Dyalog-\d\d+\.\d+\.app/Contents/MacOS/Dyalog-\d\d+\.\d+'
 :EndIf
 :If 0=⎕NC'opts'
     opts←1    ⍝ Verbose
 :EndIf

 :Trap 0
     pTemp←pMatched←∪⊃⌽⎕VFI∊⎕SH'ps -Ax | egrep ''',template,''' | grep -v grep | egrep -e ''^\s*\d+\s'' -o'
 :Else
     :If opts ⋄ ⎕←'No matching processes found' ⋄ :EndIf
     pActive←⍬ ⍬
     :Return
 :EndTrap
 pAll←⍬

 :While pTemp≢pAll
     pAll←pTemp
     :Trap 11
         res←⎕SH'pgrep -aP ',¯1↓∊(⍕¨pAll),¨','
     :Else ⋄ :Leave   ⍝ No more descendants...
     :EndTrap
     pTemp←∪pAll,⊃⌽⎕VFI⍕res
 :EndWhile
 pDescendants←pAll~pMatched
 pMatched←pMatched[⍋pMatched] ⋄ pDescendants←pDescendants[⍋pDescendants]

 :If opts
     ⎕←'Template:         "',template,'"'
     ⎕←'Matching task(s):',pMatched
     ⎕←'Descendants:     ',pDescendants
 :EndIf

 pActive←pMatched pDescendants
