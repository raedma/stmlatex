%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Header                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% This is a document class for structural mechanics
% documentation
%
% Usage
%  - Premble:
%    - \documentclass{stmtext}
% 
% Revisions: 2019-11-25 Martin Raedel <martin.raedel@dlr.de>
%                       Initial draft
%               
% Contact:   Martin Raedel,  martin.raedel@dlr.de
%            DLR Composite Structures and Adaptive Systems
%          
%                                 __/|__
%                                /_/_/_/  
%            www.dlr.de/fa/en      |/ DLR
%
% Copyright (C) 2019-... DLR Composite Structures and Adaptive Systems
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Content                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Declare that this style file requires at least LaTeX version 2e.
\NeedsTeXFormat{LaTeX2e}

% Provide the name of your page, the date it was last updated, and a comment about what it's used for
\ProvidesClass{stmtext}[2019/11/25 STM documentation class]

% ---------------------------
% Package
% ---------------------------

\@ifpackageloaded{kvoptions}{}{\RequirePackage{kvoptions}}%
\@ifpackageloaded{ifthen}{}{\RequirePackage{ifthen}}%

% ---------------------------
% Options base
% ---------------------------

\SetupKeyvalOptions{%
  family=stmtextbase,%
  prefix=stmtextbase@,%
  setkeys=\kvsetkeys,%
}

% String options
\DeclareStringOption[report]{type}
\DeclareStringOption[koma]{layout}

% Process options
\ProcessKeyvalOptions{stmtextbase}

% ---------------------------
% Options
% ---------------------------

\SetupKeyvalOptions{%
  family=stmtext,%
  prefix=stmtext@,%
  setkeys=\kvsetkeys,%
}

% Bool option
\DeclareBoolOption[true] {color}
\DeclareBoolOption[true] {conditionallox}
\DeclareBoolOption[true] {conditionalloxnewpage}
\DeclareBoolOption[false]{date}
\DeclareBoolOption[false]{glossaries}
\DeclareBoolOption[false]{index}
\DeclareBoolOption[true] {hyperref}
\DeclareBoolOption[false]{listings}
\DeclareBoolOption[false]{math}
\DeclareBoolOption[false]{plots}
\DeclareBoolOption[false]{tikz}
\DeclareBoolOption[false]{units}

%
\DeclareStringOption[english]{language}

% DLR options
\DeclareStringOption[FA-STM]{institute}
\DeclareStringOption[BS]{site}

% Options that are dependent of the position of hyperref
\DeclareBoolOption[false]{attachfile}
\DeclareBoolOption[false]{cleveref}

% any other options are passed to the base class
\DeclareDefaultOption{%
  \ifthenelse{\equal{\stmtextbase@type}{article}}{%
    \ifthenelse{\equal{\stmtextbase@layout}{normal}}{%
      \PassOptionsToClass{\CurrentOption}{article}%
    }{}%
    \ifthenelse{\equal{\stmtextbase@layout}{dlr}}{%
      \PassOptionsToClass{\CurrentOption}{dlrartcl}%
    }{}%
    \ifthenelse{\equal{\stmtextbase@layout}{koma}}{%
      \PassOptionsToClass{\CurrentOption}{scrartcl}%
    }{}%
  }{}%
}
\DeclareDefaultOption{%
  \ifthenelse{\equal{\stmtextbase@type}{report}}{%
    \ifthenelse{\equal{\stmtextbase@layout}{normal}}{%
      \PassOptionsToClass{\CurrentOption}{report}%
    }{}%
    \ifthenelse{\equal{\stmtextbase@layout}{dlr}}{%
      \PassOptionsToClass{\CurrentOption}{dlrreprt}%
    }{}%
    \ifthenelse{\equal{\stmtextbase@layout}{koma}}{%
      \PassOptionsToClass{\CurrentOption}{scrreprt}%
    }{}%
  }{}%
}
\DeclareDefaultOption{%
  \ifthenelse{\equal{\stmtextbase@type}{book}}{%
    \ifthenelse{\equal{\stmtextbase@layout}{normal}}{%
      \PassOptionsToClass{\CurrentOption}{book}%
    }{}%
    \ifthenelse{\equal{\stmtextbase@layout}{dlr}}{%
      \PassOptionsToClass{\CurrentOption}{dlrbook}%
    }{}%
    \ifthenelse{\equal{\stmtextbase@layout}{koma}}{%
      \PassOptionsToClass{\CurrentOption}{scrbook}%
    }{}%
  }{}%
}

