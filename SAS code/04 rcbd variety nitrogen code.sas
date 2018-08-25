PROC IMPORT OUT= WORK.rcbd2 
            DATAFILE= "\\AFS\uni-hohenheim.de\hhome\p\paulschm\MY-DATA\D
esktop\SAS August\R-SAS.Introductory.Courses-master\R-SAS.Introductory.C
ourses-master\Datasets\04 rcbd variety nitrogen.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

PROC PRINT DATA=rcbd2;
RUN;

* Randomized Complete Block Design - two factor effects;

* Linear model with Variety, Fertilizer and their interaction
  (=Treatment) effects and Block (=Design) effect;

* Full model;
PROC GLIMMIX DATA=rcbd2;
CLASS Variety Fertilizer Block;
MODEL Yield = Variety Fertilizer Variety*Fertilizer Block;
RUN; * Interaction is n.s. - drop it from model ;

* Reduced model 1;
PROC GLIMMIX DATA=rcbd2;
CLASS Variety Fertilizer Block;
MODEL Yield = Variety Fertilizer Block;
RUN; * Fertilizer is n.s. - drop it from model ;

* Reduced model 2;
PROC GLIMMIX DATA=rcbd2;
CLASS Variety Fertilizer Block;
MODEL Yield = Variety Block;
LSMEANS Variety /PDIFF LINES;
RUN; * Variety is significant - final model;











