GetUrl←{
    ⍝ Retrieve URL ⍵ (assumes default 'https://' prefix if prefix is omitted)
    ⍝ and remove all html and scripts...

    crlf←⎕UCS 13 10
    pats repl←↓⍉↑(
        '<script[^>]*>.*?</script[^>]*>' ''
         '<[^>]+>' ''
         '&amp;' '&'
         '&lt;' '<'
         '&gt;' '>'
         '&quot;' '"'
         '&nbsp;' ' '
    )
    _Opts←⍠('Mode' 'M')('DotAll' 1)

    Pfx←{⍵,⍨'https://'/⍨~1∊'://'⍷⍵}
    GetURL←{((⎕SE.SALT.Load'HttpCommand').Get ⍵).Data}
    Repl←pats ⎕R repl _Opts
    Split←crlf∘((~∊⍨)⊆⊢)
    NoDup←'(\R\h*$)+'⎕R'\n'_Opts

    NoDup Split Repl GetURL Pfx ⍵
}
