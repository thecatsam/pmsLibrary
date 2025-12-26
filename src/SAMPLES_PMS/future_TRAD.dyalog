 fut←{alphaø}(userFnø future_TRAD)omegaø;futNs;iEvaluate
⍝ Create a simple future in the host workspace...
⍝ Minimal future magic from the isolate/yyns source code...
⍝ We don't adjust ⎕IO etc...
⍝ To execute things in the caller namespace, use
⍝    (⊃⎕RSI), ##, etc.

 futNs←(⊃⎕RSI).⎕NS''           ⍝ Create NS in the caller's space
 futNs.iSyntax←futNs.{2 0}     ⍝ Copy in magical iSyntax: variable, no args

⍝ Prepare left (poss. undefined) and right arguments.
 :If (900⌶)0 ⋄ futNs.alphaø←⊢ ⋄ :Else ⋄ futNs.alphaø←alphaø ⋄ :EndIf
 futNs.omegaø←omegaø

 ⍝ Copy in userFnø from dfn or tradfn.
 futNs.userFnø←userFnø

⍝ iEvaluate automagically called by ibeam 700⌶.
⍝ We have iEvaluate call operator userFnø,
⍝ passing in ⍺ (if present) and ⍵ via surrogates futNs.alphaø and futNs.omegaø.
 futNs.iEvaluate←futNs.{⊢alphaø userFnø omegaø}

⍝ Issue magical incantation for "futures"
 {}1(700⌶)futNs    ⍝ Magic ⌶beam 700
 fut←futNs.⎕DF     ⍝ Magic use of ⎕DF, returns "future"
