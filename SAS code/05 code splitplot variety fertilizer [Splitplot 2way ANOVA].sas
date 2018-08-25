PROC IMPORT OUT= WORK.sp 
            DATAFILE= "\\AFS\uni-hohenheim.de\hhome\p\paulschm\MY-DATA\D
esktop\SAS August\R-SAS.Introductory.Courses-master\R-SAS.Introductory.C
ourses-master\Datasets\05 split plot variety nitrogen.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

PROC PRINT DATA=sp;
RUN;

* Split Plot Design 
 When some factors (independent variables) are difficult 
 or impossible to change in your experiment, a completely 
 randomized design isn't possible. The result is a 
 split-plot design, which has a mixture of hard to
 randomize (or hard-to-change) and easy-to-randomize 
 (or easy-to-change) factors. The hard-to-change factors 
 are implemented first, followed by the easier-to-change factors.;

* Split Plot Design - two factor effects;

* Linear model with Variety, Fertilizer and their interaction
  (=Treatment) effects and Block (=Design) effect;

* Full model;
PROC GLIMMIX DATA=sp;
CLASS Var N Block;
MODEL Yield = Var N Var*N Block;
RANDOM Block*N;
LSMEANS Var*N /PDIFF LINES SLICEDIFF=N;
RUN;
