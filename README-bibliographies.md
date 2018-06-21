I made this fork of the project because I had to do some hacking to make the bibliography work at all, and I ended up spending non-trivial time to make it look pretty. There's now a tree of reasonable options to use, documented here tutorial-style.

#### TL;DR (summary)

  1. I recommend switching from `umassthesis.bst` to the latest version of [`ACM-Reference-Format.bst`](https://github.com/borisveytsman/acmart/blob/master/ACM-Reference-Format.bst). See [Recommended way to use natbib](#natbibACM), below, for instructions.
  2. If you prefer to use biblatex, there's a [template](#biblatex), there's an option for IEEE style, and there's a hand-made assortment of custom formatting commands.
  3. To browse the inputs and outputs, look at the *.tex and *.pdf files in `examples/bib-examples`.


# Bibliography technologies

One could, in theory, hand-edit one's \bibitem entries and stick them in a \thebibliography environment, but typically, we use infrastructure to generate a .bbl file containing exactly those LaTeX commands.

In the typical LaTex workflow (the app I use is TeXShop), one runs "latex, bibtex, latex, latex" to generate the source file, generate the bibliography, and then interlace them with the citations fixed. That "bibtex" step takes your .bib file (containing all the BibTeX entries) and creates a .bbl file from it (containing \bibitem entries for everything the source document cites).

To do anything fancy, people will often want to use either natbib or biblatex (** != bibtex **). Both are LaTex packages. Very briefly, natbib lets you \cite{} things in varying forms, e.g., mentioning just the author's name or year; you might recall using its commands such as \citet{}, \citep{}, or \citeauthor{}. Picking up where natbib leaves off, biblatex provides all of that plus lets you format the bibliography entries to your heart's content. (To clarify the distinction between a citation style and a bibliography style, see the examples in [this natbib guide](http://www.geocities.ws/kijoo2000/bibtex_guide.pdf).)

[This StackExchange page](https://tex.stackexchange.com/questions/25701/bibtex-vs-biber-and-biblatex-vs-natbib) describes the relationships among all these technologies and more, also in [diagram form](https://tex.stackexchange.com/a/299286). ("And more" includes a fact I'm glossing over here: that biblatex is not just a package; it's more of an upgrade to the whole BibTeX system.)

In terms of files used for custom styles: \*.cls (with its supporting files *.clo) define the \documentclass for a document; \*.sty files (not present in umassthesis) can [provide additional customization](https://tug.org/pracjourn/2005-3/asknelly/nelly-sty-&-cls.pdf); and a \*.bst file defines a format for the bibliography. This directory contains a `umassthesis.cls` (for the main doc) and a `umassthesis.bst` (for the bibliography).


# Using natbib

I wanted to use natbib's \citeauthor{}. The file `umassthesis.cls` said it was compatible with natbib, but in practice the whole setup wasn't.

### The problem

If you want to use numeric labels on your citations (e.g., [8]), you're in luck: that's exactly what the file `umassthesis.bst` stores in the .bbl file. But if you then want to access the author information via \citeauthor{}, you're out of luck: that info has not been stored in the .bbl file! **In other words, `umassthesis.bst` isn't compatible with natbib's authoryear usage.**

* If you try to \usepackage{natbib} in its default mode of authoryear, then use the command \citeauthor{}, it gives a compile error because the .bst file is in numeric mode.
* If you \usepackage[numbers]{natbib}, it compiles, but the \citeauthor{} command leaves an unresolved reference in the pdf that looks like "(author?)".
  
### Solution approach(es)

**Goal: Make umassthesis.bst compatible with natbib.**

The natbib package comes with drop-in replacements for many of the standard .bst files. Including for `abbrv.bst`, which is what the text in umassthesis.bst claims is its origin.

(Solution 0: I originally did a hacky thing (*not* checked in) in which I took the diff between abbrv.bst and abbvnat.bst, and manually applied that [patch] to umassthesis.bst. This "worked," but probably changed some functionality, because `umassthesis.bst` is not all that similar to `abbrv.bst`.)

But check this out! **Actually, `umassthesis.bst` is just 7 lines different from the standard distribution's `acm.bst`.** (That file is, in fact, the origin of that line about abbrv.bst.) The file acm.bst was last updated in 1988 (30 years ago), and our 7 lines of difference were inserted in 1992. While that's incredible longevity for a file, it's not a compelling argument for us to stick with it. (And no, I didn't find a natbib implementation of acm.bst.)

The ACM itself has long moved on. [Its current template](https://www.acm.org/publications/proceedings-template) was released in 2017 and remains under active development ([github repo here](https://github.com/borisveytsman/acmart)). Plus its formatting of references is well-documented: both [how the .bib entries should be stored](https://www.acm.org/publications/authors/bibtex-formatting) and [how the printed bibliography entries should come out looking](https://www.acm.org/publications/authors/reference-formatting).

**The "obvious" solution, then, is to plug in the current [`ACM-Reference-Format.bst`](https://github.com/borisveytsman/acmart/blob/master/ACM-Reference-Format.bst) in place of our `umassthesis.bst`.**

It turns out that ACM-Reference-Format.bst is only designed to be used in tandem with acmart.cls. The latter contained some commands we need (regarding natbib and hyperref). These have now been extracted into the header of the example file.


### [Recommended way to use natbib](id:natbibACM)
* Obtain the file `ACM-Reference-Format.bst` -- either from this repo, or get a fresher copy [from the source](https://github.com/borisveytsman/acmart/blob/master/ACM-Reference-Format.bst).
* Put it in the directory where the top-level .tex file is compiled.
* Follow the example of `examples/bib-examples/natbibdoc.tex`:
  * Reference this .bst, not umassthesis, in the \bibliographystyle{} command.
  * In the header, call the packages natbib and hyperref with the options shown.
* (Optional/later) Rename the file to `ACM-Reference-Format-UMass.bst` and configure its formatting. It differs from our old .bst in several ways (besides supporting URLs) that one might want to tweak: 
  * As discussed [in this thread](https://github.com/borisveytsman/acmart/issues/60): Paper titles are capitalized exactly as in the .bib file, rather than being transformed to "sentence case." (Existing comments in the .bst file hint at how to change that.) Also, the month is omitted from conference paper entries.
  * "pp." removed; names are printed "first last"; etc.


# [Using biblatex](id:biblatex)
As the [StackExchange page](https://tex.stackexchange.com/a/25702) from earlier points out, the term "bibtex" is ambiguous because it can refer to: 

* Your .bib file and entries within it
* The program you run to process those entries into a .bbl file.

The [BibLaTeX system](https://ctan.org/pkg/biblatex) uses those same .bib entries (actually, a superset of them), but it uses a different program to process the entries. With biblatex, [the LaTeX workflow becomes](https://tex.stackexchange.com/questions/13509/biblatex-in-a-nutshell-for-beginners) "latex \<biblatex> latex". 

Confusingly, there are two choices of back-end engines for that \<biblatex> command: bibtex (the command we used to use) and biber (the default). I used bibtex because I'm lazy (specifically, because I didn't want to stop using the "run bibtex" button inside TeXShop). That limits the functionality. Generally, biber is recommended.

The file `examples/bib-examples/biblatexdoc.tex` can be compiled (using the above commands) to create the file `examples/bib-examples/biblatexdoc-orig.pdf`.

If you prefer [IEEE](http://mirrors.ctan.org/tex-archive/macros/latex/contrib/biblatex-contrib/biblatex-ieee/biblatex-ieee.pdf) style over biblatex's default, `biblatexdoc.tex` shows how to switch to that. (There doesn't seem to be an ACM style file for biblatex.)

### Customized bibliography entries

(Caveat: here I'm in "hacking" territory--I'm showing some things I put together, but I have only a sketchy idea of how the system works, so don't treat these as definitive.)

Included in `bib-examples/` is the formatting style I put together for my thesis. It's not as verbose as the defaults, and I especially focused on conference articles. To use it, uncomment the line of `biblatexdoc.tex` that says "\input{biblatex-myheaders}". 

In that file `biblatex-myheaders.tex` is code to do the following: 

* "In <proceedings>", not "In: <proceedings>", and don't print "In" for journals
* Try to disallow entries from breaking across pages
* Editor: Only print editors' names if there's no author
* URLs: Don't print DOI + URL. Specifically, print no more than one of doi, eprint, or url, whichever comes first.
* Experiment with name order (kept default version, "first-last")
* Titles:
  * Remove quotes from titles for inproceedings and some others
  * Put conference paper titles into sentence case
  * Put all other titles into a real title case  
  * N.B. For people whose bib files stored the exact capitalization they wanted, not protected by braces--this is the protocol used by the sample bib file from ACM--these commands will lose info. (On the other hand, for people who don't pay attention to capitalization apart from protecting proper nouns, these will help make entries uniform.)
* Publisher: For inproceedings, omit publisher's location and date.
* Volume:
  * Change formatting of "volume, issue" to "\italics{journal name, volume}(issue)"
  * Omit the string "vol." from most articles and chapters

* Change the formatting of conference proceedings to something more sensible. Try for this:  
         `<authors>. <title>. In <eventtitleaddon>: <booktitle> (<conference location, date>), <publisher> <series> <volume> (<number>), pp. <pages>. <doi or url>.` (With the "publisher...," section only printed when there's a series.)
    * **Important change: instead of storing the conference series (e.g., KDD '09) in the "series" field, I'm keeping it in the "eventtitleaddon" field. ** Why:
    	1. Using two fields gives us a way to handle Springer's LNCS series, which is where many conference proceedings are published.
    	2. Using "series" for the conference series doesn't make a lot of sense, since (a) the default settings don't always print it near the title, (b) a true series shouldn't be a different string every year.
    * In the example .bib file, I added 3 entries that use my "eventitleaddon" field: see those by Barbieri, Christen, and Lewis. The other (pre-existing) conference entries end up looking a bit funny.



### Where to find documentation, examples, etc.
* [The current reference manual](http://mirrors.ctan.org/macros/latex/contrib/biblatex/doc/biblatex.pdf).

* To customize (beyond the built-in flags), one can put code into the preamble of the LaTeX doc. I believe this code is a combination of LaTeX and biblatex-specific commands.
  * A lot of the syntax is documented in the manual's sections 3.11 (User Guide: Formatting Commands), 4.2 (Author Guide: Bibliography Styles), and 4.4 (Author Guide: Data Interface).
  * [Here's a useful post](https://tex.stackexchange.com/questions/12806/guidelines-for-customizing-biblatex-styles) on getting started with customization.  
 
* Tutorials (found linked from [StackExchange post on "biblatex in a nutshell"](https://tex.stackexchange.com/questions/13509/biblatex-in-a-nutshell-for-beginners)):
  * [Paul Stanley's comprehensive tutorial](https://github.com/PaulStanley/biblatex-tutorial/releases) -- more user-friendly than the manual, and gets down into nitty-gritty details in Chapters 3 and 10
  * [Local guide from University of Oslo](http://dag.at.ifi.uio.no/public/doc/biblatex-guide.pdf) -- mostly covers the manual's options

* The biblatex distribution:
  * There's probably a copy inside your system's latex distribution (which on my machine I could find by running "texconfig conf | grep TEXMFMAIN" --> `/usr/local/texlive/2015/texmf-dist/`). Or use [the one online](https://ctan.org/tex-archive/macros/latex/contrib/biblatex).
  * Source code is under `tex/latex/biblatex/`. 
    * LaTeX code in biblatex*.sty and biblatex.def. biblatex.sty is bare-bones and just calls biblatex1.sty (for the bibtex engine) or biblatex2.sty (for the biber engine). These (respectively) define the commands used by biblatex, such as \DeclareFieldFormat.
    * Inside that, standard bibliography styles defined under `bbx/` (e.g., `bbx/standard.bbx`).
    * And citation styles are defined under `cbx/`.
  * Some biblatex examples accompany the manual, located in the distribution under `doc/latex/biblatex/examples/`.


 
  

