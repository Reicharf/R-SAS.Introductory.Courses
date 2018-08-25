PROC IMPORT OUT= WORK.crd 
            DATAFILE= "\\AFS\uni-hohenheim.de\hhome\p\paulschm\MY-DATA\D
esktop\SAS August\R-SAS.Introductory.Courses-master\R-SAS.Introductory.C
ourses-master\Datasets\04 crd variety.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

* Completely Randomized Design (CRD);
* One factor effect ;

PROC PRINT DATA=crd;
RUN;

* Plot for first impression ;
PROC SGPLOT DATA=crd;
VBOX Yield /CATEGORY=Variety;
RUN;

PROC GLIMMIX DATA=crd PLOTS=RESIDUALPANEL;
CLASS Variety;         *list all categorical variables in CLASS;
MODEL Yield = Variety;
LSMEANS Variety /PDIFF LINES ADJUST=TUKEY;
ODS OUTPUT LSMeans=mytable;
RUN;

* Step 1: Check F-Test of ANOVA;
* Step 2: Compare adjusted means per level;

PROC PRINT DATA=mytable;
RUN;

DATA mytable;
SET  mytable;
lower = Estimate - StdErr ;
upper = Estimate + StdErr ;
RUN;

PROC SGPLOT DATA=mytable;
VBARPARM RESPONSE=Estimate CATEGORY=Variety / 
		 LIMITLOWER=lower LIMITUPPER=upper ;
RUN;














