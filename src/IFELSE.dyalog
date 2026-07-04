Test

lines←(
    'This is before'
    '⍝::IF_ARGCACHE'
    '    This is the first'
    '    This is the second'
    '⍝::ELSE'
    '    this is 2,1'
    '    this is 2,2'
    '⍝::ENDIF'
    'This is some more'
     'This is before the second set'
    '⍝::IF_ARGCACHE'
    '    This is the first'
    '    This is the second'
    '⍝::ELSE'
    '    this is 2,1'
    '    this is 2,2'
    '⍝::ENDIF'
    'This is some more the end'
)
⎕←↑lines

''
'Scanning...'
''

in←'^\N*::IF_ARGCACHE\N*\n(.*?)⍝::ELSE\N*\n(.*?)\n⍝::ENDIF\N*$'
out←'\1\x{00}\2\n'
opts←('NEOL' 1)('EOL' 'LF')('Mode' 'M')('DotAll' 1)

sets←in ⎕S out⍠opts⊢lines
line←1
:For set :In sets
    ⎕←'[',(⍕line),']'
    first second←(⎕UCS 0)(≠⊆⊢)⊢set
    ⎕←first
    ⎕←60⍴'¯'
    ⎕←second
    line+←1
    ⎕←100⍴'¯'
:EndFor
