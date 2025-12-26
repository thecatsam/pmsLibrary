<br>

<div class="right-margin-bar">

<pNote><br>Short for “**format­ted string lit­er­als**, *f‑strings* were
introduced in Python in 2016. **∆F** *f‑strings* and Python’s are
**not** compatible.</pNote>

<div class="marquee">

***∆F*** is a function for *Dyalog* APL that interprets *f‑strings*, a
concise, yet powerful way to display multiline APL text, arbitrary APL
expressions, and multi­dimensional objects using extensions to *dfns* and
other familiar tools.

</div>

# Table of Contents

<details id="TOC">

<!-- option: open  Set id="TOC" here only. -->

<pSum> Show/Hide <em>Table of Contents</em></pSum>

<div class="multi-column-text" style="font-size:80%;">

<pT0x>1. <a href="#installing-loading-and-running-f"  >Installing,
Loading, and Running **∆F**</a></pT0> <pT1/>1.1
<a href="#installing-f"                 >Installing **∆F**</a> <pT1/>1.2
<a href="#loading-and-running-f"        >Loading and Running **∆F**</a>
<pT1/>1.3 <a href="#displaying-f-help-in-apl"     >Displaying **∆F**
**Help** in APL</a> <pT0 >2.
<a href="#overview"                          >Overview</a></pT0>
<pT0 >3. <a href="#f-examples-a-primer"           >**∆F** Examples: A
Primer</a></pT0> <pT1/>3.1
<a href="#code-fields"                 >**Code** Fields</a> <pT1/>3.2
<a href="#text-fields-and-space-fields">**Text** Fields and **Space**
Fields</a> <pT1/>3.3 <a href="#null-space-fields"           >Null
**Space** Fields</a> <pT1/>3.4
<a href="#code-fields-continued"       >**Code** Fields (Continued)</a>
<pT1/>3.5 <a href="#the-box-shortcut"            >The **Box**
Short­cut</a> <pT1/>3.6 <a href="#box-mode"                    >**Box**
Mode</a> <pT1/>3.7 <a href="#omega-shortcuts-explicit"    >**Omega**
Short­cuts (Explicit)</a> <pT1/>3.8
<a href="#referencing-the-fstring-itself"  >Referencing the F‑string
Itself</a> <pT1/>3.9 <a href="#the-format-shortcut"         >The
**Format** Short­cut</a> <pT1/>3.10
<a href="#the-shortcut-for-numeric-commas" >The Short­cut for Numeric
**Commas**</a> <pT1/>3.11
<a href="#self-documenting-code-fields-sdcfs">Self-documenting **Code**
fields (SDCFs)</a> <pT1/>3.12
<a href="#the-above-shortcut"          >The **Above** Short­cut</a>
<pT1/>3.13 <a href="#text-justification-shortcut" >Text
**Justification** Short­cut</a> <pT1/>3.14
<a href="#omega-shortcuts-implicit"    >**Omega** Short­cuts
(Implicit)</a> <pTbr> <pT1/>3.15
<a href="#shortcuts-with-apl-expressions"  >Short­cuts With *APL*
Expressions</a> <pT1/>3.16
<a href="#a-shortcut-for-dates-and-times-part-i"  >A Short­cut for Dates
and **Times** (Part I)</a> <pT1/>3.17
<a href="#a-shortcut-for-dates-and-times-part-ii" >A Short­cut for
**Dates** and Times (Part II)</a> <pT1/>3.18
<a href="#the-quote-shortcut"             >The **Quote** Short­cut</a>
<pT1/>3.19 <a href="#the-wrap-shortcut-experimental" >The **Wrap**
Short­cut (Experimental)“</a> <pT1/>3.20
<a href="#the-session-library-shortcut-experimental" >The Session
**Library** Short­cut (Experimental)</a> <pT1/>3.21
<a href="#precomputed-fstrings-with-the-dfn-option" >Precomputed
f‑strings with the ***dfn*** Option</a> <pT0 >4.
<a href="#f-syntax-and-other-information"   >**∆F** Syntax and Other
Infor­mation</a></pT0> <pT1/>4.1
<a href="#f-call-syntax-overview"         >**∆F** Call Syntax
Overview</a> <pT1/>4.2 <a href="#f-option-details"               >**∆F**
Option Details</a> <pT1/>4.3
<a href="#f-return-value"                 >**∆F** Return Value</a>
<pT1/>4.4 <a href="#f-fstring-building-blocks"      >**∆F** F‑string
Build­ing Blocks</a> <pT1/>4.5
<a href="#code-field-shortcuts"           >**Code** Field Short­cuts</a>
<pT1/>4.6 <a href="#escape-sequences-text-fields-quoted-strings" >Escape
Sequences: **Text** Fields & Quoted Strings</a> <pT1/>4.7
<a href="#quoted-strings-in-code-fields"  >Quoted Strings in **Code**
Fields</a> <pT1/>4.8
<a href="#omega-shortcut-expressions-details" >**Omega** Short­cut
Expressions: Details</a> <pT1/>4.9
<a href="#wrap-shortcut-details"          >**Wrap** Short­cut:
Details</a> <pT1/>4.10
<a href="#session-library-shortcut-details" >Session **Library**
Short­cut: Details</a> <pT0 >5.
<a href="#appendices">Appendices</a></pT0> <pT1/>5.1
<a href="#appendix-i-underdocumented-features" >Appendix I:
Un(der)doc­ument­ed Features</a> <pT1/>5.2
<a href="#appendix-ii-python-fstrings"         >Appendix II: Python
f‑strings</a>

</div>

------------------------------------------------------------------------

</details>

# Installing, Loading, and Running **∆F**

<details>

<!-- option: open -->

<pSum> Show/Hide <em>Installing, Loading, and Running
<bold>∆F</bold></em> </pSum>

## Installing **∆F**

1.  On Github, search for <mark>“f‑string-apl”</mark>.
    - During the test phase, go to
      <mark><pLink>https://github.com/petermsiegel/f-string-apl.git</pLink></mark>.
2.  Make a note of <pNote>User command `]cd` will show you your current
    working directory.</pNote>your current directory.
3.  Copy the file **∆F.dyalog** and directory **∆F** (which contains
    several files) into the current working directory, ensuring they are
    peers.<pNote>**peers:** *i.e.* at the same level.</pNote>

