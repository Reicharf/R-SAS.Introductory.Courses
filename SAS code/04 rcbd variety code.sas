PROC IMPORT OUT= WORK.rcbd 
            DATAFILE= "\\AFS\uni-hohenheim.de\hhome\p\paulschm\MY-DATA\D
esktop\SAS August\R-SAS.Introductory.Courses-master\R-SAS.Introductory.C
ourses-master\Datasets\04 rcbd variety.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

PROC PRINT DATA=rcbd;
RUN;

* Randomized Complete Block Design - one factor effect;

* Linear model with Variety (=Treatment) effect and
  Block (=Design) effect;

PROC GLIMMIX DATA=rcbd;
CLASS Variety Block;
MODEL Yield = Variety Block;
LSMEANS Variety /PDIFF LINES;
RUN;
