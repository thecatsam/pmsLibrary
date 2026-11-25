∇ ret← {modBits} GmpzExample secretMsg
   ⍝  A nice example of gmpz in operation: RSA encoding of a "secret" message.
   ⍝  To run:
   ⍝    GmpzExample secretMsg
   ⍝  Example:
   ⍝    Gmpz '🐱 This is a cat 🐱'
   ⍝
   ⍝  Choose a secret message (⍵) to encode using a private and public key.
   ⍝  Here everything else is done for you.
   ⍝
   ⍝  You can also change the modBits (⍺) from the default (1024) to (say) 2048 or 4096.
   ⍝  modBits must be even.
   ⍝    2048 Gmpz '🐱 This is a cat 🐱'
   ⍝
   ⍝  Note: The message (in Unicode UTF-8)  must be smaller than the key size (determined by modBits).
   ⍝        Bigger messages are best handled by using a faster method to encode the message, PLUS
   ⍝        RSA for safeguarding that message's encryption key.
      
   ⍝==1 DECLARATIONS AND INITIALIZATION ==================================================================
   ⍝  Declarations, definitions, etc.
        ; Nice; _; ⎕IO; ⎕TRAP                                                 ⍝ Declare helper function / miscellany
        ; GenKeys; Encrypt; Decrypt                                           ⍝ Declare major services
        ; pub; prv; d; e; n                                                   ⍝ Declare the key pairs and elements  
        ; cipher                                                              ⍝ Declare the encrypted msg
        ; decrypted                                                           ⍝ Declare the decrypted msg
      
      ⎕IO← 0 
      ⎕TRAP← 0 'E'  '⎕SIGNAL⊂⎕DMX.( ''EN'' EN ⋄ ''Message'' Message )'
      
   ⍝  Be sure gmpz is loaded...
      :If 0= #.⎕NC 'gmpz'
            #.⎕FIX 'gmpz/gmpz.dyalog'
      :EndIf 
      
   ⍝  Initialise modBits: max # of bits in the modulus.  Must be even.
      :If 900⌶⍬
            modBits← 1024                                                     ⍝ Best practices: modBits∊ 2048 4096
      :EndIf 
      ⎕SIGNAL  (0≠ 2|modBits)/  ⊂('EN' 11 ⋄ 'Message' 'Modulus must be an even number')
      
   ⍝==2 GENERATE PUBLIC AND PRIVATE KEYS ===============================================================--
   ⍝  Initialize random number generator with entropy
   ⍝     (This is the default when RandB is first called)
   ⍝  Generate two distinct probable primes (p and q)
      
   ⍝  pub prv←  GenKeys nBits
   ⍝    Generates keys of nBits bits and returns them.
   ⍝  Each "key" consists of an exponent, e or d, and a modulus n:
   ⍝   public key: (e n), private key: (d n).
      GenKeys← { 
            modBits← ⍵ 
            p q n phi e d← gmpz.New¨ 6⍴0
         ⍝  Create p and q, which will be multiplied to create the public key modulus ¨n¨
            _← p.(NextPrime RandB) modBits÷2                                  ⍝  p...
            _← { 
                  _← q.(NextPrime RandB) ⍵                                    ⍝  q...
                q.Eq p: ∇ ⍵ ⋄ 0
            } modBits÷2 
         ⍝  Compute the  modulus n: n ← p × q, where n.BitLen is approx modBits long.
            _← p n.Mul q 
         ⍝  Compute Euler's totient: phi← (p - 1) × (q - 1)
            _← p.Dec phi.Mul q.Dec                                            ⍝ p is now p-1, q is now q-1
         ⍝  Set public exponent ¨e¨ to 65537 (recommended value).
         ⍝  ¨e¨ is interesting: a prime with bit pattern:  0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
            _← e.Set 65537
         ⍝  Invert: d← e*-1 mod phi
          0=e d.Invert phi:  ⎕SIGNAL ⊂ ('EN' 11 ⋄ 'Message'  'Error: e and phi are not coprime.')
            (e n) (d n)            
      }                                   
      
   ⍝==3 ENCRYPT ====================================================================================--
   ⍝  Encrypt: cipher ← (msg * e) mod n
      Encrypt← { 
            (e n) secretMsg← ⍺  ⍵
            msg cipher← gmpz.New¨ 0 0  
            _← msg.ImportUnicode secretMsg                                    ⍝ Convert from APL Unicode string to gmpz
          msg.BitLen ≥ n.BitLen: ⎕SIGNAL ⊂ ('EN' 11 ⋄ 'Message' 'The message is too big') 
            _← msg cipher.PowM e n
            cipher 
      }  
      
   ⍝==4 DECRYPT ====================================================================================-
   ⍝  Decrypt: decrypted ← (cipher * d) mod n
      Decrypt← {
            (d n) cipher← ⍺ ⍵ 
            decrypted← gmpz.New 0 
            _← cipher decrypted.PowM d n                                      ⍝ Decrypt the key using d and n
            decrypted.ExportUnicode                                           ⍝ decrypted => APL Unicode string
      } 
      
   ⍝==5 Print
      Print← { 
            (e n) (d _)← ⍵  ⋄ CR← ⎕UCS 13 
            ⎕← CR, 'Key Components are displayed in Base 62'                                   
            ⎕← CR, 'Public/Private Key Modulus (n) '  ⋄  ⎕← Nice n.GetInBase 62               
            ⎕← CR, 'Public Key Exponent (e)        '  ⋄  ⎕← Nice e.GetInBase 62               
            ⎕← CR, 'Private Key Exponent (d)       '  ⋄  ⎕← Nice d.GetInBase 62              
            ⎕← CR, 'Encrypted Message              '  ⋄  ⎕← Nice cipher.GetInBase 62         
            ⎕← CR, 'Decrypted Message              '  ⋄  ⎕← Nice decrypted                    
      }
      
   ⍝  Define helper fn Nice: Print long results in nice rows of 64 bytes, with left margin of  4 spaces
   ⍝  Nice:    ∇ str@CV
      Nice← 64 { ⍺← ⍬ ⋄ p← ⍵⍵⍴'' ⋄ ⍺⍺≥ ≢⍵: ↑⍺,⊂p, ⍵ ⋄ (⍺, ⊂p, ⍺⍺↑⍵) ∇ ⍺⍺↓⍵ } 4
      
   ⍝==6 ========================================================================⍝
   ⍝============================================================================⍝
   ⍝============     MAIN:  Generate Keys, Encrypt, and Decrypt      ===========⍝
   ⍝============================================================================⍝
   ⍝============================================================================⍝
   ⍝  pub: The public key in two parts:  the exponent (e) and the modulus (n)
   ⍝  prv: The private key in two parts: the exponent (d) and the same modulus (n)
      pub prv← GenKeys modBits                                                ⍝ pub: e n, prv: d n
      cipher← pub Encrypt secretMsg                                           ⍝ Use the public key to encrypt the msg
      decrypted← prv Decrypt cipher                                           ⍝ Use the private key to decrypt the msg
      
      Print pub prv 
      
   ⍝==7 Verify correctness
      :If decrypted ≡ secretMsg 
            ret← '🙂🙂🙂 Success: Decrypted message matches original'
      :Else
            ret← '😖😖😖 Failure: Decrypted message does not match original'
      :EndIf
      
   ⍝⍝==7 === CLEAN UP / FREE MEMORY ===================================== ⍝
   ⍝⍝                                                                     ⍝
   ⍝⍝                     THERE'S NOTHING TO DO!                          ⍝
   ⍝⍝                     gmpz DOES IT ALL FOR YOU                        ⍝
   ⍝⍝                                                                     ⍝
   ⍝⍝ ==================================================================- ⍝
   ⍝
   ⍝
   ⍝
      
