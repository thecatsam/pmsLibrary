 ns←HTTPSimple
 ⍝ A simple way to use the Samples functions from Conga:
 ⍝  HTTPGet HTTPPost        HTTPReq
 ⍝ Usage:
 ⍝    ]box on
 ⍝    res ← HTTPSimple.HTTPGet 'google.com'
 ⍝  ⍝ Returns 3 or 4 items: rc, header, body [,certs]
 ⍝    :IF 0=⊃res
 ⍝        ⎕ED 'res3'⊣res3←res[3]
 ⍝    :Else
 ⍝        'Website not found' ⎕SIGNAL 11
 ⍝    :Endif
 ns←(⊃⎕SE.require'Conga:').Samples
