I made this fork of the project because I had to do some hacking to make the bibliography work at all, and I ended up spending non-trivial time to make it look pretty. There's now a tree of reasonable options to use--documented here tutorial-style.

# Bibliography technologies

One could, in theory, hand-edit one's \bibitem entries and stick them in a \thebibliography environment, but typically, we use infrastructure to generate a .bbl file containing exactly those LaTeX commands.

In the typical LaTex workflow (the app I use is TeXShop), one runs "latex, bibtex, latex, latex" to generate the source file, generate the bibliography, and then interlace them with the citations fixed. That "bibtex" step takes your .bib file (containing all the BibTeX entries) and creates a .bbl file from it (containing \bibitem entries for everything the source document cites).

To do anything fancy, people will often want to use either natbib or biblatex (** != bibtex **). Both are LaTex packages. Very briefly, natbib lets you \cite{} things in varying forms, e.g., mentioning just the author's name or year; you might recall using its commands such as \citet{}, \citep{}, or \citeauthor{}. Picking up where natbib leaves off, biblatex includes all of that plus lets you format the bibliography entries to your heart's content.

[This StackExchange page](https://tex.stackexchange.com/questions/25701/bibtex-vs-biber-and-biblatex-vs-natbib) describes the relationships among all these entities and more, also in [diagram form](https://tex.stackexchange.com/a/299286).

In terms of custom styles: \*.cls (with its supporting files *.clo) define the \documentclass for a document; \*.sty files (not present in umassthesis) can [provide additional customization](https://tug.org/pracjourn/2005-3/asknelly/nelly-sty-&-cls.pdf); and a \*.bst file defines a format for the bibliography. This directory contains a `umassthesis.cls` (for the main doc) and a `umassthesis.bst` (for the bibliography).


# Using natbib

I wanted to use natbib's \citeauthor{}. The file umassthesis.cls said it was compatible with natbib, but in practice the whole setup wasn't.

### The problem

If you want to use numeric labels on your citations (e.g., [8]), you're in luck: that's exactly what the file `umassthesis.bst` stores in the .bbl file. But if you then want to access the author information via \citeauthor{}, you're out of luck: that info has not been stored in the .bbl file! **In other words, `umassthesis.bst` isn't compatible with natbib's authoryear usage.**

* If you try to \usepackage{natbib} in its default mode of authoryear, then use the command \citeauthor{}, it gives a compile error because the .bst file is in numeric mode.
* If you \usepackage[numbers]{natbib}, it compiles, but the \citeauthor{} command leaves an unresolved reference in the pdf that looks like "(author?)".
  
### Solution approach(es)

**Goal: Make umassthesis.bst compatible with natbib.**

The natbib package comes with drop-in replacements for many of the standard .bst files. Including for `abbrv.bst`, which is what the text in umassthesis.bst claims as its origin.

(Solution 0: I first did a hacky thing (*not* checked in) in which I took the diff between abbrv.bst and abbvnat.bst, and manually applied that [patch] to umassthesis.bst. This "worked," but probably changed some functionality, because `umassthesis.bst` is not all that similar to `abbrv.bst`.)

But check this out! **Actually, `umassthesis.bst` is just 7 lines different from the standard distribution's `acm.bst`.** (That file is, in fact, the origin of that line about abbrv.bst.) The file acm.bst was last updated in 1988 (30 years ago), and our 7 lines of difference were inserted in 1992. While that's incredible longevity for a file, it's not a compelling argument for us to stick with it. (And no, I didn't find a natbib implementation of acm.bst.)

The ACM itself has long moved on. [Its current template](https://www.acm.org/publications/proceedings-template) was released in 2017 and remains under active development ([github repo here](https://github.com/borisveytsman/acmart)). Plus its formatting of references is well-documented: both [how the .bib entries should be stored](https://www.acm.org/publications/authors/bibtex-formatting) and [how the printed bibliography entries should come out looking](https://www.acm.org/publications/authors/reference-formatting).

**The "obvious" solution, then, is to plug in the current [`ACM-Reference-Format.bst`](https://github.com/borisveytsman/acmart/blob/master/ACM-Reference-Format.bst) in place of our `umassthesis.bst`.**

It turns out that ACM-Reference-Format.bst is only designed to be used in tandem with acmart.cls. The latter contains some commands we need (regarding natbib and hyperref). These have been extracted into the header of the example file, next.


### Best way to use natbib
* Obtain the file `ACM-Reference-Format.bst` -- either from this repo, or get a fresher copy [from the source](https://github.com/borisveytsman/acmart/blob/master/ACM-Reference-Format.bst).
* Put it in the directory where the top-level .tex file is compiled.
* (Optional) Rename it to ACM-Reference-Format-UMass and configure its formatting. It differs from our old .bst in several ways (besides supporting URLs) that one might want to tweak: 
  * As discussed [in this thread](https://github.com/borisveytsman/acmart/issues/60): Paper titles are capitalized exactly as in the .bib file, rather than being transformed to "sentence case." (Comments in the .bst file hint at how to change that.) Also, the month is omitted from conference paper entries.
  * "pp." removed; names are printed "first last"; etc.
* Follow the example of `examples/bib-examples/natbibdoc.tex`:
  * Reference this .bst, not umassthesis, in the \bibliographystyle{} command.
  * In the header, call the packages natbib and hyperref with the options shown.