&RHAND; Now, **∆F** is available to load and use. Continue in the [next
section](#loading-and-running-f).

## Loading and Running **∆F**

1.  Confirm that your current directory remains as before.
2.  From your Dyalog session<pNote><br>***⎕SE:*** Or any *target*
    namespace you desire.</pNote>, enter: <br> `]load ∆F [-target=⎕SE]`
3.  **∆F/∆F_Help.html** is, by default, available at `]load` time and
    will be copied into **⍙Fapl**. If missing, a message will note the
    absence of *help* information.
4.  Namespace <code>*⎕SE*.**⍙Fapl**</code> now contains utilities used
    by **∆F** and, once `]load`ed, ***should not*** be moved: **∆F**
    always refers to **⍙Fapl** in its *original* location.
5.  By default, the target namespace (<code>*⎕SE*</code>) will be added
    to the end of `⎕PATH`, if not already defined in ⎕PATH. You may
    always choose to relocate or assign **∆F** anywhere you want so that
    it is available.

&RHAND; You may now call `∆F` with the desired
[arguments](#f-call-syntax-overview) and
[options](#f-option-details).<br> &RHAND; **∆F** is `⎕IO`- and
`⎕ML`-independent.

## Displaying ∆F **Help** in APL

<pNote>If `∆F⍨'help'` seems exotic, try: `'help' ∆F ⍬`.</pNote> &RHAND;
To display this **HELP** information, type: `∆F⍨ 'help'`.

------------------------------------------------------------------------

</details>

# Overview

<details open>

<pSum> Show/Hide <em>Overview</em></pSum>

Inspired by [Python f‑strings](#appendix-ii-python-fstrings), **∆F**
includes a variety of capabilities to make it easy to evaluate, format,
annotate, and display related multi­dimensional information. A **∆F**
*f-string* <pNote>For *f-string* formats, see [**∆F** Call Syn­tax
Over­view](#f-call-syntax-overview).</pNote> is a character vector
(typically) which may reference objects in the environment, additional
function arguments, or both.

**∆F** *f‑strings* include:

- The abstraction of 2-dimensional character ***fields***, generated
  one-by-one from the user’s specifications and data, then aligned and
  catenated into a single overall character matrix result;

<pNote>`` `◇ ``: back­tick + state­ment sep­ar­ator (`⎕UCS 96 8900`).
</pNote>

- **Text** fields, each allowing [multiline Unicode
  text](#text-fields-and-space-fields), with the sequence `` `◇ ``
  generating a new line;

- **Code** fields, allowing users to evaluate and display APL arrays of
  any dimensionality, depth and type in the user environment, arrays
  passed as **∆F** arguments, as well as arbitrary APL expressions based
  on full multi-statement dfn logic. Each **Code** field must return a
  value, simple or otherwise, which will be catenated with other fields
  and returned from **∆F**;

  **Code** fields also provide a number of concise, convenient
  extensions, such as:

  - **Quoted strings** <pNote>Quoted strings, like **Text** fields,
    allow easy entry of newlines via the sequence `` `◇ ``.</pNote> in
    **Code** fields, with several quote styles:

    - **double-quotes**<br> `∆F '{"like this"}'` or
      `` ∆F '{"on`◇""three""`◇lines"} ``
    - **double angle quotation marks**,<pNote>Also known as
      *guillemets*, <big>**«**</big> and <big>**»**</big> are Unicode
      chars `⎕UCS 171 187`.</pNote><br>
      `∆F '{«with internal quotes like "this" or ''this''»}'`,<br> *not
      to mention:*
    - APL’s tried-and-true embedded **single-quotes**,<br>
      `∆F '{''shown ''''right'''' here''}'`

  - Simple shortcuts<pNote>Details on all the
    [shortcuts](#code-field-shortcuts) are provided later in this
    document.</pNote> for

    - **format**ting numeric arrays, **\$** (short for
      **⎕FMT**):<br>`∆F '{"F7.5" $ ?0 0}'`
    - putting a **box** around a specific expression,
      **\`B**:<br>`` ∆F'{`B ⍳2 2}' ``
    - placing the output of one expression **above** another,
      **%**:<br>`∆F'{"Pi"% ○1}'`
    - formatting **date** and **time** expressions from APL timestamps
      (**⎕TS**) using **\`T**<pNote>`` `T `` combines **1200⌶** and
      **⎕DT**</pNote>:<br>`` ∆F'{"hh:mm:ss" `T ⎕TS}' ``
    - *and more*;

  - Simple mechanisms for concisely formatting and displaying data from

    - user arrays of any shape and
      dimensionality:<br>`tempC← 10 110 40 ◇ ∆F'{tempC}'`, <br>
    - arbitrary *dfn*-style
      code:<br>`'dec' 'hex'⎕CY 'dfns'`<br>`∆F '{ 223423 ≡⊃dec hex 223423: "Checks out" ◇ "Bad"}'`
      <br>
    - arguments to **∆F** that follow the format
      string:<br>`` ∆F'{32+`⍵1×9÷5}' (10 110 40) ``<pNote>`` `⍵1 ``:
      shortcut for `(⍵⊃⍨1+⎕IO)`
    - *and more*;

- **Space** fields, providing a simple mechanism both for separating
  adjacent **Text** fields and inserting (rectangular) blocks of any
  number of spaces between any two fields, where needed;

  - one space: `{ }`; five spaces: `{     }`; or even, zero spaces:
    `{}`;
  - 1000 spaces? Use a **Code** field instead: `{1000⍴""}`.

- Use of <pNote>These options are equi­valent:<br>∘ `0 1 1` <br>∘
  `(verbose: 1 ◇ box: 1)`</pNote> *either* [**positional** or
  **namespace**-style options](#f-option-details), based on *Apl* Array
  Notation (in­tro­duced in Dyalog 20);

- Multiline (matrix) output built up field-by-field, left-to-right, from
  values and expressions in the calling environment or arguments to
  **∆F**;

  - After all fields are generated, they are aligned vertically, then
    concatenated to form a single character matrix: ***the return value
    from*** **∆F**. <pNote><br>As a prototype, **∆F** is relatively
    slow, using an APL recursive scan to analyze the **f‑string**. For a
    way to speed up frequently used *f‑strings*, see the [***dfn***
    option](#f-option-details).</pNote>

**∆F** is designed for ease of use, *ad hoc* debugging, fine-grained
formatting and informal user interaction, built using Dyalog functions
and operators.

<details>

<!-- option: open -->

<pSum> Recap: <em>The Three Field Types</em></pSum>

| Field Type | <br> Syntax | <br> Examples | <br> Displaying |
|:--:|:--:|:--:|:--:|
| **Text** | *Unicode text* | `` Cats`◇and`◇dogs! `` | 2-D Text |
| **Code** | `{`*dfn code plus*`}` `{`*shortcuts*`}` | `{↑"one" "two"}`<br> `{"F5.1" $ (32+9×÷∘5)degC}` | Arbitrary APL Expressions <br>via dfns |
| **Space** | `{`<big>␠ ␠ ␠</big>`}` | `{  }`   `{}` | Spacing & Field Separation |

2a. <strong>The Three Field Types</strong>

<br>
</details>

</details>

# ∆F Examples: A Primer

<details>

<!-- option: open -->

<pSum> Show/Hide <em>Examples: A Primer</em> </pSum>

Before providing information on **∆F** syntax and other details, *let’s
start with some examples*…

First, let’s set some context for the examples. (You can set these
however you want.)

<pNote>All examples in this document assume `⎕IO←0 ◇ ⎕ML←1`.</pNote>

       ⎕IO ⎕ML← 0 1

## Code Fields

Here are **Code** fields with simple variables.

<pNote>So far, this is like everybody else’s *f‑strings*. </pNote>

       name← 'Fred' ◇ age← 43
       ∆F 'The patient''s name is {name}. {name} is {age} years old.'
    The patient's name is Fred. Fred is 43 years old.

**Code** fields can contain arbitrary expressions. With default options,
**∆F** always returns a single character matrix. Here **∆F** returns a
matrix with 2 rows and 32 columns.

<pNote> Now we’re taking advantage of APL’s array-oriented style.
</pNote>

       tempC← ⍪35 85
       ⍴⎕← ∆F 'The temperature is {tempC}{2 2⍴"°C"} or {32+tempC×9÷5}{2 2⍴"°F"}'
    The temperature is 35°C or  95°F.
                       85°C    185°F
    2 32

Here, we assign the *f‑string* to an APL variable, then call **∆F**
twice!

<pNote>Setting `⎕RL` ensures our random numbers aren’t random! </pNote>

       ⎕RL← 2342342
       n← ≢names← 'Mary' 'Jack' 'Tony'
       prize← 1000
       f← 'Customer {names⊃⍨ ?n} wins £{?prize}!'
       ∆F f
    Customer Jack wins £80!
       ∆F f
    Customer Jack wins £230!

Isn’t Jack lucky, winning twice in a row!

<details id="pPeek">

<pSum> View a fancier example…</pSum>

<pNote>[See a different method](#winner2) using the **Wrap** shortcut.
</pNote>

<div id="winner1">

     ⍝ Be sure everyone wins something.
       n← ≢names← 'Mary' 'Jack' 'Tony'
       prize← 1000
       ∆F '{ ↑names }{ ⍪n⍴ ⊂"wins" }{ "£", ⍕⍪?n⍴ prize}'
    Mary wins £711
    Jack wins £298
    Tony wins £242

</div>

</details>

## Text Fields and Space Fields

Below, we have some multi-line **Text** fields separated by non-null
**Space** fields.

- The backtick is our “escape” character.
- The sequence \`◇ generates a new line in the current **Text** field.
- Each **Space** field `{ }` in the next example contains one space
  within its braces. It produces a matrix a *single* space wide with as
  many rows as required to catenate it with adjacent fields.

A **Space** field is useful here because each multi-line field is built
in its own rectangular space.

       ∆F 'This`◇is`◇an`◇example{ }Of`◇multi-line{ }Text`◇Fields'
    This    Of         Text
    is      multi-line Fields
    an
    example

## Null Space Fields

Two adjacent **Text** fields can be separated by a null **Space** field
`{}`, for example when at least one field contains multiline input that
you want formatted separately from others, keeping each field in is own
rectangular space:

    ⍝  Extra space here ↓
       ∆F 'Cat`◇Elephant `◇Mouse{}Felix`◇Dumbo`◇Mickey'
    Cat      Felix
    Elephant Dumbo
    Mouse    Mickey

In the above example, we added an extra space after the longest animal
name, *Elephant*, so it wouldn’t run into the next word, *Dumbo*.

**But wait! There’s an easier way!**

Here, you surely want the lefthand field to be guaranteed to have a
space after *each* word without fiddling; a **Space** field with at
least one space will solve the problem:

    ⍝                          ↓↓↓
       ∆F 'Cat`◇Elephant`◇Mouse{ }Felix`◇Dumbo`◇Mickey'
    Cat      Felix
    Elephant Dumbo
    Mouse    Mickey

## Code Fields (Continued)

<pNote>We could have used a **Space** field `{ }` here as well.</pNote>
And this is the same example with *identical* output, but built using
two **Code** fields separated by a **Text** field with a single space.

<pNote>APL mix `↑` is used to convert the names (a vector of character
vectors) to a character matrix. </pNote>

       ∆F '{↑"Cat" "Elephant" "Mouse"} {↑"Felix" "Dumbo" "Mickey"}'
    Cat      Felix
    Elephant Dumbo
    Mouse    Mickey

Here’s a similar example with double quote-delimited strings in **Code**
fields with the newline sequence, `` `◇ ``:

       ∆F '{"This`◇is`◇an`◇example"} {"Of`◇Multi-line"} {"Strings`◇in`◇Code`◇Fields"}'
    This    Of         Strings
    is      Multi-line in
    an                 Code
    example            Fields

Here is some multiline data we’ll add to our **Code** fields.

<pNote><br><br><br><br><br>Again, we use APL *mix* `↑` to generate
multiline objects (matrices).</pNote>

       fNm←  'John' 'Mary' 'Ted'
       lNm←  'Smith' 'Jones' 'Templeton'
       addr← '24 Mulberry Ln' '22 Smith St' '12 High St'

       ∆F '{↑fNm} {↑lNm} {↑addr}'
    John Smith     24 Mulberry Ln
    Mary Jones     22 Smith St
    Ted  Templeton 12 High St

<pNote>We could have used `0⍕⍪` and `1⍕⍪` here, of course. But we wanted
to remind you what Dyalog’s `⎕FMT` can do. For more, see
[below](#the-format-shortcut). </pNote>

Here’s a slightly more interesting code expression, using `$` (a
shortcut for `⎕FMT`) to round Centigrade numbers to the nearest whole
degree and Fahrenheit numbers to the nearest tenth of a degree.

       cv← 11.3 29.55 59.99
       ∆F 'The temperature is {"I2" $ cv}°C or {"F5.1"$ 32+9×cv÷5}°F'
    The temperature is 11°C or  52.3°F
                       30       85.2
                       60      140.0

## The Box Shortcut

We now introduce the **Box** shortcut `` `B ``. Here we place boxes
around key **Code** fields in this same example.

       cv← 11.3 29.55 59.99
       ∆F '`◇The temperature is {`B "I2" $ cv}`◇°C or {`B "F5.1" $ 32+9×cv÷5}`◇°F'
                       ┌──┐      ┌─────┐
    The temperature is │11│°C or │ 52.3│°F
                       │30│      │ 85.2│
                       │60│      │140.0│
                       └──┘      └─────┘

## Box Mode

But what if you want to place a box around every **Code**, **Text**,
***and*** **Space** field? We just use the **box** mode option!

While we can’t place boxes around text (or space) fields using `` `B ``,
we can place a box around ***each*** field (*regardless* of type) by
setting **∆F**’s [**box** mode](#f-option-details) option, <pNote>**box
mode:** `0 0 1` *or* `(box: 1)`</pNote>to `1`:

       cv← 11.3 29.55 59.99
           ↓¯¯¯ box mode,  or:  (box: 1)
       0 0 1 ∆F '`◇The temperature is {"I2" $ cv}`◇°C or {"F5.1" $ 32+9×cv÷5}`◇°F'
    ┌───────────────────┬──┬──────┬─────┬──┐
    │                   │11│      │ 52.3│  │
    │The temperature is │30│°C or │ 85.2│°F│
    │                   │60│      │140.0│  │
    └───────────────────┴──┴──────┴─────┴──┘

We said you could place a box around every field, but there’s an
exception. Null **Space** fields `{}`, *i.e.* 0-width **Space** fields,
are discarded once they’ve done their work of separating adjacent fields
(typically **Text** fields), so they won’t be placed in boxes.

Try this expression on your own:

    ⍝ (box: 1) ∆F 'abc...mno' in Dyalog 20.
       0 0 1   ∆F 'abc{}def{}{}ghi{""}jkl{ }mno'

<details id="pPeek">

<pSum> Peek at answer</pSum>

       0 0 1 ∆F 'abc{}def{}{}ghi{""}jkl{ }mno'
    ┌───┬───┬───┬┬───┬─┬───┐
    │abc│def│ghi││jkl│ │mno│
    └───┴───┴───┴┴───┴─┴───┘

</details>

In contrast, **Code** fields that return null values (like `{""}` above)
*will* be displayed!

## Omega Shortcuts (Explicit)

> Referencing **∆F** arguments after the *f‑string*: **Omega** shortcut
> expressions (like `` `⍵1 ``).

The expression <pNote>And `(⍵⊃⍨ 1+⎕IO)` is, of course, equivalent to
`((1+⎕IO)⊃⍵)`. </pNote> `` `⍵1 `` is equivalent to `(⍵⊃⍨ 1+⎕IO)`,
selecting the first argument after the *f‑string*. Similarly, `` `⍵99 ``
would select `(⍵⊃⍨99+⎕IO)`.

We will use `` `⍵1 `` here, both with shortcuts and an externally
defined function `C2F`, that converts Centigrade to Fahrenheit. A bit
further [below](#omega-shortcuts-implicit), we discuss bare `` `⍵ ``
(*i.e.* without an appended non-negative integer).

       C2F← 32+9×÷∘5
       ∆F 'The temperature is {"I2" $ `⍵1}°C or {"F5.1" $ C2F `⍵1}°F' (11 15 20)
    The temperature is 11°C or 51.8°F
                       15      59.0
                       20      68.0

## Referencing the f‑string Itself

<pNote> `` `⍵0 `` refers to the *f‑string* independent of the the number
of elements in the right argument to **∆F** (*effectively*, `⊆⍵`).
</pNote> The expression `` `⍵0 `` always refers to the *f‑string*
itself. Try this yourself.

       bL bR← '«»'                     ⍝ ⎕UCS 171 187
       ∆F 'Our string {bL, `⍵0, bR} has {≢`⍵0} characters.'

<details id="pPeek">

<pSum> Peek at answer</pSum>

       bL bR← '«»'                     ⍝ ⎕UCS 171 187
       ∆F 'Our string {bL, `⍵0, bR} has {≢`⍵0} characters.'
    Our string «Our string {bL, `⍵0, bR} has {≢`⍵0} characters» has 47 characters.

<details id="pPeek">

<pSum> Let’s check our work…</pSum>

       ≢'Our string {bL, `⍵0, bR} has {≢`⍵0} characters.'
    47

</details>

</details>

## The Format Shortcut

<pNote>The **Format** shortcut `$`, or `` `F `` (short for `⎕FMT`), can
also be used monadically, but let **∆F** handle that for you in most
cases. </pNote>

> Let’s add commas to some very large numbers using the **⎕FMT**
> shortcut `$`.

We can use Dyalog’s built-in formatting specifier “C” with shortcut `$`
to add appropriate commas to the temperatures!

<pNote><br><br>`C2F← 32+9×÷∘5`</pNote>

    ⍝  The temperature of the sun at its core in degrees C.
       sun_core← 15E6                   ⍝ 15000000 is a bit hard to parse!
       ∆F 'The sun''s core is at {"CI10" $ sun_core}°C or {"CI10" $ C2F sun_core}°F'
    The sun's core is at 15,000,000°C or 27,000,032°F

## The Shortcut for Numeric Commas

<pNote>Typically, each number or numeric string presented to `` `C ``
will represent an integer, but if a real number is presented, only the
integer part will have commas added. </pNote> The shortcut for *Numeric*
**Commas** `` `C `` adds commas every 3 digits (from the right) to one
or more numbers or numeric strings.It has an advantage over the `$`
(Dyalog’s `⎕FMT`) specifier: it doesn’t require you to guesstimate field
widths.

Let’s use the `` `C `` shortcut to add the commas to the temperatures!

<pNote><br>Cool! OK, not literally. </pNote>

       sun_core← 15E6               ⍝ 15000000 is a bit hard to parse!
       ∆F 'The sun''s core is at {`C sun_core}°C or {`C C2F sun_core}°F.'
    The sun's core is at 15,000,000°C or 27,000,032°F.

And for a bit of a twist, let’s display either degrees Centigrade or
Fahrenheit under user control (`1` =\> F, `0` =\> C). Here, we establish
the *f‑string* `sunFC` first, then pass it to **∆F** with an additional
right argument.

       sunFC← 'The sun''s core is at {`C C2F⍣`⍵1⊢ sun_core}°{ `⍵1⊃ "CF"}.'
       ∆F sunFC 1
    The sun's core is at 27,000,032°F.
       ∆F sunFC 0
    The sun's core is at 15,000,000°C.

Now, let’s move on to Self-documenting **Code** fields.

## Self-documenting **Code** fields (SDCFs)

<pNote>Our SDCFs are based on Python’s single type of self-documenting
expressions in *f‑strings*, but work somewhat differently. SDCFs are
used ***only*** in **Code** fields *(duh).* </pNote>

> Self-documenting Code fields (SDCFs) are a useful debugging tool.

What’s an SDCF? An SDCF allows whatever source code is in a **Code**
field to be automatically displayed literally along with the result of
evaluating that code.

The source code for a **Code** field can automatically be shown in
**∆F**’s output—

- to the *left* of the result of evaluating that code; or,
- centered *above* the result of evaluating that code.

All you need do is enter

- a right arrow <big>`→`</big> for a **horizontal** SDCF, or
- a down arrow <big>`↓`</big> (or <big>`%`</big>)<pNote>`%` is the same
  glyph as for the **Above** shortcut, `%` or `` `A ``, discussed in
  [the next section](#the-above-shortcut).</pNote> for a **vertical**
  SDCF,

as the ***last non-space*** character in the **Code** field, before the
*final* right brace.

Here’s an example of a horizontal SDCF, *i.e.* using `→`:

       name←'John Smith' ◇ age← 34
       ∆F 'Current employee: {name→}, {age→}.'
    Current employee: name→John Smith, age→34.

As a useful formatting feature, whatever spaces are just ***before*** or
***after*** the symbol **→** or **↓** are preserved ***verbatim*** in
the output.

Here’s an example with such spaces: see how the spaces adjacent to the
symbol `→` are mirrored in the output!

       name←'John Smith' ◇ age← 34
       ∆F 'Current employee: {name → }, {age→ }.'
    Current employee: name → John Smith, age→ 34.

Now, let’s look at an example of a vertical SDCF, *i.e.* using `↓`:

       name←'John Smith' ◇ age← 34
       ∆F 'Current employee: {name↓} {age↓}.'
    Current employee:  name↓     age↓.
                      John Smith  34

To make it easier to see, here’s the same result, but with a box around
each field—using the **Box** [option](#f-option-details), *namespace*
style.

    ⍝  Box all fields
       (box: 1) ∆F 'Current employee: {name↓} {age↓}.'
    ┌──────────────────┬──────────┬─┬────┬─┐
    │Current employee: │ name↓    │ │age↓│.│
    │                  │John Smith│ │ 34 │ │
    └──────────────────┴──────────┴─┴────┴─┘

## The Above Shortcut

> A cut above the rest…

<pNote>`%` can be used monadically. In that case, a left argument of
`''` (an empty string) is assumed. </pNote> Here’s a useful feature.
Let’s use the shortcut `%` to display one expression centered above
another; it’s called **Above** and can *also* be expressed as `` `A ``.

<pNote>Remember, `` `⍵1 `` designates the ***first*** argument after the
*f‑string* itself, and `` `⍵2 `` the ***second***. </pNote>

       ∆F '{"Employee" % ⍪`⍵1} {"Age" % ⍪`⍵2}' ('John Smith' 'Mary Jones')(29 23)
    Employee    Age
    John Smith  29
    Mary Jones  23

## Text Justification Shortcut

<pNote>`` `J `` is a variant of `just`, found in the *dfns* library.
</pNote> The Text **Justification** shortcut `` `J `` treats its right
argument as a character array, justifying each line to the left
(`⍺="L"`, the default), to the right (`⍺="R"`), or centered (`⍺="C"`).
<pNote>**maximum `⎕PP`:** the maximum `⎕PP` is `17` for 64-bit floats,
and `34` for 128-bit floats. </pNote> If its right argument contains
floating point numbers, they will be displayed with the maximum print
precision `⎕PP` available.

       a← ↑'elephants' 'cats' 'rhinoceroses'
       ∆F '{"L" `J a}  {"C" `J a}  {"R" `J a}'
    elephants      elephants       elephants
    cats              cats              cats
    rhinoceroses  rhinoceroses  rhinoceroses

And what do you think this *f-string* displays?

       ∆F '{¯1 `J `⍵1} {0 `J `⍵1} { 1`J `⍵1  }' (⍪10*2×⍳4)

<details id="pPeek">

<pSum> Peek at answer</pSum>

       ∆F '{¯1 `J `⍵1} {0 `J `⍵1} { 1`J `⍵1  }' (⍪10*2×⍳4)
    1          1          1
    100       100       100
    10000    10000    10000
    1000000 1000000 1000000

</details>

## Omega Shortcuts (Implicit)

> The *next* best thing: the use of `` `⍵ `` in **Code** field
> expressions…

We said we’d present the use of **Omega** shortcuts with implicit
indices `` `⍵ `` in **Code** fields. The expression `` `⍵ `` selects the
*next* element of the right argument `⍵` to **∆F**, defaulting to
`` `⍵1 `` when first encountered, *i.e.* if there are ***no*** `` `⍵ ``
elements (*explicit* or *implicit*) to the ***left*** in the entire
*f‑string*. If there is any such expression (*e.g.* `` `⍵5 ``), then
`` `⍵ `` points to the element after that one (*e.g.* `` `⍵6 ``). If the
item to the left is `` `⍵ ``, then we simply increment the index by `1`
from that one.

**Let’s try an example.** Here, we display arbitrary 2-dimensional
expressions, one above the other. `` `⍵ `` refers to the ***next***
argument in sequence, left to right, starting with `` `⍵1 ``, the first,
*i.e.* `(⍵⊃⍨ 1+⎕IO)`. So, from left to right `` `⍵ `` is `` `⍵1 ``,
`` `⍵2 ``, and `` `⍵3 ``.

<pNote>*Easy peasy.*</pNote>

       ∆F '{(⍳2⍴`⍵) % (⍳2⍴`⍵) % (⍳2⍴`⍵)}' 1 2 3
        0 0
      0 0 0 1
      1 0 1 1
    0 0 0 1 0 2
    1 0 1 1 1 2
    2 0 2 1 2 2

Here’s a useful example, where the formatting option (here, for text
justification `` `J ``) is determined by an argument to **∆F**:

       a← ↑'elephants' 'cats' 'rhinoceroses'
       ∆F '{`⍵ `J a}  {`⍵ `J a}  {`⍵ `J a}' ¯1 0 1
    elephants      elephants       elephants
    cats              cats              cats
    rhinoceroses  rhinoceroses  rhinoceroses

## Shortcuts With *APL* Expressions

Shortcuts often make sense with APL expressions, not just entire
**Code** fields. They can be manipulated like ordinary APL functions;
since they are just that— ordinary APL functions— under the covers.
Here, we display one boxed value above the other.

       ∆F '{(`B ⍳`⍵1) % `B ⍳`⍵2}' (2 2)(3 3)
      ┌───┬───┐
      │0 0│0 1│
      ├───┼───┤
      │1 0│1 1│
      └───┴───┘
    ┌───┬───┬───┐
    │0 0│0 1│0 2│
    ├───┼───┼───┤
    │1 0│1 1│1 2│
    ├───┼───┼───┤
    │2 0│2 1│2 2│
    └───┴───┴───┘

<details id="pPeek">

<pSum> Peek: Shortcuts are just Functions</pSum>

While not for the faint of heart, the expression above can be recast as
this concise <pNote>**concise:** somewhat hard to read.
</pNote>alternative:

       ∆F '{%/ `B∘⍳¨ `⍵1 `⍵2}' (2 2)(3 3)

</details
&#10;>

There are loads of other examples to discover.

## A Shortcut for Dates and Times (Part I)

<pNote>The syntax for the Date-Time specifications in the left argument
to `` `T `` can be found in the Dyalog doc­ument­ation under **1200⌶**.
See [below](#code-field-shortcuts), for more info. </pNote> **∆F**
supports a simple **Date-Time** shortcut `` `T `` built from **1200⌶**
and **⎕DT**. It takes one or more Dyalog `⎕TS`-format timestamps as the
right argument and a date-time specification as the <pnote>The default
left arg­ument is `⍺← '%ISO%'`, *i.e.* an ISO date-time.</pnote>
(optional) left argument. Trailing elements of a timestamp may be
omitted (they will each be treated as `0` in the specification string).

Let’s look at the use of the `` `T `` shortcut to show the current time
(now).

<pNote>The time displayed in practice will be the *true* current
time.</pNote>

       ∆F 'It is now {"t:mm pp" `T ⎕TS}.'
    It is now 8:08 am.

Here’s a fancier example<pNote>The power is in the capabilities of
`1200⌶` and `⎕DT`.</pNote>. (We’ve added the *truncated* timestamp
`2025 01 01` right into the *f‑string*.)

       ∆F '{ "D MMM YYYY ''was a'' Dddd."`T 2025 01 01}'
    1 JAN 2025 was a Wednesday.

## A Shortcut for Dates and Times (Part II)

If it bothers you to use `` `T `` for a date-only expression, you can
use `` `D ``, which means exactly the same thing.

       ∆F '{ "D MMM YYYY ''was a'' Dddd." `D 2025 01 02}'
    2 JAN 2025 was a Thursday.

Here, we’ll pass the time stamp via a single **Omega** expression
`` `⍵1 ``, whose argument <pNote>`(2025 1 21)`</pNote> is passed in
parentheses.

       ∆F '{ "D Mmm YYYY ''was a'' Dddd." `T `⍵1}' (2025 1 21)
    21 Jan 2025 was a Tuesday.

We could also pass the time stamp via a sequence of **Omega**
expressions: `` `⍵ `⍵ `⍵ ``. This is equivalent to the *slightly*
verbose expression: `` `⍵1 `⍵2 `⍵3 ``.

       ∆F '{ "D Mmm YYYY ''was a'' Dddd." `T `⍵ `⍵ `⍵}' 2025 1 21
    21 Jan 2025 was a Tuesday.

## The Quote Shortcut

> Placing quotes around string elements of an array.

<pNote>If a multi­dimensional character array is found, its <em>rows</em>
are quoted; if a character vector, it is quoted <em>in toto</em>; else,
each character <em>scalar</em> is quoted in isolation. </pNote> The
**Quote** shortcut `` `Q `` recursively scans its right argument,
matching rows of character arrays, character vectors, and character
scalars, doubling internal single quotes and placing single quotes
around the items found.

Non-character data is returned as is. This is useful, for example, when
you wish to clearly distinguish character from numeric data.

Let’s look at a couple of simple examples:

First, let’s use the `` `Q `` shortcut to place quotes around the simple
character arrays in its right argument, `⍵`. This is useful when you
want to distinguish between character output that might include numbers
and *actual* numeric output.

       ∆F '{`Q 1 2 "three" 4 5 (⍪1 "2") (⍪"cats" "dogs")}'
    1 2  'three'  4 5     1    'cats'
                        '2'    'dogs'

And here’s an example with a simple, mixed vector (*i.e.* a mix of
character and numeric scalars only). We’ll call the object `iv`, but we
won’t disclose its definition yet.

Let’s display `iv` without using the **Quote** shortcut.

       iv← ...
       ∆F '{iv}'
    1 2 3 4 5

Are you ***sure*** which elements of `iv` are numeric and which
character scalars?

<details id="pPeek">

<pSum> Peek to see the example with `iv` defined.</pSum>

       iv← 1 2 '3' 4 '5'
       ∆F '{iv}'
    1 2 3 4 5

</details>

Now, we’ll show the variable `iv` using the **Quote** `` `Q `` shortcut.

       iv← 1 2 '3' 4 '5'
       ∆F '{`Q iv}'

<details id="pPeek">

<pSum> Take a peek at the <bold>∆F</bold> output.</pSum>

    1 2 '3' 4 '5'

</details>

Voilà, quotes appear around the character digits, but not the actual APL
numbers!

## The Wrap Shortcut <pRed>(Experimental)</pRed>

<div class="test-feature">

> Wrapping results in left and right decorators…

<pNote>For more, see [Wrap Shortcut:
Details](#wrap-shortcut-details-experimental) *below*. </pNote> The
shortcut **Wrap** `` `W `` is <pRed>***experimental***</pRed>. `` `W ``
is used when you want to place a ***decorator*** string immediately to
the left or right of ***each*** row of simple objects in the right
argument, `⍵`. It differs from the **Quote** shortcut `` `Q ``, which
puts quotes ***only*** around the character arrays in `⍵`.

- The decorators are in `⍺`, the left argument to **Wrap**: the left
  decorator, `0⊃2⍴⍺`, and the right decorator, `1⊃2⍴⍺`, with `⍺`
  defaulting to a single quote.
- If you need to omit one or the other decorator, simply make it a null
  string `""` or a *zilde* `⍬`.

**Here are two simple examples.**

In the first, we place `"°C"` after **\[a\]** each row of a table
`` ⍪`⍵2 ``, or **\[b\]** after each simple vector in `` ,¨`⍵2 ``. We
indicate that is no *left* decorator here using `""` or `⍬`, as here.

    ⍝         ... [a] ...       .... [b] ....
        ∆F '{ `⍵1 `W ⍪`⍵2 } ...{ `⍵1 `W ,¨`⍵2 }' (⍬ '°C')(18 22 33)
    18°C ... 18°C 22°C 33°C
    22°C
    33°C

In this next example, we place brackets around the lines of each simple
array in a complex array.

       ∆F '{"[]" `W ("cats")(⍳2 2 1)(2 2⍴⍳4)(3 3⍴⎕A) }'
    [cats] [0 0 0] [0 1] [ABC]
           [0 1 0] [2 3] [DEF]
                         [GHI]
           [1 0 0]
           [1 1 0]

<div id="winner2">

<pNote>[See the earlier ex­ample](#winner1) with­out **Wrap**.</pNote>
Now, let’s try recasting an earlier example to use **Wrap** `` `W ``.

       n← ≢names← 'Mary' 'Jack' 'Tony'
       prize← 1000
       ∆F '{ ↑names }{ ⍪n⍴ ⊂"wins" }{ "£", ⍕⍪?n⍴ prize }'

</div>

<details id="pPeek">

<pSum> Below is one solution…</pSum>

<pNote><br><br>The string `"wins "` is the left prefix to **Wrap**, and
`""` the right.</pNote>

       n← ≢names← 'Mary' 'Jack' 'Tony'
       prize← 1000
       ∆F '{ ↑names } { "wins " "" `W "£", ⍕⍪?n⍴ prize }'
    Mary wins £201
    Jack wins £ 73
    Tony wins £349

</details>

</div>

## The Session Library Shortcut <pRed>(Experimental)</pRed>

<div class="test-feature">

The shortcut (Session) **Library** `£` is <pRed>**experimental**</pRed>.
`£` denotes <pNote>**£ alias:** `` `L ``. £ is from the first letter of
the Latin *lībra*, “pound”, very apt for a *libra*-ry.<br><br>**⍙Fapl**:
*See [Installing **∆F**](#installing-f), above.* </pNote> a “private”
*user* namespace in **⍙Fapl**, where the user may place and manipulate
useful objects for the duration of the ***current*** *APL* session. For
example, the user may wish to: <pNote>*For details, see [Code Field
Short­cuts](#code-field-shortcuts) below.*</pNote>

- have regularly used functions or operators automatically available
  when needed, *or*
- create objects that might be referred to, monitored, or modified
  during the session.

### Explicitly Copied Library Objects

In this example, the user wants to generate all primes between 1 and 100
using two routines, `sieve` and `to`, that reside in the ***dfns***
workspace. To accommodate this, we could simply copy them in advance,
just in case they are needed.

> But there’s a better way!

Here we copy both routines from ***dfns*** in real time, only when they
are needed.

<pNote>`⎕CY` returns `0⍴⊂''` on success, i.e. an *invisible*, 0-width
string! </pNote>

        ∆F '{"sieve" "to" £.⎕CY "dfns"}{£.sieve 2 £.to 100}'
    2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97

On subsequent calls, `sieve` and `to` are already available, as we can
see here:

        ∆F '{ £.⎕NL ¯3 }'
     sieve  to

### Automatically Copied Library Objects

> But, **∆F** provides a simpler solution!

If <pNote>We only show examples of objects from the *dfns* library here.
*See [Code Field Shortcuts](#code-field-shortcuts) below.* </pNote> the
user references a name of the form `£.name` that has not (yet) been
defined in the library, an attempt is made to copy that name into the
library either from the ***dfns*** workspace or from a text file; if the
name appears to the left-side of a **simple** assigment `←`, it is
assumed to exist (as always), *i.e.* is not copied in.

&RHAND; If **∆F** is unable to find the item during its search, a
standard *APL* error will be signaled.

In this next example, we use *for the first time* the function `pco`
from the `dfns` workspace.

        ∆F '{ ⍸ 1 £.pco ⍳100 }'
    2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97

<details id="pPeek">

<pSum> Peek: Using the <em><strong>verbose</strong></em> option</pSum>

&RHAND; To understand *when* an object is automatically copied into a
£ibrary, or to see *where* it’s copied from, use **∆F**’s ***verbose***
option:

<pNote><br>First use of `£.pco` this *session.* Subsequent uses will use
the existing `£.pco`.</pNote>

       0 1 ∆F '{ ⍸ 1 £.pco ⍳100 }'    ⍝ 0 1 <==> (verbose: 1)
    NOTE: Copied "pco" into £=[⎕SE.⍙Fapl.ûLib] from "ws:dfns"
    { ⎕SE.⍙Fapl.M ⌽⍬({⍸ 1 ⎕SE.⍙Fapl.ûLib.pco ⍳100}⍵)}⍵
    2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97

</details>

> With the default *verbose* setting, `(verbose: 0)`, the process is
> identical, but quieter!

### Session Library Variables

> But we can use the Session Library shortcut for arrays as well.

<pNote>&RHAND; If `£.ctr` already exists, it must be in the same class
as its new value, consistent with *APL* rules.</pNote>

Here is an example where we define a local session variable `ctr`, a
counter of the number of times a particular statement is executed. Since
we define the counter, `£.ctr←0`, **∆F** makes ***no*** attempt to copy
it from the `dfns` workspace or a file.

       ∆F '{ ⍬⊣£.ctr←0 }'         ⍝ Initialise £.ctr.
       t← 'We''ve been called {£.ctr← £.ctr+1} times.'
    ⍝  ...
       ∆F t
    We've been called 1 times.
       ∆F t
    We've been called 2 times.

This may be sensible when ∆F is called from a variety of namespaces
and/or if the user doesn’t wish to clutter the active namespace.

&RHAND; When a *dfn* created via **∆F** with the ***dfn*** mode set
<pNote>`1 ∆F '...'`.</pNote>to `1`, any uses of `£` will require the
associated ⍙Fapl namespace to be present. We discuss the ***dfn***
option in the *next* section!

</div>

## Precomputed f‑strings with the ***dfn*** Option

As shown in Table 3a (below), with *(i)* the default *dfn* option set to
`0`, the value returned from a successful call to **∆F** is always a
character matrix. However, *(ii)* <pNote>Under identical conditions, of
course.</pNote> if [*dfn*](#f-option-details) is set to `1`, then **∆F**
returns a **dfn** that— when called later— will return the identical
character expression.

|        |   <br>Mode    | Positional <br>Parameter | Keyword <br>Parameter  |
|--------|:-------------:|:------------------------:|:----------------------:|
| *(i)*  | ***default*** |     `0 ∆F 'mycode'`      | `(dfn: 0) ∆F 'mycode'` |
| *(ii)* |   ***dfn***   |     `1 ∆F 'mycode'`      | `(dfn: 1) ∆F 'mycode'` |

3a. <strong>Using the <em>dfn Option</em></strong>

<pNote><br>**standalone:** *i.e.* via the *inline* option. See [option
details](#f-option-details) (be­low) re­gard­ing the *inline* option and
ex­ceptions.</pNote> The *dfn* option is most useful when you are making
repeated use of an *f‑string*, since the overhead for analyzing the
*f‑string* contents ***once*** will be amortized over ***all*** the
subsequent calls. An **∆F**-derived *dfn* can also be made standalone,
*i.e.* independent of the runtime library, **⍙Fapl**.

Let’s explore an example where getting the best performance for a
heavily used **∆F** string is important.

First, let’s grab `cmpx` and set the variable `cv`, so we can compare
the performance…

       'cmpx' ⎕CY 'dfns'
       cv← 11 30 60

Now, let’s proceed. Here’s our **∆F** String `t`:

       t←'The temperature is {"I2" $ cv}°C or {"F5.1" $ 32+9×cv÷5}°F'

<details id="pPeek">

<pSum> Evaluate <code>∆F t</code></pSum>

       ∆F t
    The temperature is 11°C or  51.8°F
                       30       86.0
                       60      140.0

</details>

Let’s precompute a dfn `T`, given the string `t`. `T` has everything
needed to generate the output (given the same definition of the vector
`cv`, when `T` is evaluated).

       T← 1 ∆F t

<details id="pPeek">

<pSum> Evaluate <code>T ⍬</code></pSum>

       T ⍬
    The temperature is 11°C or  51.8°F
                       30       86.0
                       60      140.0

</details>

Now, let’s compare the performance of the two formats.
<pNote><br><br><br>Both `t` and `T` will reference `cv`.</pNote>

       cmpx '∆F t' 'T ⍬'
    ∆F t → 1.5E¯4 |   0% ⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕
     T ⍬ → 1.1E¯5 | -93% ⎕⎕⎕

The precomputed version is at least an <mark>order of magnitude</mark>
faster.

Before we get to syntax and other information, we want to show you that
<pNote>The *dfn* returned includes the original *f‑string* text used to
generate it, available as `` `⍵0 ``.</pNote> the *dfn* returned when the
*dfn* option is set to `1` can retrieve one or more arguments passed on
the right side of **∆F**, using the very same omega shortcut expressions
(like `` `⍵1 ``) we’ve discussed above.

Let’s share the Centigrade values `cv` from our current example, not as
a *variable*, but as the *first argument* to **∆F**. We’ll access the
value as `` `⍵1 ``.

      cv←11 30 60
       t←'The temperature is {"I2" $ `⍵1}°C or {"F5.1" $ 32+9×`⍵1÷5}°F'
       T← 1 ∆F t

       ∆F t cv
    The temperature is 11°C or  51.8°F
                       30       86.0
                       60      140.0

       T ⊂cv
    The temperature is 11°C or  51.8°F
                       30       86.0
                       60      140.0

       cmpx '∆F t cv' 'T ⊂cv'
    ∆F t cv → 1.8E¯4 |   0% ⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕
      ⊂T cv → 1.1E¯5 | -95% ⎕⎕⎕

The precomputed version again shows a speedup of well over an
<mark>order of magnitude</mark> compared to the default version.

------------------------------------------------------------------------

Below, we summarize key information you’ve already gleaned from the
examples.

</details>

# ∆F Syntax and Other Information

<details>

<!-- option: open -->

<pSum> Show/Hide <em>Syntax Info</em></pSum>

## ∆F Call Syntax Overview

<pNote><br><br><br><br><br><br><br><br>An *f-string* might use
multi-line Array Notation for pedagog­ical or document­ation pur­poses,
*e.g.* where fields are entered line by line, each with annotations via
`⍝`.</pNote> <pNote><br><br><br><br><br>***Options*** may be either
*positional* or— starting in Dyalog v. 20— *keyword*-based. We show the
posi­tion­al forms through­out the ex­amples, but doc­ument the key­words as
well below.</pNote>

| Call Syntax | Description |
|:---|:---|
| **∆F** ***f‑string*** | Display an *f‑string*; use the *default* options. The string may reference objects in the environment or in the string itself. Returns a character matrix. <br>An ***f-string*** must be a character vector of any length or a vector of character vectors. If the latter, it will be converted (via *enlist,* `∊`) to one, longer character vector, without any added spaces, newlines, etc. |
| **∆F** ***f‑string*** ***args*** | Display an *f‑string* (see above); use the *default* options. Arguments presented *may* be referred to in the f‑string. Returns a character matrix. |
| ***options*** **∆F** ***f‑string*** \[***args***\] | Display an *f‑string* (see above); control the result with *options* specified (see below).<br>If ***dfn*** (see below) is `0` or omitted, returns a character matrix.<br>If ***dfn*** is `1`, returns a dfn that will display such a matrix (given an identical system state). |
| ‘help’ **∆F** ‘ ’ *or* **∆F**⍨‘help’ | Display help info and examples for **∆F**. The *f‑string* is not examined. &RHAND; See below for details and related examples. |
| ***return value*** | See below. |

4a. <strong>∆F Call Syntax Overview</strong>

<br>

## ∆F Option Details

| <br><br>Mode | Positional<br>Option<br><small>\[*index*\]</small> | Keyword<br>Option<br><small>(*keyword: default*) | <br><br>Description |
|:--:|:--:|:--:|:---|
| **Dfn** |  ***\[0\]*** | ***dfn: 0*** | If ***dfn: 1***, **∆F** returns a dfn, which (upon execution) produces the same output as the default mode.<br>If ***dfn: 0*** (default): **∆F** returns a char. matrix. |
| **Verbose** |  ***\[1\]*** | ***verbose: 0*** | If ***verbose: 1***, Renders newline characters from `` `◇ `` as the visible `␤` character. Displays the source code that the *f‑string* ***actually*** generates; if ***dfn*** is also `1`, this will include the embedded *f‑string* source (accessed as `` `⍵0 ``). After the source code is displayed, it will be executed or converted to a *dfn* and returned (see the ***dfn*** option above).<br>If ***verbose: 0*** (default): Newline characters from `` `◇ `` are rendered normally as carriage returns, `⎕UCS 13`; the ***dfn*** source code is not displayed. |
| **Box** |  ***\[2\]*** | ***box: 0*** | If ***box: 1***, each field (except a null **Text** field) is boxed separately.<br>If ***box: 0*** (default), nothing is boxed automatically. Any **Code** field expression may be explicitly boxed using the **Box** shortcut, `` `B ``.<br>&RHAND; ***box*** mode can be used with settings <strong>`dfn: 1`</strong> *and* <strong>`dfn: 0`.</strong> |
| **Auto** |  ***\[3\]*** | ***auto: 1*** | If ***auto: 0***, user must manually load/create any Session Library objects for use with the £ or `` `L `` shortcuts.<br>If ***auto: 1*** (default), honors the default and user-defined settings for `auto`. &RHAND; Depends on (i) user parameter file **./.∆F** and (ii) the namespace **⍙Fapl** created during the `]load` process. |
| **Inline** |  ***\[4\]*** | ***inline: 0*** | If ***inline: 1*** and ***dfn: 1***, the code for each internal support function used is included in the *dfn* result; ***no*** reference to namespace **⍙Fapl** will be made during the execution of that *dfn*. (***Exception:*** see *Session Library Shortcuts* below.)<br>If ***inline: 0*** (default), whenever **∆F** or a *dfn* generated by it is executed, it makes calls to library routines in the namespace **⍙Fapl**, created during the `]load` process for **∆F**.<br>&RHAND; This option is experimental and may simply disappear one day. |
| **Special** | ***‘help’*** | — | If `'help'` is specified, this amazing doc­ument­ation is displayed. |
| **Special** | ***‘parms’*** | — | Updates and displays Session Library (`£` or `` `L ``) pa­ram­eters. &RHAND; This option is ex­peri­ment­al. |

