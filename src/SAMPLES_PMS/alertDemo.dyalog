 r←alertDemo args;obj;event;operation;scode;stext;mime;url;header;postdata;intercept
⍝
 args←⊆args
 ⎕←('args [',(⍕≢args),']')args
 :If 8<≢args
     ⎕←'Callback'
   ⍝ Our first HTTPRequest callback function
     (obj event operation intercept scode stext mime url header postdata)←args
     intercept←1                             ⍝ Intercept this call
     (scode stext mime)←200 'OK' 'text/html' ⍝ HTTP success code
     url←header←''                           ⍝ Nothing clever at all
     postdata←'Thank you!'                   ⍝ Data
     r←(obj event operation intercept scode stext mime url header postdata)
 :Else
   ⍝ Now, define a form and set up the callback:
     'Setting up alert'
     'hr'⎕WC'HTMLRenderer' '<p>Hello, <b>APL</b>ers!</p>'
     hr.(Coord Size Posn)←'Pixel'(500 500)(1000 100)
     hr.HTML,←'<form action="#"><button>Click Me!</button></form>'
     hr.onHTTPRequest←'alertDemo'
 :EndIf