% Process options
\ProcessKeyvalOptions{stmtext}

% ---------------------------
% Base class
% ---------------------------

% Load scrreprt class

\ifthenelse{\equal{\stmtextbase@type}{article}}{%
  \ifthenelse{\equal{\stmtextbase@layout}{normal}}{%
    \LoadClass{article}
  }{}%
  \ifthenelse{\equal{\stmtextbase@layout}{dlr}}{%
    \LoadClass{dlrartcl}
  }{}%
  \ifthenelse{\equal{\stmtextbase@layout}{koma}}{%
    \LoadClass{scrartcl}
  }{}%
}{}%
\ifthenelse{\equal{\stmtextbase@type}{report}}{%
  \ifthenelse{\equal{\stmtextbase@layout}{normal}}{%
    \LoadClass{report}
  }{}%
  \ifthenelse{\equal{\stmtextbase@layout}{dlr}}{%
    \LoadClass{dlrreprt}
  }{}%
  \ifthenelse{\equal{\stmtextbase@layout}{koma}}{%
    \LoadClass{scrreprt}
  }{}%
}{}%
\ifthenelse{\equal{\stmtextbase@type}{book}}{%
  \ifthenelse{\equal{\stmtextbase@layout}{normal}}{%
    \LoadClass{book}
  }{}%
  \ifthenelse{\equal{\stmtextbase@layout}{dlr}}{%
    \LoadClass{dlrbook}
  }{}%
  \ifthenelse{\equal{\stmtextbase@layout}{koma}}{%
    \LoadClass{scrbook}
  }{}%
}{}%

% ---------------------------
% Commands for communality between document classes
% ---------------------------

% Commands for the standard document classes
\ifthenelse{\equal{\stmtextbase@layout}{normal}}{%

  \@ifundefined{subtitle}{    \def\subtitle#1{\gdef\@subtitle{#1} }%
                              \def\@subtitle{}}{}%

}{}%

% Commands for DLR document classes
\ifthenelse{\equal{\stmtextbase@layout}{dlr}}{%
  
  \dlrinstitute{\stmtext@institute}%
  \dlrsite     {\stmtext@site}%
  
}{}%

% Commands from RM-LaTeX that other classes need to understand
\ifthenelse{%
  \equal{\stmtextbase@layout}{normal} \OR%
  \equal{\stmtextbase@layout}{koma}%
}{%

    % These commands are created to allow for an easy switch between
    % dlrreprt and bootstrap_dlrreprt.

    \@ifundefined{subject}{     \def\subject#1{\gdef\@subject{#1} }%
                                \def\@subject{}}{}%
    \@ifundefined{keywords}{    \def\keywords#1{\gdef\@keywords{#1} }%
                                \def\@keywords{}}{}
    \@ifundefined{restrictions}{\def\restrictions#1{\gdef\@restrictions{#1} }%
                                \def\@restrictions{}}{}
    \@ifundefined{author}{      \def\author#1{\gdef\@author{#1} }%
                                \def\@author{}}{}
    \@ifundefined{coauthor}{    \def\coauthor#1{\gdef\@coauthor{#1} }%
                                \def\@coauthor{}}{}
    \@ifundefined{savedby}{     \def\savedby#1{\gdef\@savedby{#1} }%
                                \def\@savedby{}}{}      
    \@ifundefined{approvedby}{  \def\approvedby#1{\gdef\@approvedby{#1} }%
                                \def\@approvedby{}}{}  
    \@ifundefined{releasedby}{  \def\releasedby#1{\gdef\@releasedby{#1} }%
                                \def\@releasedby{}}{} 
    \@ifundefined{contactname}{ \def\contactname#1{\gdef\@contactname{#1} }%
                                \def\@contactname{}}{}
    \@ifundefined{telnumber}{   \def\telnumber#1{\gdef\@telnumber{#1} }%
                                \def\@telnumber{}}{}
    \@ifundefined{faxnumber}{   \def\faxnumber#1{\gdef\@faxnumber{#1} }%
                                \def\@faxnumber{}}{}      
    \@ifundefined{email}{       \def\email#1{\gdef\@email{#1} }%
                                \def\@email{}}{}
    \@ifundefined{reportno}{    \def\reportno#1{\gdef\@reportno{#1} }%
                                \def\@reportno{}}{}

    % From dlrinstitutes.sty
    \@ifundefined{institute}{   \def\institute#1{\gdef\@institute{#1} }%
                                \def\@institute{}}{}
    \@ifundefined{site}{        \def\site#1{\gdef\@site{#1} }%
                                \def\@site{}}{}
    
    % The command for the second titlepage
    \newcommand{\secondpage}{}%
}{
  
  \RequirePackage{dlrsecondpage}
  
}

