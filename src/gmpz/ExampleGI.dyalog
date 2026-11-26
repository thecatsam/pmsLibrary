:Namespace    ⍝ Anonymous and Temporary 

DHExample←{
   ⍝ DHExample — Diffie-Hellman key exchange, then encrypt/decrypt, all with GI.
⍝ Requires gmpz loaded, and the GI with ⍴ (next/prev/current prime).
⍝ Load:  ]load DHExample.dyalog
⍝ Run:   DHExample 'Hello, Diffie-Hellman!'
⍝ ⍵ is an ASCII message string. Returns 1 if the decrypted message matches.
⍝
⍝ Public parameters are fixed and shared; only the private secrets are random.
⍝ p is the smallest prime above 2^127 (a 127-bit prime); g is 2.
⍝ Production DH wants a safe prime and a verified generator — this is a demo.
⍝ The cipher is a one-time-pad-style addition of the shared secret:
⍝ it shows the exchange working; it is not a production cipher.
⍝ ○GI forms: ○GI b is the next prime after b; ¯1 ○GI b the previous prime;
⍝ 0 ○GI b the current prime.
    ⎕IO←0
    p←○GI (2*GI 127)   ⍝ public prime
    g←2                ⍝ public generator

    GenerateKeys←{      ⍝ ⍵: private-key bits → (private public)
        a← >GI (?GI -⍵)
        a,(g *∘|GI (a p))
    }

    Encrypt←{           ⍝ ⍺: shared secret; ⍵: message (APL char vec => UTF-8 => gmpz)
        ⍺+GI  ⎕UCS GI  ⍵      ⍝ ⎕UCS GI takes (in this case) a char vec and returns a gmpz integer!
    }

    Decrypt←{           ⍝ ⍺: shared secret; ⍵: ciphertext => UTF-8 => char vec 
        ⎕UCS GI ⍵-GI ⍺  ⍝ ⎕UCS GI takes (in this case) a gmpz and returns a char vec!
    }

    (aA A)←GenerateKeys 127
    (aB B)←GenerateKeys 127
    sA←B *∘|GI aA p   ⍝ Alice: B*aA mod p
    sB←A *∘|GI aB p   ⍝ Bob:   A*aB mod p

    ⎕←'Prime (p):        ',⊥GI p
    ⎕←'Alice public (A): ',⊥GI A
    ⎕←'Bob public (B):   ',⊥GI B
    ⎕←'Shared secret:    ',⊥GI sA
    ⎕←'Secrets match:    ',⍕sA=GI sB

    c←sA Encrypt ⍵      ⍝ Alice encrypts with her secret
    m←sB Decrypt c      ⍝ Bob decrypts with his secret
    ⎕←'Ciphertext:       ',⊥GI c
    ⎕←'Decrypted:        ',m
    ok←m≡⍵
    ⎕←ok⊃'🙁 Decrypted message does NOT match original' '🙂🙂🙂 Success: Decrypted message matches original'
    ok
}

⎕DF ##.⎕FX ⎕NR 'DHExample'

:EndNamespace 
