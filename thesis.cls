%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  UMass Thesis Class
%%
%%    Based on merging a version from Jamie Callan/Carla Brodley 
%%    with the Utah version that has also been floating around.
%%
%%      Makes adjustments to the basic REPORT document style
%%      Size selected in documentstyle must be 12pt
%%              (see thesis.tex in this directory for usage example)
%%
%%  Author: Tony Hosking, 1995
%%  Turned into a class file and tweaked by John Ridgway, 1997
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Identification part
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{thesis}[1997/04/11 v0.3 U.Mass. dissertation class]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initial code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Declaration of options
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newif\ifdouble@space
\newif\ifcondensed@frontmatter
\DeclareOption{10pt}{\def\@mysize{10pt}}
\DeclareOption{11pt}{\def\@mysize{11pt}}
\DeclareOption{12pt}{\def\@mysize{12pt}}
\DeclareOption{singlespace}{\double@spacefalse}
\DeclareOption{doublespace}{\double@spacetrue}
\DeclareOption{condensed}{\condensed@frontmattertrue\double@spacefalse}
\DeclareOption{uncondensed}{\condensed@frontmatterfalse}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Execution of options
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\ExecuteOptions{12pt,doublespace,uncondensed}
\ProcessOptions

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Package loading
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\LoadClass[\@mysize]{report}[1995/06/26]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Main code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\toc@section}{Chapter}

\newcounter{count@FrontMatter}
\newcounter{count@Chapter}
\newcounter{count@Appendix}
\newcounter{count@BackMatter}

\AtEndDocument{\immediate\write\@mainaux{\string\setcounter{count@FrontMatter}
    {\arabic{count@FrontMatter}}}}
\AtEndDocument{\immediate\write\@mainaux{\string\setcounter{count@Chapter}
    {\arabic{count@Chapter}}}}
\AtEndDocument{\immediate\write\@mainaux{\string\setcounter{count@Appendix}
    {\arabic{count@Appendix}}}}