% ---------------------------
% Modules
% ---------------------------

\ifstmtext@color
  \RequirePackage{stmcolors}
\fi

\ifstmtext@conditionallox
  \RequirePackage[%
    newpage={\ifstmtext@conditionalloxnewpage true\else false\fi},%
  ]{stmconditionallox}
\fi

\ifstmtext@date
  \RequirePackage{stmdate}
\fi

\ifstmtext@glossaries
  \RequirePackage{stmglossaries}
\fi

\ifstmtext@index
  \RequirePackage{stmindex}
\fi

%\ifstmtext@language
  \PassOptionsToPackage{%
    language=\stmtext@language,%
  }{stmlanguage}%
  \RequirePackage{stmlanguage}
%\fi

\ifstmtext@listings
  \RequirePackage{stmlistings}
\fi

\ifstmtext@math
  \RequirePackage{stmmath}
\fi

\ifstmtext@plots
  \RequirePackage{stmplots}
\fi

\ifstmtext@tikz
  \RequirePackage{stmtikz}
\fi

\ifstmtext@units
  \RequirePackage{stmunits}
\fi

% ---------------------------
% Coseoul to get a level-independent document structure
% ---------------------------

\RequirePackage{coseoul}

\newcommand{\basetoclevelnr}[1]{#1}
\ifthenelse{\equal{\stmtextbase@type}{article}}{%
  \renewcommand{\basetoclevelnr}{5}%
}{}%
\ifthenelse{\equal{\stmtextbase@type}{report}}{%
  \renewcommand{\basetoclevelnr}{6}%
}{}%
\ifthenelse{\equal{\stmtextbase@type}{book}}{%
  \renewcommand{\basetoclevelnr}{7}%
}{}%

\setcounter{currentlevel}{\basetoclevelnr}

% ---------------------------
% Hyperref - make sure it is loaded as the last package
% ---------------------------

\ifstmtext@hyperref
  %\makeatletter
  
  \@ifpackageloaded{etoolbox}{}{%
    \RequirePackage{etoolbox}
  }
  
  %\AtBeginDocument{
  \AtEndPreamble{
    
    %
    \RequirePackage{stmhyperrefsetup}
    
    % Must be loaded after hyperref
    \ifstmtext@attachfile
      \RequirePackage{attachfile}
    \fi
    
    \ifstmtext@cleveref
      \RequirePackage{cleveref}
    \fi
  }
  %\makeatother
\else
  \ifstmtext@attachfile
    \RequirePackage{attachfile}
  \fi
  
  \ifstmtext@cleveref
    \RequirePackage{cleveref}
  \fi
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% That's it                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Finally, we'll use \endinput to indicate that LaTeX can stop reading this file. LaTeX will ignore anything after this line.
\endinput
