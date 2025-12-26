 Plot←{
 ⍝ {svg} ←{heading} plotFn ∇ [labels]⊣ data
 ⍝   heading: The optional title. Not set if omitted.
 ⍝   plotFn:  The fn with the actual plot info.
 ⍝            ⍺ is the SharpPlot obj (sp) (i.e. ⍺.SetNewLine '?' sets newline to '?')
 ⍝            Call:   ⍺:sp plotFn ⍵:data
 ⍝                    where ⍺.LIB (alias L, Lib) points to the merged SharpPlot libs: System and Causeway
 ⍝                    Note: LIB.System and LIB.Causeway are defined (point to LIB).
 ⍝   data:    Data passed to plotFn
 ⍝ Returns shy result:
 ⍝   svg:     readable SVG code returned by RenderSvg
 ⍝ Example:
 ⍝   'Test' {⍺.DrawLineGraph ⍵}Plot (1○0.05×⍳200)
     ⎕IO←0 ⋄ lc←(819⌶)
     ⍺←⎕NULL ⋄ xLabels←⍵⍵

 ⍝   title  1: Within the plot; 2: In the window heading
 ⍝          Let %D be the ISO-std Date, %T the time, %DT be ISO-std date-time
     ∆TS←{
         l r b←{(10↑⍵)(11↓⍵)⍵},'G⊂9999⊃,2(⊂-⊃,G⊂99⊃),⊂T⊃,G⊂99⊃,⊂:⊃,G⊂99⊃'⎕FMT⍉⍪5↑⎕TS
         '%D\b' '%T\b' '%DT\b'⎕R l r b⊣⍵
     }
     title1 title2←∆TS¨'SharpPlot %DT'{⎕NULL≡⍵:' '⍺ ⋄ 1=≢⊆⍵:⍵ ⍺ ⋄ ⍵}⍺

  ⍝  Labels...
     xSel←(⊂lc xLabels)∘{1≠≢⍺:0 ⋄ ⍺∊⊆⍵}
     ⋄ months←'Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun' 'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec'
     ⋄ daysL←'Sunday' 'Monday' 'Tuesday' 'Wednesday' 'Thursday' 'Friday' 'Saturday'
     ⋄ daysS←3↑¨daysL
     xSel'months':⍺(⍺⍺ ∇∇ months)⍵
     xSel'daysl':⍺(⍺⍺ ∇∇ daysL)⍵
     xSel'dayss' 'days':⍺(⍺⍺ ∇∇ daysS)⍵

   ⍝ NR:      "Conditionally call routine that has no result"
   ⍝ ⍺⍺ NR ⍵:  Call SmartPlot methods that return no result, returning ⍬
   ⍝           ENX 22: 'VALUE ERROR: No result was provided when the context expected one'
     NR←{⍺←⊢ ⋄ 6::⎕DMX.{EM ⎕SIGNAL EN/⍨~ENX∊⍵}22 ⋄ ⍵⍵:⍺ ⍺⍺ ⍵ ⋄ ⍵}

   ⍝*** Initialize SharpPlot library                DEFAULT            TYPE
   ⍝    wsName   source namespace;                  'sharpplot.dws'    str
   ⍝    libName  namespace name we will use;        '__SharpLib'       str
   ⍝    top      namespace ref it's located in.     #                  ns ref
   ⍝    LIB←     namespace ref for libName          #.__SharpLib       ns ref
     wsName libName top←'sharpplot.dws' '__SharpLib'#
     LIB←{wsName libName top←⍵
         0≠top.⎕NC libName:top⍎libName
         wsName{⍵⊣⍵.⎕CY ⍺⊣⍵.System.Drawing←⍵.System←⍵.Causeway←⍵
         }⍎libName top.⎕NS''
     }wsName libName top

⍝*** Create SharpPlot object <sp>
     sp←⎕NEW LIB.SharpPlot
     sp.(L Lib LIB)←⊂LIB                          ⍝ Pass library as field of <sp> (aliased)
     _←sp.SetNewline NR 1⊣'⋄'
     _←sp.SetXLabels NR(0≠≢xLabels)⊣xLabels
     _←{0=≢⍵:⍵ ⋄ sp.Heading←⍵}title1              ⍝ Set heading from title1, if set.
     sp.LineGraphStyle←LIB.LineGraphStyles.GridLines
     display←title2∘(3500⌶)                        ⍝ Display linked to desired box heading

⍝*** Generate SharpPlot object
     _←(sp ⍺⍺ NR 1⊣⍵)
     svg←sp.RenderSvg LIB.SvgMode.Stretchable     ⍝ Generate object and render as svg
     _←display svg                                ⍝ Display rendered svg
     1:_←svg                                      ⍝ Return (shy) SVG string

 }
