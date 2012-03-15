%
% Project Euler. Solutions.
% (c) 2012 Mauro Taraborelli (MauroTaraborelli@gmail.com).
%
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THE SOFTWARE.
%
% [top-level file]
\documentclass
[ 11pt,
  a4paper ]
{article}
%
% for lhs2TeX
%include polycode.fmt
%
% page size and margins
\usepackage
[ a4paper,
  textwidth=6.5in,
  textheight=10in,
  marginparsep=7pt,
  marginparwidth=.6in ]
{geometry}
%
% no paragraph indentations
\setlength{\parindent}{0in}
%
% amount of space before each new paragraph begins
\setlength{\parskip}{1em}
%
% fonts definitions
\usepackage[T1]{fontenc}
\usepackage{fontspec}
\usepackage{xunicode}
\usepackage{xltxtra}
\defaultfontfeatures{Mapping=tex-text,Scale=MatchLowercase}
\setromanfont{TeX Gyre Schola}
\setsansfont{TeX Gyre Heros}
\setmonofont[Scale=0.8]{TeX Gyre Cursor}
%
\usepackage{graphicx}
%
\usepackage
[ usenames ,
  dvipsnames ]
{xcolor}
%
% Prussian Blue (Berlin Blue) (Hex: #003153) (RGB: 0, 49, 83)
\definecolor{PrussianBlue}{RGB}{0,49,83}
%
% multilingual text
\usepackage{polyglossia}
\setdefaultlanguage[variant=american]{english}
%
% hyperlinks
\usepackage
[ colorlinks=true ,
  urlcolor=PrussianBlue ,
  linkcolor=Black ,
  citecolor=PrussianBlue ,
  pdfauthor={Mauro Taraborelli} ,
  pdftitle={Project Euler. Solutions.} ,
  pagebackref=true ]
{hyperref}
%
\usepackage[round]{natbib}

\begin{document}
\pagestyle{plain}

\title{Project Euler. Solutions.}
\author{Mauro Taraborelli\\
\texttt {\href{mailto:MauroTaraborelli@@gmail.com}{MauroTaraborelli@@gmail.com}}}
\date{\today}
\maketitle

\begin{abstract}
Notes and documentation about my attempt to solve Project Euler problems in
Haskell and to learn how to use literate programming with \LaTeX.
\end{abstract}

\setcounter{tocdepth}{1}
\tableofcontents
\vspace*{1cm}

%include hs-euler-001.lhs

%include hs-euler-002.lhs

%include hs-euler-003.lhs

\bibliographystyle{plainnat}
\bibliography{hs-euler}
\end{document}
