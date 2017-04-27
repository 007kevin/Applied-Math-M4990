%% truthesis.cls
%% LaTeX class for typesetting BSc Honors theses.
%% Richard Taylor, Thompson Rivers University, 14 Sept. 2007
%%
%% changelog:
%% 17.Sept.07   - first draft... some code borrowed from UW's thesis91e.cls
%%                by Andrej Brodnik, ABrodnik@UWaterloo.CA
%%
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{truthesis}[2007/09/14 1.0 Thompson Rivers University thesis class]

% provide handler for the 'guttermargin' document option:
\newlength{\bindingmargin}
\setlength{\bindingmargin}{0in}
\DeclareOption{bindingmargin}{\setlength{\bindingmargin}{0.3in}}

% pass other document options to the report class:
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ProcessOptions\relax
\LoadClass{report}

% load other packages we need:
\RequirePackage{graphicx}
\RequirePackage{fancyhdr}

% -- set up page geometry --------------------------------------------------
\setlength{\parindent}{0.5in}
\setlength{\parskip}{0in}
\setlength{\headsep}{20pt}
\setlength{\headheight}{24pt}
\setlength{\footskip}{36pt}

\newlength{\MY@topmargin}
\newlength{\MY@insidemargin}
\newlength{\MY@outsidemargin}

% NOTE: change only \MY@topmargin, \MY@insidemargin and \MY@outsidemargin.
% All other lengths are calculated automatically.
\setlength{\MY@topmargin}{1.0in}
\setlength{\MY@insidemargin}{1.15in}
\setlength{\MY@outsidemargin}{1.15in}

