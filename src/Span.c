#include <stdint.h>

/*

  cd MyD*\/pmsL*\/src 
  cc -dynamiclib -target arm64-apple-macos -o Span.dylib Span.c

Test←{
    _←⎕CMD'cc -dynamiclib -target arm64-apple-macos -o Span.dylib Span.c'
    o1←'⍙Span'⎕NA'U4 Span.dylib|Span  <0C4[] I4 <0C4[] I4'
    o2←'⍙Break'⎕NA'U4 Span.dylib|Break <0C4[] I4 <0C4[] I4'
    Span∘←  { ⍙Span  ⍺ (≢⍺) ⍵ (≢⍵)}
    Break∘← { ⍙Break ⍺ (≢⍺) ⍵ (≢⍵)}
    'Created: ',o1 o2
  }
*/

uint32_t Span( 
  uint32_t *str, int sLen, uint32_t *pat, int pLen
) {
  int i, j, found; 
  found = 0; 
  
  for (i=0; i< sLen; ++i) {
        for (found=0, j=0; j< pLen && !found ; ++j) {
            found = (str[i] == pat[j]); 
        }
        if (!found)
           return i;
  }
  return i; 
}

uint64_t Break(  
  uint32_t *str, int sLen, uint32_t *pat, int pLen
){
  int i, j;
  for (i=0; i< sLen; ++i) {
        for (j=0; j< pLen; ++j) {
            if (str[i] == pat[j]) 
                return i;
        }
  }
  return i; 
}