4b. <strong>∆F Option Details</strong>

- **Default options:** If the left argument `⍺` is omitted, the options
  default as shown here.

  |  Option Style  |                        Defaults                        |
  |:--------------:|:------------------------------------------------------:|
  | **Positional** |                      `0 0 0 1 0`                       |
  |  **Keyword**   | `(dfn: 0 ◇ verbose: 0 ◇ box: 0 ◇ auto: 1 ◇ inline: 0)` |

  4c. <strong>∆F Default Options</strong>

- **Positional style options:** If **∆F**’s left argument `⍺` is a
  simple integer vector (or a scalar), omitted (trailing) elements are
  replaced by the corresponding elements of the default,
  `0 0 0 1 0`.<br>&RHAND; Extra elements will trigger a
  *`LENGTH ERROR`*.

- **Keyword style options:** If the left argument is a <pNote>Dyalog 20
  and later. See docu­ment­ation on *APL* Ar­ray
  Not­ation.</pNote>namespace, it is assumed to contain option names (in
  any order) with their non-default
  values,<br>  e.g. `(verbose: 1 ◇ auto: 0)`;  
  Keyword options are new for Dyalog 20. They are sometimes clearer and
  more convenient than positional keywords.

- **Help option:** If the left argument `⍺` starts with `'help'` (case
  ignored), this help information is displayed. In this case, the right
  argument to **∆F** is ignored.

