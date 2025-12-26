all←Clean
;all;base;bad
base←'/Users/petermsiegel/MyDyalogLibrary/pmsLibrary/*'
all←0 ⎕NINFO⍠('Wildcard' 1)('Recurse' 2)⊢base
bad←all/⍨∊'~'=¯1↑¨all
