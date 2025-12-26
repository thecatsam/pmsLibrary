 web←{
     ⍺←⍵    ⍝ ⍺: Header title. By default ⍵: the URL we're going to display.
   ⍝ Prefix URL with https://, if not there. Ignore existing '//' prefix.
     url↓⍨←2×'//'≡2↑url←⍵
     url,⍨←pfx/⍨pfx≢url↑⍨≢pfx←'https://'
   ⍝ Create skeletal html
     html←'<html>' '<head>'
     html,←⊂'<meta http-equiv="refresh" content="0;url=',url,'" />'
     html,←'</head> </html>'
   ⍝ Display in RIDE the required html, with the url ⍵, with header title ⍺.
     1:_←⍺(3500⌶)∊html
 }
