:Namespace              ⍝ Unnamed NS.  Won't clutter destination ns.                 
⍝ ∆F Utility and Library Loader (Dyalog ≥20 Version!).
⍝ Does minimal loading; makes globals available to FString, which does rest of loading.
⍝ Load gFi
⍝ - gFi: a file with global variables: '∆F/∆FGlobals.aplns' ==> g (a local namespace)
⍝ - From g, gets name of the source for ∆F and its library,  g.SRC_FI (typically FString.dyalog) 
⍝   as FString  
⍝ - From g, gets name of the "library £" file libSrc
⍝ - Creates temporary namespace ⎕SE.⍙FShare to share the globals and the contents of <libSrc>
⍝   establishes function ∆F in the dest ns.
⍝ - Establishes FString
⍝ THen FString, in turn, 
⍝ - establishes FString.libUtils
⍝ - loads other items needed based on the global variables passed.
⍝ --------------
⍝ To use: 
⍝     ]load ∆F [-target=⎕SE]     or     ⊢⎕SE.⎕FIX '∆F.dyalog'
⍝ ---------------------------------------------

∇ {ok}← Load gFi 
  ;dest ;g ; lib; main  
  ⎕IO ⎕ML← 0 1 
  dest← ⎕THIS.##                                        ⍝ The <main> ns goes to our parent, not us
  :Trap 0
      g← 0 ⎕FIX  gFi                                    ⍝ Load globals from file into namespace <g>
    ⍝ Make sure key source files exist (if not: set to '')
       main lib← { 
        ~⎕NEXISTS ⍵: ⎕SIGNAL ⊂('EN' 22)('Message',⍥⊂'No such file or directory: "',⍵,'"') 
        ⊃⎕NGET ⍵ 1
      }¨ g.( SRC_FI LIB_SRC_FI ) 
    ⍝ If the argument cache is disabled, remove associated code from scanFStr
      :If ~g.ARG_CACHE_ENABLED
            main← '^.*⍝::ARG_CACHE.*$' ⎕R ''⊣ main
      :EndIf
      :If ~g.KEEP_SRC_CM                                ⍝ Remove comments?  (except ⍝!)
          main lib← { 
            in out← ↓⍉↑( 
              '''[^'']*'''  '&' ⋄ '\h*⍝(?!\!).*'  '' ⋄ '^\h*$'  '' 
            )
            t/⍨ 0≠≢¨t← in ⎕R out⊢ ⍵  
          }¨ main lib 
      :EndIf 
    ⍝ Share globals and lib with <main> as it is fixed...
      ⎕SE.∆F⍙Share← (globals: g ⋄ library: lib)         ⍝ lib ⎕FIXed in FString...
      dest.⎕FIX ⍠ 'FixWithErrors' 0⊣ main               ⍝ ⎕FIX main in <dest>
      ⎕DF (⍕dest),'.FString [',g.VERSION,']'            ⍝ Report ∆F info via ⎕DF
  :Else                                                     
      ⎕DF ∊⎕DMX.(                                       ⍝ Report error via ⎕DF
        '❗❗❗ ERROR LOADING ∆F: ', EM, ': ', Message 
      )  
  :EndTrap 
⍝ Unshare globals (on success or failure)
  ok← ⎕EX '⎕SE.∆F⍙Share'                                
∇
  Load '∆F/Globals.aplns'
            
:EndNamespace ⍝ Unnamed