\AtEndDocument{\immediate\write\@mainaux{\string\setcounter{count@BackMatter}
    {\arabic{count@BackMatter}}}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Handy-dandy utilities
%%
%% Define a linespacing command.

\def\ls#1{
  \renewcommand{\baselinestretch}{#1}
  \selectfont
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Major document structure, \frontmatter, \mainmatter, \appendix, \backmatter

\let\normal@chapter\@chapter %% save the chapter

\newcommand{\frontmatter}{
  \setcounter{secnumdepth}{-1}
  \renewcommand{\toc@section}{FrontMatter}
  \setcounter{count@FrontMatter}{0}
  }

\newcommand{\mainmatter}{
  \setcounter{secnumdepth}{5}
  \clearpage
  \pagenumbering{arabic}          % Arabic numbers from here on
  \raggedbottom
  \ifdouble@space\ls{2}\fi
  \renewcommand{\toc@section}{Chapter}
  \setcounter{count@Chapter}{0}
  }

\renewcommand{\appendix}{
  \setcounter{chapter}{0}%
  \setcounter{section}{0}%
  \renewcommand\@chapapp{\appendixname}%
  \renewcommand\thechapter{\@Alph\c@chapter}
  \renewcommand{\toc@section}{Appendix}
  \ifnum\value{count@Appendix}<2
    \let\@chapter\@onlyappendix
  \fi
  \setcounter{count@Appendix}{0}
  }

\newcommand{\backmatter}{
  \setcounter{secnumdepth}{5}
  \renewcommand{\@chapapp}{\chaptername}
  \renewcommand{\toc@section}{BackMatter}
  \let\@chapter\normal@chapter
  \setcounter{count@BackMatter}{0}
  }

\def\@onlyappendix[#1]#2{
  \@schapter{#2}
  \addcontentsline{toc}{OnlyAppendix}{\MakeUppercase{#1}}
  }


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Chapter/Appendix related stuff

\newcommand{\unnumberedchapter}[2][]{
  \def\@tempa{#1}
  \def\@tempb{}
  \ifx\@tempa\@tempb
    \def\@tempc{#2}
  \else
    \def\@tempc{#1}
  \fi
  \chapter*{#2}
  \addcontentsline{toc}{\toc@section}{\MakeUppercase{\@tempc}}
}

%% redefine @chapter to change toc entries
\def\@chapter[#1]#2{
  \ifnum \c@secnumdepth >\m@ne
    \refstepcounter{chapter}%
    \typeout{\@chapapp\space\thechapter.}%
    \addcontentsline{toc}{\toc@section}
                         {\protect\numberline{\thechapter}\MakeUppercase{#1}}%
  \else
    \addcontentsline{toc}{\toc@section}{\MakeUppercase{#1}}%
  \fi
  \chaptermark{#1}%
  \addtocontents{lof}{\protect\addvspace{10\p@}}%
  \addtocontents{lot}{\protect\addvspace{10\p@}}%
  \if@twocolumn
    \@topnewpage[\@makechapterhead{#2}]%
  \else
    \@makechapterhead{#2}%
    \@afterheading
  \fi
  \stepcounter{count@\toc@section}
  }

\renewcommand\chapter{
  \if@openright\cleardoublepage\else\clearpage\fi
  \thispagestyle{plain}%
  \@afterindenttrue
  \global\@topnum\z@
  \secdef\@chapter\@schapter
  }
\renewcommand{\@makechapterhead}[1]{    % Heading for \chapter command
  \vspace*{30\p@}                       % Space at top of text page.
  \begin{center}\large\bfseries
    \ifnum \c@secnumdepth >\m@ne
      \ls{2}
      \MakeUppercase\@chapapp\ \thechapter % 'CHAPTER' and number.
      \par\nobreak
    \fi
  \MakeUppercase{#1}
  \end{center}
  \par\nobreak                          % TeX penalty to prevent page break.
  \vskip 24\p@                          % Space between title and text.
  }

\let\base@schapter\@schapter
\def\@schapter#1{
  \base@schapter{#1}
  \stepcounter{count@\toc@section}
  }

\renewcommand{\@makeschapterhead}[1]{   % Heading for \chapter* command
  \vspace*{30\p@}                       % Space at top of page.
  \begin{center}
    \large\bfseries                        % Title.
    \MakeUppercase{#1}\par
  \end{center}
  \nobreak                             % TeX penalty to prevent page break.
  \vskip 24\p@                          % Space between title and text.
  }


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Tweak penalties
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%\hyphenpenalty=400
%%\exhyphenpenalty=400

\clubpenalty=10000              % 'Club line'  at bottom of page.
\widowpenalty=10000             % 'Widow line' at top of page.
\displaywidowpenalty=3000       % Math display widow line.
\predisplaypenalty=3000         % Breaking before a math display.
\postdisplaypenalty=2000        % Breaking after a math display.

%% Do these need tweaking too?
%%\interlinepenalty               % Breaking at a line within a paragraph.
%%\brokenpenalty                  % Breaking after a hyphenated line.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Tweak table of contents
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\thetocindent{-1}
\newif\if@seenChapter
\newif\if@seenAppendix
\newif\if@seenBackMatter
\@seenChapterfalse
\@seenAppendixfalse
\@seenBackMatterfalse

\newlength{\thesis@pnumwidth}
\setlength{\thesis@pnumwidth}{0pt}
\settowidth{\thesis@pnumwidth}{\textbf{999}}

\newlength{\thesis@tocrmarg}
\setlength{\thesis@tocrmarg}{0pt}
\settowidth{\thesis@tocrmarg}{\textbf{M999}}

\renewcommand{\@pnumwidth}{\thesis@pnumwidth}
\renewcommand{\@tocrmarg}{\thesis@tocrmarg}
%\renewcommand{\@pnumwidth}{0\p@}
%\renewcommand{\@tocrmarg}{0\p@}

\newcommand{\l@FrontMatter}[2]{
  \addpenalty{-\@highpenalty}
  \addvspace{\baselineskip}
  \@dottedtocline{0}{0.0em}{1.5em}{\bfseries #1}{\bfseries #2}
  }

\newcommand{\l@Chapter}[2]{
  \addpenalty{-\@highpenalty}
  \addvspace{\baselineskip}
  \if@seenChapter\else
    \addvspace{2\baselineskip}
    \parindent\z@ {\bfseries \chaptername} \par
    \addvspace{\baselineskip}
    \@seenChaptertrue
  \fi
  \@dottedtocline{0}{0.0em}{1.5em}{\bfseries#1}{\bfseries#2}
  }

\newcommand{\l@Appendix}[2]{
  \addpenalty{-\@highpenalty}
  \addvspace{\baselineskip}
  \if@seenAppendix\else
    \addvspace{2\baselineskip}
    \parindent\z@ {\bfseries \appendixname} \par
    \addvspace{\baselineskip}
    \@seenAppendixtrue
  \fi
  \@dottedtocline{0}{0.0em}{1.5em}{\bfseries #1}{\bfseries #2}
  }

\newcommand{\l@OnlyAppendix}[2]{
  \addpenalty{-\@highpenalty}
  \addvspace{2\baselineskip}
  \parindent\z@
  \@dottedtocline{0}{0.0em}{1.5em}{\bfseries
    \MakeUppercase{\appendixname}: #1}{\bfseries #2}
  }

\newcommand{\l@BackMatter}[2]{
  \addpenalty{-\@highpenalty}
  \addvspace{\baselineskip}
  \if@seenBackMatter\else
    \addvspace{2\baselineskip}
    \@seenBackMattertrue
  \fi
  \@dottedtocline{0}{0.0em}{1.5em}{\bfseries #1}{\bfseries #2}
  }

%\renewcommand{\@pnumwidth}{1.7em}
%\renewcommand{\@tocrmarg}{2.7em}


\let\@basedottedtocline\@dottedtocline
\renewcommand{\@dottedtocline}[5]{
  \ifnum #1>\c@tocdepth
  \else
    \ifnum \thetocindent = #1 \else
      \def\thetocindent{#1}
      \ifdouble@space\addvspace{\topskip}\fi
    \fi
    \@basedottedtocline{#1}{#2}{#3}{#4}{#5}
  \fi
  }


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Tweak lists of tables and figures
%%
\newlength{\tablenumberwidth}
\setlength{\tablenumberwidth}{2.3em}

\ifcondensed@frontmatter
  \renewcommand{\listoffigures}{}
\else
  \renewcommand{\listoffigures}{%
    \if@twocolumn
      \@restonecoltrue\onecolumn
    \else
      \@restonecolfalse
    \fi
    \chapter{\listfigurename
      \@mkboth{\MakeUppercase\listfigurename}%
              {\MakeUppercase\listfigurename}}%
    \@starttoc{lof}%
    \if@restonecol\twocolumn\fi
    }
\fi
\renewcommand{\l@figure}[2]{
  \vspace{\baselineskip}
  \@basedottedtocline{1}{1.5em}{\tablenumberwidth}{#1}{#2}
  }

\ifcondensed@frontmatter
  \renewcommand{\listoftables}{}
\else
  \renewcommand{\listoftables}{%
    \if@twocolumn
      \@restonecoltrue\onecolumn
    \else
      \@restonecolfalse
    \fi
    \chapter{\listtablename
      \@mkboth{%
          \MakeUppercase\listtablename}{\MakeUppercase\listtablename}}%
    \@starttoc{lot}%
    \if@restonecol\twocolumn\fi
    }
\fi
\let\l@table\l@figure


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Page layout -- as required
%%

\setlength{\oddsidemargin}{0.5truein}  % binding margin at least 1.5in
\setlength{\evensidemargin}{0.5truein} % same as odd side
\setlength{\textwidth}{6.0truein}      % 6in wide typing area
\setlength{\topmargin}{-0.5truein} % page numbers at top of page 0.5in from top
\setlength{\headheight}{0.2truein} % room for header
\setlength{\headsep}{0.3truein}    % header 0.3in from body, body 1in from top
\setlength{\textheight}{9.0truein} % 9in high typing area
\setlength{\footskip}{0.5truein}   % footer 0.5in from body, 0.5in from bottom


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Added commands and environments for front matter
%%

\def\@degree{Doctor of Philosophy}
\def\@degreeabbrv{Ph.D.}
\newcommand{\degree}[2]{\gdef\@degree{#1} \gdef\@degreeabbrv{#2}}
\def\copyrightyear#1{\gdef\@copyrightyear{#1}}
\def\bachelors#1#2{\gdef\@bachelors{#1, \uppercase{#2}}}
\def\masters#1#2{\gdef\@masters{#1, \uppercase{#2}}}
\def\committeechair#1{\gdef\@committeechair{#1}}
\def\firstreader#1{\gdef\@firstreader{#1}}
\def\secondreader#1{\gdef\@secondreader{#1}}
\newif\ifthird
\thirdfalse
\def\thirdreader#1{\gdef\@thirdreader{#1}\thirdtrue}
\newif\iffourth
\fourthfalse
\def\fourthreader#1{\gdef\@fourthreader{#1}\fourthtrue}
\newif\iffifth
\fifthfalse
\def\fifthreader#1{\gdef\@fifthreader{#1}\fifthtrue}
\newif\ifsixth
\sixthfalse
\def\sixthreader#1{\gdef\@sixthreader{#1}\sixthtrue}
\def\departmentchair#1{\gdef\@departmentchair{#1}}
\def\departmentname#1{\gdef\@departmentname{#1}}

\ifcondensed@frontmatter
  \renewcommand{\maketitle}{
    \begin{center}
      \pagenumbering{roman}
      \null
      \textbf{\uppercase\expandafter{\@title}} \par % Title must be all caps.
      A Dissertation Presented \par
      by \par
      \uppercase\expandafter{\@author} \par
      \ls{1}
      Submitted to the Graduate School of the \par
      University of Massachusetts Amherst in partial fulfillment \par
      of the requirements for the degree of \par
      \par
      \uppercase\expandafter{\@degree} \par \par
      \@date \par \par
      \@departmentname \par \par
    \end{center}%
    \setcounter{footnote}{0}%      % Footnotes start at zero again.
    \let\thanks\relax
    \let\maketitle\relax
    }
  \else
  \renewcommand{\maketitle}{
    \begin{titlepage}
      \pagenumbering{roman}
      \null
      \vfil
      \vskip 60\p@                  % To adjust centering.
      \begin{center}%
        \textbf{\uppercase\expandafter{\@title}} \par % Title must be all caps.
        \vfill                      % Vertical space after title.
        \ls{2}
        A Dissertation Presented \par
        \par
        by \par
        \par
        \uppercase\expandafter{\@author}
        \vfill
        \ls{1}
        Submitted to the Graduate School of the \par
        University of Massachusetts Amherst in partial fulfillment \par
        of the requirements for the degree of \par
        \par
        \ls{2}
        \uppercase\expandafter{\@degree} \par \par
        \@date \par \par
        \@departmentname \par \par
      \end{center}\par
    \end{titlepage}%
    \setcounter{footnote}{0}%      % Footnotes start at zero again.
    \setcounter{page}{2}
    \let\thanks\relax
    \let\maketitle\relax
    }
  \fi

\ifcondensed@frontmatter
  \newcommand{\copyrightpage}{
    \begin{minipage}{.95\textwidth}
      \begin{center}
        \copyright\ \@copyrightyear\ \@author \par
      \end{center}
    \end{minipage}
    }
  \else
  \newcommand{\copyrightpage}{
    \clearpage
    \thispagestyle{empty}
    \rule{0in}{4.25in}
    \noindent
    \begin{minipage}{.95\textwidth}
      \begin{center}
        \copyright\ \@copyrightyear\ \@author \par
      \end{center}
    \end{minipage}
    \rule{0in}{4.2in}
    }
  \fi

\ifcondensed@frontmatter
  \newcommand{\signaturepage}{
    \vspace{6ex}
    \begin{center}
      Committee will be listed as: \par
      \@committeechair, Chair \par
      \@firstreader, Member \par
      \@secondreader, Member \par
      \ifthird
        \@thirdreader, Member \par
      \fi
      \iffourth
        \@fourthreader, Member \par
      \fi
      \iffifth
        \@fifthreader, Member \par
      \fi
      \ifsixth
        \@sixthreader, Member \par
      \fi
    \end{center}
    }
  \else
  \def\signaturepage{
    \clearpage
    \thispagestyle{empty}
    \null
    \vfil
    \begin{center}
      \textbf{\uppercase\expandafter{\@title}} \par
      \vfill
      A Dissertation Presented \par
      \vskip 1em
      by \par
      \vskip 1em
      \uppercase\expandafter{\@author} \par
    \end{center}
    \vfill
    \begin{flushleft}
      Approved as to style and content by: \par
      \vskip 0.4in
      \rule{0.55\textwidth}{0.5pt} \par
      \@committeechair, Chair \par
      \vskip 0.35in
      \rule{0.55\textwidth}{0.5pt} \par
      \@firstreader, Member \par
      \vskip 0.35in
      \rule{0.55\textwidth}{0.5pt} \par
      \@secondreader, Member \par
      \ifthird
      \vskip 0.35in
      \rule{0.55\textwidth}{0.5pt} \par
      \@thirdreader, Member \par
      \fi
      \iffourth
      \vskip 0.35in
      \rule{0.55\textwidth}{0.5pt} \par
      \@fourthreader, Member \par
      \fi
      \iffifth
      \vskip 0.35in
      \rule{0.55\textwidth}{0.5pt} \par
      \@fifthreader, Member \par
      \fi
      \ifsixth
      \vskip 0.35in
      \rule{0.55\textwidth}{0.5pt} \par
      \@sixthreader, Member \par
      \fi
    \end{flushleft}
    \newlength{\lenguide}
    \settowidth{\lenguide}{\rule{0.55\textwidth}{0.5pt}}
    \vskip 0.2in
    \begin{flushright}
      \rule{0.55\textwidth}{0.5pt} \par
      \parbox[t]{\lenguide}{\@departmentchair, Department Chair \par
        \@departmentname}
    \end{flushright}
    }
  \fi

%%
%% Added environments
%%

\ifcondensed@frontmatter
  \newenvironment{dedication}{
    \vspace{6ex}
    \begin{quotation}}
    {\par\end{quotation}}
\else
  \newenvironment{dedication}{
    \clearpage\null\vfil
    \thispagestyle{empty}
    \ifdouble@space \ls{2} \else \ls{1} \fi
    \vfill
    \begin{quotation}}
    {\par\end{quotation}\vfill\vfil\null}
\fi

\ifcondensed@frontmatter
  \renewenvironment{abstract}{
    \vspace{6ex}
    \begin{center}
      \textbf{\uppercase\expandafter{\abstractname}} \par
      Degrees will be listed as: \par
      \@bachelors \par
      \@masters \par
      \@degreeabbrv, UNIVERSITY OF MASSACHUSETTS AMHERST \par
      Directed by: Professor \@committeechair \par
    \end{center} \par \indent 
    \ifdouble@space\else\ls{2}\fi}
  {\par\vfil\null}
\else
  \renewenvironment{abstract}{
    \clearpage
    \pagestyle{plain}
    \chapter{\uppercase\expandafter{\abstractname}}
    \begin{center}
      \ls{2}
      \textbf{\uppercase\expandafter{\@title}} \par
      \uppercase\expandafter{\@date} \par
      \uppercase\expandafter{\@author} \par
      \@bachelors \par
      \@masters \par
      \@degreeabbrv, UNIVERSITY OF MASSACHUSETTS AMHERST \par
      Directed by: Professor \@committeechair \par
    \end{center} \par \indent 
    \ifdouble@space\else\ls{2}\fi}
  {\par\vfil\null}
\fi


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Tweak chapter headings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%% Text heading tweaks
%%

\setcounter{secnumdepth}{5}

\ifcondensed@frontmatter
  \setcounter{tocdepth}{0}
\else
  \setcounter{tocdepth}{3}
\fi


\renewcommand{\section}{
  \@startsection{section}{1}{\z@}
                {4.5ex \@plus 1ex \@minus .2ex}
                {2.3ex \@plus .2ex}
                {\normalfont\large\bfseries}}

\renewcommand{\subsection}{
  \@startsection{subsection}{2}{\z@}%
                {3.25ex\@plus 1ex \@minus .2ex}%
                {1.5ex \@plus .2ex}%
                {\normalfont\normalsize\bfseries}}

\renewcommand{\subsubsection}{
  \@startsection{subsubsection}{3}{\z@}%
                {3.25ex\@plus 1ex \@minus .2ex}%
                {1.5ex \@plus .2ex}%
                {\normalfont\normalsize}}

\renewcommand{\paragraph}{
  \@startsection{paragraph}{4}{\z@}%
                {3.25ex \@plus1ex \@minus.2ex}%
                {-1em}%
                {\normalfont\normalsize\bfseries}}

\renewcommand{\subparagraph}{
  \@startsection{subparagraph}{5}{\parindent}%
                {3.25ex \@plus1ex \@minus .2ex}%
                {-1em}%
                {\normalfont\normalsize\bfseries}}


%%
%% Fix captions
%%

\setlength\abovecaptionskip{\baselineskip}
\setlength\belowcaptionskip{\baselineskip}

\long\def\@makecaption#1#2{%
  \addvspace\abovecaptionskip
  \ls{1}
  \sbox\@tempboxa{\textbf{#1.} #2}%
  \ifdim \wd\@tempboxa >\hsize
    \textbf{#1.} #2\par
  \else
    \global \@minipagefalse
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \addvspace\belowcaptionskip
  }


%%
%% Default spacing of tabular environment to single
%%
\let\base@tabular\tabular
\renewcommand{\tabular}[2][]{
  \ls{1}
  \base@tabular[#1]{#2}}

%%
%% Fix quote and quotation environments
%%
\renewenvironment{quotation}{
  \list{}{
    \listparindent 1.5em
    \itemindent    \listparindent
    \rightmargin   \leftmargin
    \parsep        \z@ \@plus\p@
    }
  \item[]\ls{1}}
  {\endlist}
\renewenvironment{quote}{
  \list{}{\rightmargin\leftmargin}\item[]\ls{1}}
         {\endlist}


%%
%% Fix footnotes -- double spacing between footnotes, single spacing within
%%     footnotes is what is required.

\newlength{\thesis@basefootnotesep}
\newlength{\thesis@baseskipfootins}

\setlength{\thesis@basefootnotesep}{\footnotesep}
\setlength{\thesis@baseskipfootins}{\skip\footins}

\ifdouble@space
  \setlength{\footnotesep}{2\thesis@basefootnotesep}
  \setlength{\skip\footins}{2\thesis@baseskipfootins}
\fi

%\let\thesis@basefootnote\footnote
%\def\footnote{\renewcommand{\baselinestretch}{1}\thesis@basefootnote}

\let\base@footnotetext\@footnotetext
\long\def\@footnotetext{%
  \renewcommand{\baselinestretch}{1}%
  \base@footnotetext%
}

%%
%% Fix the bibliography
\renewenvironment{thebibliography}[1]
     {\unnumberedchapter{\bibname
        \@mkboth{\MakeUppercase\bibname}{\MakeUppercase\bibname}}%
      \list{\@biblabel{\@arabic\c@enumiv}}%
           {\settowidth\labelwidth{\@biblabel{#1}}%
            \leftmargin\labelwidth
            \advance\leftmargin\labelsep
            \if@openbib
              \advance\leftmargin\bibindent
              \itemindent -\bibindent
              \listparindent \itemindent
              \parsep \z@
            \fi
            \usecounter{enumiv}%
            \let\p@enumiv\@empty
            \renewcommand\theenumiv{\@arabic\c@enumiv}}%
      \if@openbib
        \renewcommand\newblock{\par}%
      \else
        \renewcommand\newblock{\hskip .11em \@plus.33em \@minus.07em}%
      \fi
      \sloppy\clubpenalty4000\widowpenalty4000%
      \ls{1}
      \sfcode`\.=\@m}
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \endlist}