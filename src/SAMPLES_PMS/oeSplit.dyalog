 oeSplit←{
⍝        r ← oeSplit ⍵
⍝        ⍵: list* of vector (or scalar) objects (typically strings)
⍝        r: (odd even)
⍝            odd:  a list* of those objects odd in length (per tally)
⍝            even: a list* of those objects even in length (per tally)
⍝ ---------------
⍝        * Possibly a list of length 0.
⍝  Note: Each item may be a char vector, but need not be.
⍝        To ensure each is a vector, replace rightmost ⍵ with ,¨⍵ in line [12] below.

⍝[4] 3   2              1  a
     1↓¨(1 0,2|≢¨⍵){⊂⍵}⌸'' '',,¨⍵

⍝                     1.  To ensure at least one even and one odd, we prepend (a) dummy  entries
⍝        2. Pass on to key fn, indicating dummy odd and even entries before actuals
⍝    3. Remove dummy keys from start of each of 2 vectors
⍝ 4. Returns two lists (2 vectors of objects)
 }
