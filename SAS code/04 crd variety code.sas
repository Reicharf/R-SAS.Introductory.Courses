PROC IMPORT OUT= WORK.crd 
            DATAFILE= "\\AFS\uni-hohenheim.de\hhome\p\paulschm\MY-DATA\Desktop\SAS August\R-SAS.Introductory.Courses-master\R-SAS.Introductory.Courses-master\Datasets\04 crd variety.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

* Completely Randomized Design (CRD);
* One-way ANOVA;

PROC PRINT DATA=crd;
RUN;

/* Plot the data to get a first impression */
/*******************************************/
PROC SGPLOT DATA=crd;
VBOX Yield /CATEGORY=Variety;
RUN;

/* Fit model */
/*************/
* Step 1: Check F-Test of ANOVA;
* Step 2: Compare adjusted means per level;

PROC GLIMMIX DATA=crd PLOTS=RESIDUALPANEL;	* Show residual plots
CLASS Variety;         				* List all categorical variables in CLASS;
MODEL Yield = Variety;				* 1 Treatment effect = "Variety";
LSMEANS Variety /PDIFF LINES ADJUST=TUKEY;	* pairwise differences between adj. means for Varieties with Tukey-test;
ODS OUTPUT LSMeans=mytable; 			* Extracts adjusted means table;
RUN;

/* Modify adjusted means table in order to plot it */
/***************************************************/
PROC PRINT DATA=mytable;
RUN;

DATA mytable;
SET  mytable;
lower = Estimate - StdErr ;
upper = Estimate + StdErr ;
RUN;

PROC SGPLOT DATA=mytable;
VBARPARM RESPONSE=Estimate CATEGORY=Variety / LIMITLOWER=lower LIMITUPPER=upper ;
RUN;
