 r←myapp args;_;event;intercept;obj;operation;scode;stext
 ;mime;url;header;postdata;approot;page;requested
⍝ Serve up a small application
 approot←'http://myapp/'
 :If 0=≢args⍝ Setup
     #.MyApp←⎕NS''
     #.MyApp.main←'Hello APLers<br/>Click <a href="clicked">here</a>!'
     #.MyApp.clicked←'Thank You!<br/>Click <a href="main">to go back...</a>!'
     event←'Event' 'HTTPRequest' 'myapp'
     'hr'⎕WC'HTMLrenderer'('Size' 290 290)('Coord' 'ScaledPixel')event
     hr.URL←approot,'main' ⍝ Off we go!
     :Return
 :EndIf
 (obj event operation intercept scode stext mime url header postdata _)←args
 requested←url ⍝ remember this
 :If intercept←approot≡(≢approot)↑url ⍝ is the URL in our domain?
     page←(≢approot)↓url
     :If 2=MyApp.⎕NC page             ⍝ Do we have a variable with the name of the requested page?
         (scode stext mime)←200 'OK' 'text/html' ⍝ Yes
         postdata←MyApp⍎page          ⍝ Return the value of the variable as output
     :Else
         (scode stext)←404 'Page not found'  ⍝ Aww shucks
         postdata←'Page not found'
     :EndIf
     url←''                           ⍝ Not doing anything clever
     header←'Cache-control: no-cache' ⍝ Always refresh these pages
     r←(obj event operation intercept scode stext mime url header postdata _)
 :EndIf
 ⎕←((1+intercept)⊃'[pass]'(6↑⍕scode)),' ',requested