- **Parms option:** If the left argument `⍺` matches `'parms'` (case
  ignored), the Session Library parameters are (re-)loaded and
  displayed. In this case, the right argument to **∆F** is ignored.

- Otherwise, an error is signaled.

## ∆F Return Value

- Unless the ***dfn*** option is selected, **∆F** always returns a
  character matrix of at least one row and zero columns, `1 0⍴0`, on
  success. If the ‘help’ option is specified, **∆F** displays this
  information, returning `1 0⍴0`. If the ‘parms’ option is specified,
  **∆F** shows the Session Library parameters as a character matrix.
- If the ***dfn*** option is selected, **∆F** always returns a standard
  Dyalog dfn on success.
- On failure of any sort, an informative APL error is signaled.

## ∆F F‑string Building Blocks

The first element in the right arg to ∆F is a character vector, an
*f‑string*, which contains one or more **Text** fields, **Code** fields,
and **Space** fields in any combination.

- **Text** fields consist of simple text, which may include any Unicode
  characters desired, including newlines.
  - Newlines (actually, carriage returns, `⎕UCS 13`) are normally
    entered via the sequence `` `◇ ``.
  - Additionally, literal curly braces can be added via `` `{ `` and
    `` `} ``, so they are distinct from the simple curly braces used to
    begin and end **Code** fields and **Space** fields.
  - Finally, to enter a single backtick `` ` `` just before the special
    symbols `{`, `}`, `◇`, or `` ` ``, enter ***two*** backticks
    ``` `` ```; if preceding any ordinary symbol, a ***single***
    backtick will suffice.
  - If **∆F** is called with an empty string, `∆F ''`, it is interpreted
    as containing a single 0-length **Text** field, returning a matrix
    of shape `1 0`.
- **Code** fields are run-time evaluated expressions enclosed within
  simple, unescaped curly braces `{ }`, *i.e.* those not preceded by a
  backtick (see the previous paragraph).
  - **Code** fields are, under the covers, Dyalog *dfns* with some
    extras.
  - For escape sequences, see **Escape Sequences** below.
- **Space** fields appear to be a special, *degenerate*, form of
  **Code** fields, consisting of a single pair of simple (unescaped)
  curly braces `{}` with zero or more spaces in between.
  - A **Space** field with zero spaces is a ***null*** **Space** field;
    while it may separate any other fields, its typical use is to
    separate two adjacent **Text** fields.
  - Between fields, **∆F** adds no automatic spaces; that spacing is
    under user control.

## Code Field Shortcuts

**∆F** **Code** fields may contain various shortcuts, intended to be
concise and expressive tools for common tasks. **Shortcuts** are valid
in **Code** fields only *outside* **Quoted strings**.

**Shortcuts** include:

| Shortcut | Name | Meaning |
|:---|:--:|:---|
| **\`A**, **%** | Above | `[⍺] % ⍵`. Centers array `⍺` above array `⍵`.<br>If omitted, `⍺←''`, *i.e.* a blank line. |
| **\`B** | Box | `` `B ⍵ ``. Places `⍵` in a box. `⍵` is any array. |
| **\`C** | Commas | `` [⍺]`C ⍵ ``. By default, adds commas after every 3rd digit (from the right) of the *integer* part of each number in `⍵` (leaving the fractional part as is). `⍵` is zero or more num strings and/or numbers. If specified, ⍺\[0\] is the stride, *if not 3,* as an integer or as a single quoted digit; if specified, ⍺\[1\] is the character (even “\`◇”) to insert *in place of* a comma. <br><small>Examples: “5\_” adds an underscore every 5 digits from the right. “3\`◇” puts each set of 3 digits on its own line.</small> |
| **\`D** | Date-Time | Synonym for **\`T**. |
| **\`F**, **\$** | ⎕FMT | `[⍺] $ ⍵`. Short for `[⍺] ⎕FMT ⍵`. (See APL doc­ument­ation). |
| **\`J** | Justify | `` [⍺] `J ⍵ ``. Justify each row of object `⍵` as text:<br>  *left*: ⍺=“L”; *center*: ⍺=“C”; *right* ⍺=“R”.<br>You may use `¯1`\|`0`\|`1` in place of `"L"`\|`"C"`\|`"R"`. If omitted, `⍺←'L'`. <small>*Displays numbers with the maximum precision available.*</small> |
| **\`L**, **£** | Session Library<br><pRed><small>**EXPERIMENTAL!**</small></pRed> | `£`. `£` denotes a private library (namespace) local to the **∆F** runtime environ­ment into which functions or objects (including name­spaces) may be placed (e.g. via `⎕CY`) for the duration of the *APL* session. Outside of simple assignments, **∆F** will attempt to copy undefined objects from, *in order:*<br> <small><sup>directory</sup></small> **./MyDyalogLib/**  \>  <small><sup>*APL* ws</sup></small> **dfns**  \> <small><sup>directory</sup></small> **./**<br><small>*For filetypes and customisation, see [Session Library Shortcut: Details](#session-library-shortcut-details) below.*</small> |
| **\`Q** | Quote | `` [⍺]`Q ⍵ ``. Recursively scans `⍵`, putting char. vectors, scalars, and rows of higher-dimensional strings in APL quotes, leaving other elements as is. If omitted, `⍺←''''`. |
| **\`T** | Date-Time | `` [⍺]`T ⍵ ``. Displays timestamp(s) `⍵` according to date-time template `⍺`. `⍵` is one or more APL timestamps `⎕TS`. `⍺` is a date-time template in `1200⌶` format. If omitted, `⍺← '%ISO%'`. |
| **\`W** | Wrap <pRed><small>**EXPERIMENTAL!**</small></pRed> | `` [⍺]`W ⍵ ``. Wraps the rows of simple arrays in ⍵ in decorators `0⊃2⍴⍺` (on the left) and `1⊃2⍴⍺` (on the right). If omitted, `⍺←''''`. <small>*See details below.*</small> |
| **\`⍵𝑑𝑑**, **⍹𝑑𝑑** | Omega Shortcut<br>(<small>EXPLICIT</small>) | A shortcut of the form `` `⍵𝑑𝑑 `` (or `⍹𝑑𝑑`), to access the `𝑑𝑑`**th** element of `⍵`, *i.e.* `(⍵⊃⍨ 𝑑𝑑+⎕IO)`. <small>*See details below.*</small> |
| **\`⍵**, **⍹** | Omega Shortcut<br>(<small>IMPLICIT</small>) | A shortcut of the form `` `⍵ `` (or `⍹`), to access the ***next*** element of `⍵`. <small>*See details below.* <small> |
| **→**<br>**↓** *or* **%** | Self-documenting **Code** Fields <small>(SDCFs)</small> | `→` at end of **Code** field signals that the source code for the field appears *to the left of* its value. Surrounding blanks are significant.<br>`↓` (*or,* `%`) at end of **Code** field signals that the source code for the field appears *above* its value. Surrounding blanks are significant.<br><small>*See [SDCFs](#self-documenting-code-fields-sdcfs) in **Examples** for details.*</small> |

4d. <strong>Code Field Shortcuts</strong>

<br>

## Escape Sequences: Text Fields & Quoted Strings

<pNote>See [Quoted Strings in Code
Fields](#quoted-strings-in-code-fields) below on displaying quote
characters like `"` in a string. </pNote> **∆F** **Text** fields and
**Quoted strings** in **Code** fields may include a small number of
escape sequences, beginning with the backtick `` ` ``. Some sequences
are valid in **Text** fields *only*, but not in Quoted strings:

<pNote><br><br>**Both**: *i.e.* **Text** fields and *Quoted Strings* in
**Code** fields. </pNote>

| Escape Sequence | What<br> It Inserts | <br> Description |      <br> Where      |
|:---------------:|:-------------------:|:----------------:|:--------------------:|
|     **\`◇**     |      *newline*      |     ⎕UCS 13      | Text and Code fields |
|    **\`\`**     |         \`          |     backtick     | Text and Code fields |
|     **\`{**     |          {          |    left brace    |   Text fields only   |
|     **\`}**     |          }          |   right brace    |   Text fields only   |

4e. <strong>Escape Sequences</strong>

Other instances of the backtick character in **Text** fields or **Quoted
strings** in **Code** fields will be treated literally, *i.e.* sometimes
a backtick is just a backtick.

## Quoted Strings in Code Fields

As mentioned in the introduction, **Quoted strings** in **Code** fields
allow several delimiting quote styles:

- **double-quotes**<br> `∆F '{"like «this» one"}'` or
  `∆F '{"like ''this'' one."}'`,
- **double angle quotation marks**,<br>
  `∆F '{«like "this" or ''this''.»}'`,  
  as well as
- APL’s tried-and-true embedded **single-quotes**,<br>
  `∆F '{''shown like ''''this'''', "this" or «this».''}'`.

<pNote>Compare these
examples:<br> **Invalid:** <pRed>∆F ‘{“abc\`”def”}’</pRed><br> **Valid:** `∆F '{"abc""def"}'`
</pNote> If you wish to include a traditional delimiting quote (`'` or
`"`) or the closing quote of a quote pair (`«` `»`) within the **Quoted
string**, you must double it. You may *not* use an escape sequence
(e.g. `` `" ``) for this purpose.

| Closing Quote |           <br> Example           |      <br> Result      |
|:-------------:|:--------------------------------:|:---------------------:|
|      `"`      | `∆F '{"like ""this"" example"}'` | `like "this" example` |
|      `»`      |    `∆F '{«or «this»» one»}'`     |    `or «this» one`    |
|      `'`      | `∆F '{''or ''''this'''' one''}'` |    `or 'this' one`    |

4f. <strong>Closing Quotes</strong>

Note that the opening quote `«` is treated as an ordinary character
within the string. The clumsiness of the standard single quote `'`
examples is due to the fact that the single quote is the required
delimiter for the outermost (APL-level) string.

## Omega Shortcut Expressions: Details

1.  **⍹** is a synonym for **\`⍵**. It is Unicode character `⎕UCS 9081`.
    Either glyph is valid only in **Code** fields and outside **Quoted
    strings**.
2.  **\`⍵** or **⍹** uses an “*omega index counter*” (**OIC**) which
    we’ll represent as **Ω**, common across all **Code** fields, which
    is initially set to zero, `Ω←0`. (**Ω** is just used for
    explication; don’t actually use this symbol)
3.  All **Omega** shortcut expressions in the *f‑string* are evaluated
    left to right and are ⎕IO-independent.
4.  **\`⍵𝑑𝑑** or **⍹𝑑𝑑** sets the *OIC* to 𝑑𝑑, `Ω←𝑑𝑑`, and returns the
    expression `(⍵⊃⍨Ω+⎕IO)`. Here **𝑑𝑑** must be a *non-negative
    integer* with at least 1 digit.
5.  Bare **\`⍵** or **⍹** (*i.e.* with no digits appended) increments
    the *OIC*, `Ω+←1`, *before* using it as the index in the expression
    `(⍵⊃⍨Ω+⎕IO)`.
6.  The *f‑string* itself (the 0-th element of **⍵**) is always accessed
    as `` `⍵0 `` or `⍹0`. The omega with *implicit index* always
    increments its index *before* use, *i.e.* starting by default with
    `` `⍵1 `` or `⍹1`.
7.  If an element of the dfn’s right argument **⍵** is accessed at
    runtime via any means, shortcut or traditional, that element
    ***must*** exist.

<details id="pPeek">

<pSum> View Details on Experimental Features</pSum>

<div class="test-feature">

<pNote><pRed>Experimental</pRed></pNote>

## Wrap Shortcut: Details

1.  Syntax: `` [⍺←''''] `W ⍵ ``.
2.  Let `L←0⊃2⍴⍺` and `R←1⊃2⍴⍺`.
3.  Wrap each row `X′` of the simple arrays `X` in `⍵` (or the entire
    array `X` if a simple vector or scalar) in decorators `L` and `R`:
    `L,(⍕X′),R`.
4.  `⍵` is an array of any shape and depth.`L`and `R`are char. vectors
    or scalars or `⍬` (treated as `''`).
5.  If there is one scalar or enclosed vector `⍺`, it is replicated
    *per (2) above*.
6.  By default,`⍺← ''''`,*i.e.* APL quotes will wrap the array ⍵, row by
    row, whether character, numeric or otherwise.

<pNote><pRed><br>Experimental</pRed></pNote>

## Session Library Shortcut: Details

1.  If <pNote>With the default `auto` option and `]load`-time
    par­a­meters. See [Lib­rary
    Parameters](#session-library-shortcut-parameters) and [File­types of
    Lib­rary Source
    Files](#session-library-shortcut-filetypes-of-source-files)
    below.</pNote> an object `£.name` is referenced, but not yet defined
    in `£`, an attempt is made to copy it to `£` from workspace `dfns`
    and/or from files **name.aplf** (for functions), **name.aplo** (for
    operators), *etc.* in files in the (user-settable) search path,
    *unless* it is being assigned (via `←`). It will be available for
    the duration of the session.

2.  In the case of a simple assignment (`£.name←val`), the object
    assigned must be new or of a compatible *APL* class with its
    existing value, else a domain error will be signaled.

3.  Modified assignments of the form `£.name+←val` are allowed and
    treated as in the first case.

### Session Library Shortcut: Filetypes of Source Files

<pNote><br><br><br><br><br><br><br><br><br><br><br>**apla:** Encoded
using *APL* Array Notation (Dyalog 20).<br><br><br>**txt:** Each line of
file is converted to a Unicode char. vector.</pNote>

| <br>Filetype | <br>Action | APL Class ⎕NC | Key APL<br>Service | Available<br>by Default? | Type <br>Enforced? |
|:--:|:--:|:--:|:--:|:--:|:--:|
| aplf | Fixes function | 3 | ⎕FIX | ✔ | ✔<small> FUTURE</small> |
| aplo | Fixes operator | 4 | ⎕FIX | ✔ | ✔<small> FUTURE</small> |
| apln | Fixes ns | 9 | ⎕FIX | ✔ | ✔<small> FUTURE</small> |
| apla | Assigns array or ns | 2, 9 | *assignment* | ✔ | ✔ |
| json | Fixes ns from JSON5 | 9 | ⎕JSON | ✔ | ✔ |
| txt | Assigns char. vectors | 2 | *assignment* | ✔ | ✔ |
| dyalog, *other* | Fixes object | 3, 4, 9 | ⎕FIX | <pRed>✘</pRed> | <pRed>✘<small> NEVER</small></pRed> |

4g. <strong>Library Filetypes: Meaning</strong>

### Session Library Shortcut: Parameters

The <pNote>If the automatic search feature is enabled— the default—, the
*first* time each name is used there is the potential for substantial
overhead in searching for, loading, and fixing it in the session
library.</pNote> Session Library shortcut (`£` or `` `L ``) is
deceptively simple, but the code to support it is a tad complex. The
complex components run only when **∆F** is loaded. If the **auto**
parameter is `1`, there is a modest performance impact at runtime. If
`0`, the runtime impact of the feature is more modest still.

To support the Session Library auto-load process, there are parameters
that the user may *optionally* tailor via an APL Array Notation
parameter file **. ∆F** placed in the current file directory. Parameters
include:

- **load:** the ability, when **∆F** is being loaded, to define
  <pNote>If **load** is set to `0`, the definition process is not
  executed and **auto** is ignored. </pNote> where— in which files or
  workspaces— to find Session Library objects, based on default or user
  parameters;
- **auto:** allowing **∆F** to automatically load undefined objects of
  the form `£.obj` or `` `L.obj `` into the Session Library from
  workspaces or files on the search path;
- **verbose:** providing limited information on parameters, object
  loading, *etc.*;
- **path:** listing what directories to search for the object
  definitions;
- **prefix:** literal character vectors to prefix to each file name
  during the object search;
- **suffix:** <pNote>More details appear below.</pNote>filemodes that
  indicate the type of object and (potentially) any expected conversion;

The built-in *(default)* parameter file <pNote>Additional doc­ument­ation
is need­ed, should this go forward.</pNote> is documented *below*.

<details>

<pSum> <em>Show/Hide Default £ibrary Parameter File</em>
<big><strong>. ∆F</strong></big></pSum>

``` skip
(
 ⍝ Default .∆F (JSON5) Parameter File
 ⍝ Items not to be (re)set by user may be omitted/commented out.
 ⍝ If (load: ⎕NULL), then LIB_LOAD [note 1] is used for load.
 ⍝ If (verbose: ⎕NULL), then VERBOSE [note 1] is used for verbose.
 ⍝ If (prefix: ⎕NULL) or (prefix: ⍬), then (prefix: '' ◇)
 ⍝ [note 1]
 ⍝   ∆F global variables LIB_LOAD and VERBOSE are set in ∆Fapl.dyalog.
 ⍝    Their usual values are LIB_LOAD← 1 ◇ VERBOSE← 0
 ⍝    See load: and verbose: below for significance.

 ⍝ load:
 ⍝   1:     Load the runtime path to search for Session Library £ and `L.
 ⍝   0:     Don't load...
 ⍝   ⎕NULL: Grab value from LIB_LOAD above.
   load: ⎕NULL

 ⍝ auto:
 ⍝   0: user must load own objects; nothing is automatic.
 ⍝   1: dfns and files (if any) searched in sequence set by dfnsOrder.
 ⍝      See path for directory search sequence.
 ⍝ Note: If (load: 0) or if there are no files in the search path,
 ⍝       auto is set to 0, since nothing will ever match.
   auto: 1

 ⍝ verbose:
 ⍝    If 0 (quiet),
 ⍝    If 1 (verbose).
 ⍝    If ⎕NULL, value is set from VERBOSE (see above).
   verbose: ⎕NULL

 ⍝ path: The file dirs and/or workspaces to search IN ORDER left to right:
 ⍝    e.g. path: [ 'fd1', 'fd2', ['ws1', 'wsdir/ws2'], 'fd3', ['ws3']]
 ⍝    For a file directory, the item must be a simple char vector
 ⍝        'MyDyalogLib'
 ⍝    For workspaces, the item must be a vector of one or more char vectors
 ⍝        (⊂'dfns') or (⊂'MyDyalogLib/mathfns') or ('dfns', 'myDfns')
 ⍝  To indicate we don't want to search ANY files,
 ⍝     best: (load: 0)
 ⍝     ok:   (path: ⎕NULL)
   path:  ( './MyDyalogLib' ◇ ('dfns'◇) ◇ '.' ◇ )

 ⍝ prefix: literal string to prefix to each name, when searching directories.
 ⍝     Ignored for workspaces.
 ⍝     ⍬ is equiv. to  ''.
 ⍝     Example given name 'mydfn' and (prefix: '∆F_' 'MyLib/' ◇ suffix: ⊂'aplf')
 ⍝     ==> ('∆F_mydfn.aplf'  'MyLib/mydfn.aplf')
   prefix: ⍬

 ⍝ suffix: at least one suffix is required. The '.' is prepended for you!
 ⍝    Not applicable to workspaces. See documentation for definitions.
 ⍝    By default, 'dyalog' and unknown filetypes are not enabled.
 ⍝    Generally, place most used definitions first.
   suffix: ('aplf'  'apla'  'aplo'  'apln'  'json' 'txt')

 ⍝  Internal Runtime (hidden) Parameters
   _readParmFi: 0                      ⍝ 0 Zero: Haven't read .∆F yet. 1 afterwards.
   _fullPath:   ⍬                      ⍝ ⍬ Zilde: Generated from path and prefixes.
)
```

</details>

------------------------------------------------------------------------

</div>

</details>

</details>

# Appendices

<details>

<pSum> Show/Hide <em>Appendices</em></pSum>

## Appendix I: Un(der)documented Features

### ∆F Option for Dfn Source Code

If the [***dfn*** option](#f-option-details) is `¯1`, *equivalently*
`(dfn: ¯1)`<pNote>In simple terms, this option returns the character
representation of the *dfn* returned via the ***dfn*** option.
</pNote>,then **∆F** returns a character vector that contains the source
code for the *dfn* returned via `(dfn: 1)`. If ***verbose*** is also
set, newlines from `` `◇ `` are shown as visible `␤`. However, since
this option *returns* the code string, the ***verbose*** option won’t
also *display* the code string.

### ∆F Help’s Secret Variant

`∆F⍨'help'` has a secret variant: <pNote>*synonym:*
`∆F⍨'help-n'`.</pNote>`∆F⍨'help-narrow'`. With this variant, the help
session will start up in a narrower window *without* side notes. If the
user widens the window, the side notes will appear, as in the default
case: <pNote>*synonym:* `∆F⍨'help-wide'`.</pNote>`∆F⍨'help'`.

### ∆F’s Library Parameter Option: ‘parms’

Normally, ∆F £ibrary parameters are established when **∆F** and
associated libraries are loaded (*e.g.* via `]load ∆F -t=⎕SE`). After
editing the parameter file **./.∆F,** you may wish to update the active
parameters, while maintaining existing user £ibrary session objects,
which would otherwise be lost during a `]load` operation. For such an
update, use **∆F**’s `'parms'` option.

`∆F⍨ 'parms'` reads the user parameter file **./.∆F,** updates the
*£ibrary* parameters, returning them in alphabetical order along with
their values as a single character matrix. No current session objects
are affected.

## Appendix II: Python f‑strings

<div style="line-height: 1.3;">

  Python f-strings, introduced in Python 3.6, are a modern and elegant
way to format strings by embedding expressions directly inside string
literals. You create an f-string by prefixing a string with the letter
‘f’ or ‘F’, and then you can include any Python expression inside curly
braces within the string. When the string is evaluated, these
expressions are executed and their results are automatically converted
to strings and inserted at that position. <br>  For example, the Python
expression <strong>`f"The sum of {a} and {b} is {a + b}"`</strong> would
evaluate the addition and embed the result directly in the string. This
combination of simplicity, power, and performance has made f-strings the
preferred string formatting approach in modern Python code.

</div>

*See*
<pLink>https://docs.python.org/3/tutorial/inputoutput.html#formatted-string-literals</pLink>.

</div>

</div>

</details>

<!-- Put a set of navigation tools at a fixed position at the bottom of the Help screen
-->

<div class="doc-footer" style="text-align: left;padding-left:60px;">

<div class="button-container">

<input type="button" value="Back" class="button happy-button" onclick="history.back()"/>
<button id="toggleDetails" class="button happy-button" style="width: 115px;">Expand
All</button>    
<input type="button" class="button normal-button" value="Top" onclick="window.location='#top'"/>
<input type="button" class="button normal-button" value="Contents" onclick="window.location='#table-of-contents'"/>
<input type="button" class="button normal-button" value="Examples" onclick="window.location='#f-examples-a-primer'"/>
<input type="button" class="button normal-button" value="Syntax" onclick="window.location='#f-syntax-and-other-information'"/>
<input type="button" class="button normal-button" value="Appendices" onclick="window.location='#appendices'"/>
<input type="button" class="button normal-button" value="Bottom" onclick="window.location='#copyright'"/>    
<input type="button" class="button happy-button" value="Print" onclick="myPrint()">
<button onclick="closeWindowNow()" class="button warn-button">Close
Window</button>

</div>

</div>

------------------------------------------------------------------------

<br> <span id="copyright" style="font-family:cursive;"> Copyright
<big>©</big> ***COPYRIGHT*** Sam the Cat Foundation. \[Version
***VERSION***: ***TIMESTAMP***\] </span> <br>

</div>

<!-- End div for right-margin-bar -->

<!-- a hidden modal expression -->

<div id="pAlertMsg" class="pAlertMsg">

<span id="pAlertPfx" style="font-size: 40px;"> </span>
<span id="pAlertText"
style="font-weight: bold; font-size: 20px;font-family: Tahoma,  sans-serif;">
</span>

</div>

<!-- (C) ___COPYRIGHT___ Sam the Cat Foundation -->