\newcommand{\addtobindingmargin}[1]{%
  \addtolength{\evensidemargin}{#1}%
  \addtolength{\oddsidemargin}{#1}%
  \addtolength{\textwidth}{-#1}}

% calculate width of printed text:
\setlength{\textwidth}{\paperwidth}
\addtolength{\textwidth}{-\MY@insidemargin}
\addtolength{\textwidth}{-\MY@outsidemargin}

% set margins:
\setlength{\oddsidemargin}{\MY@insidemargin}
\setlength{\evensidemargin}{\MY@insidemargin}
\if@twoside \setlength{\evensidemargin}{\MY@outsidemargin}\fi

% correct for LaTeX measuring margins from a 1in baseline:
\addtolength{\oddsidemargin}{-1in}
\addtolength{\evensidemargin}{-1in}

\setlength{\textheight}{\paperheight}
\addtolength{\textheight}{-\headheight}
\addtolength{\textheight}{-\headsep}
\addtolength{\textheight}{-\footskip}
\addtolength{\textheight}{-2\MY@topmargin} % top and bottom margins are the same

\setlength{\topmargin}{\MY@topmargin}
\addtolength{\topmargin}{-1in}

% provide extra binding margin:
\addtobindingmargin{\bindingmargin}

% -- user-definable variables with defaults ------------------------------------
\newcommand{\@department}{}
\newcommand{\@degree}{}
\newcommand{\@examiner}{}

\@onlypreamble{\department}
\@onlypreamble{\degree}
\@onlypreamble{\examiner}

\newcommand{\department}[1]{\renewcommand*{\@department}{#1}}
\newcommand{\degree}[1]{\renewcommand*{\@degree}{#1}}

\newcounter{examiner}
\newcommand{\examiner}[1]{%
  \stepcounter{examiner}%
  \protected@write\@auxout{}%
  {\string\newlabel{ex\theexaminer}{{#1}{}}}% 
}

% -- thesis specific macros ----------------------------------------------------
% (this code 'borrowed' for thesis91e.cls)
% Clears the last page of previous chapter (this is also true for
% ``PrepageEnvironment'') and properly positions the first page of the
% next chapter (perhaps skipping even page).
\def\@clearChapterPage{%
  \if@openright\cleardoublepage\else\clearpage \fi
}

% at cleardoublepage we don't want the possibly skipped even page to
% be numbered (taken from ``ltoutput.dtx''):
\renewcommand{\cleardoublepage}{%
  \clearpage%
  \if@twoside \ifodd\c@page\else \thispagestyle{empty}
    \hbox{}\newpage\if@twocolumn\hbox{}\newpage\fi%
  \fi\fi%
}

% -- PrepageEnvironment ------------------------------------------------------
% (this code 'borrowed' for thesis91e.cls)
% PrepageEnvironment is used in frontmatter for abstract,
% acknowledgement etc. The first argument is a name of the new
% environment and the second one the title printed out for it.
%
% The PrepageEnvironment attempts to centre the text vertically on the
% page. If your text approaches or exceeds one page in length, you will
% probably find the title at the bottom of one page, and the text
% itself on the next page. To avoid this, remove the ``\null\vfil'' in
% the beginning and ending part of ``\newenvironment'', and latex
% won't try to centre it on the page.

\newcommand{\newPrepageEnvironment}[2]{
  \@ifundefined{#1}%
     {\let\@tempa=\newenvironment
     }{\let\@tempa=\renewenvironment}
  \@tempa{#1}{
    \@clearChapterPage
    \addcontentsline{toc}{chapter}{#2}
    \thispagestyle{plain}
    \null\vfil
    \begin{center} \textbf{\Large #2} \end{center}
  }{\par\vfil\null \clearpage}
}

% -- provide some default prepage environments -----------------------------------
\newPrepageEnvironment{abstract}{Abstract}
\newPrepageEnvironment{acknowledgements}{Acknowledgements}

% -- header/footer formatting ----------------------------------------------------
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
\renewcommand{\sectionmark}[1]{\markright{\MakeUppercase{#1}}{}}

\if@twoside
  \lhead[\fancyplain{}{\thepage}]{\fancyplain{}{ \slshape\rightmark}}
  \rhead[\fancyplain{}{\slshape\leftmark}]{\fancyplain{}{\thepage}}
\else
    \lhead{\fancyplain{}{\slshape\rightmark}}
    \rhead{\fancyplain{}{\thepage}}
\fi

\cfoot[{}]{\fancyplain{\thepage}{}}

\def\frontmatter{\pagenumbering{roman}}
\def\mainmatter{
  \@clearChapterPage
  \pagenumbering{arabic}
  \pagestyle{fancyplain}
}

%% ------------------------------------------------------------------------------
%% command to generate list of examiners; needed for the title page
\newcounter{examinernum}
\newcommand{\listexaminers}{%
\def\makelines{%
\stepcounter{examinernum}%
\\[3ex]\hline
\ref{ex\theexaminernum}\\
\ifnum\value{examinernum}<\numexaminers\makelines\fi
}%makelines
\setcounter{examinernum}{0}%
\renewcommand{\tabcolsep}{0pt}%
\begin{tabular}[t]{ll}%
\makelines
\\[1em] Dated \@date, Kamloops, British Columbia, Canada
\end{tabular}
}%newcommand

% -- define the title page --------------------------------------------------------
\renewcommand{\maketitle}{%
\begin{titlepage}%
  \setlength{\parindent}{0pt}
  \setcounter{page}{1}
  \vspace*{-0.5in}
  \parbox{\linewidth}{
    \begin{center}
      \textbf{\LARGE{\@title}}\\[2em]
      by\\[1em]
      \textbf{\large{\@author}}
    \end{center}
  }%\parbox

  \smallskip

  \parbox{\linewidth}{
  \begin{center}
  \textsc{\@degree}\\[1em]
  \@department\\[2em]
  \end{center}
   }%\parbox

  \vfill

\end{titlepage}
}% \maketitle

% -- define the declaration and signature page -------------------------------------
\newcommand{\sigpage}{%
\setcounter{page}{2}  % page after title page is ii not i which is
                      % what LaTeX sets it to.
\@clearChapterPage

\begin{center}
{\Large THOMPSON RIVERS UNIVERSITY\\[1ex]
\MakeUppercase{\@department}}
\end{center}

\bigskip

\noindent Permission is herewith granted to Thompson Rivers University to circulate and to have copied for non-commercial purposes, at its discretion, the above title upon request of individuals or institutions.

\vfill

\hspace*{\fill}%
\begin{tabular}[t]{c}%
\texttt{--------------------------------}\\
\texttt{Signature of Author}
\end{tabular}

\vfill

\noindent \textsc{the author reserves other publication rights, and neither the thesis nor extensive extracts from it may be printed or otherwise reproduced without the author's written permission.}

\textsc{the author attests that permission has been obtained for the use of any copy-righted material appearing in this thesis (other than brief excerpts requiring only proper acknowledgement in scholarly righting) and that all such use is clearly acknowledged.}

\vfill
}%sigpage


% write to aux file the number of examiners for title page:
\def\MY@putlabel{%
   \immediate\write\@auxout{\string%
   \newlabel{LastExaminer}{{\theexaminer}{}}}%
}
\AtEndDocument{%
   \message{truthesis.cls setting LastExaminer}%
   \MY@putlabel}%

\AtBeginDocument{%
% make sure numexaminers is defined even if there's no aux file yet:
  \ifx\r@LastExaminer\@undefined%
  \newcommand\numexaminers{1}%
  \else%
  \newcommand\numexaminers{\ref{LastExaminer}}%
  \fi
}

