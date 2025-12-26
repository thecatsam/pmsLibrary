 {html}←{fmt}alert2 msg;escapeIn;escapeOt;∆ESC;∆ESChtml;∆ESCjs;∆FMTjs;∆UTF8
 ⍝ An HTMLRenderer example.
 ⍝
 ⍝ Simple way to create an alert that accepts any APL string that is compatible with ⎕FMT (1-adic or 2-adic).
 ⍝
 ⍝ Both HTML and (embedded) Javascript deal with UTF-8 fine.
 ⍝ So we just use UTF-8 rather than encoding everything about 127.
 ⍝ To add a newline, don't do \n (could mean something in APL):
 ⍝      Use matrices directly or via ↑'str1' 'str2'...

 ⍝ Be sure to specify UTF-8 for charset. Then use APL chars as is after converting string to UTF-8.
 ⍝ We escape certain chars in Javascript to maintain the integrity of strings when we interpolate values. See ∆ESC etc.
 ⍝ In the html below, we insert any string we want to replace ⍞ALERT⍞, but do it in such a way that the
 ⍝ quotes whether single as here or double (e.g. "⍞ALERT⍞") aren't affected if the replacement
 ⍝ contains quotes, backslashes, etc. This prevents a "backdoor" way of changing a string to code, and so on.
 html←'<!DOCTYPE HTML><meta charset="UTF-8"><html><body><p></p><script>'
 html,←'alert(''⍞ALERT⍞'');</script><p></p></body></html>'   ⍝ ⍞ALERT⍞ replaced by string modified from <msg>

 ∆FMTjs←{⍺←⊢ ⋄ ¯1↓,(⍺ ⎕FMT ⍵),⎕UCS 13}
 ∆UTF8←{⎕UCS'UTF-8'∘⎕UCS ⍵}

 ⍝ For each escapeIn char, replace it with its escapeOt equivalent, which may consist of 0 or more chars.
 ⍝  (⍺⍺ ∆ESC ⍵⍵) ⍵   ←→  (escapeIn ∆ESC escapeOt) string
 ∆ESC←{
     in←⍺⍺ ⋄ ot←⍵⍵
     ∊{ot[in⍳⍵]}@(⍸⍵∊in)⊣⍵
 }
 ⍝ ∆ESCjs: for Javascript string values.  Use \x00 for null to avoid '\0','1' → '\01' which is ⎕UCS 1!
 escapeIn←'\''"',⎕UCS 0 10 13 ⋄ escapeOt←'\\' '\''' '\"' '\n' '\r' '\x00'     ⍝ 0 10 13 = null nl cr
 ∆ESCjs←escapeIn ∆ESC escapeOt

 ⍝ ∆ESChtml: for HTML string values
 ⍝ Not used here-- useful for inserting strings into HTML that should not be interpreted as code.
 ⍝    stringOut ← ∆ESChtml stringIn
 ⍝    in:
 ⍝       This looks like a cmd <P> and 'Is this a string?' No newline \n And & isn't literal &amp;
 ⍝    out:
 ⍝      This looks like a cmd &lt;P&gt; and &#39;Is this a string?&#39; No newline &#92;n And &amp; isn't literal &amp;mp;
 escapeIn←(⎕UCS 0 10 13),'<>"&''\' ⋄ escapeOt←'&#0;' '\n' '\r' '&lt' '&gt' '&quot;' '&amp;' '&#39;' '&#92;'
 ∆ESChtml←escapeIn ∆ESC escapeOt

 :If 0=⎕NC'fmt' ⋄ fmt←⊢ ⋄ :EndIf

 html←∆UTF8'⍞ALERT⍞'⎕R{∆ESCjs fmt ∆FMTjs msg}⊣html

 ⍝ Run alert in own thread at least 30 sec so alert window stays open after fn exit.
 ⍝ Size (0 0): makes extra renderer window invisible
 {'ignored'⎕WC'HTMLRenderer'⍵('Size'(0 0))}&html
