PROC IMPORT OUT= WORK.repmes 
            DATAFILE= "\\AFS\uni-hohenheim.de\hhome\p\paulschm\MY-DATA\Desktop\SAS Jan\05 data repeated measures.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

/* Shorten column names */
DATA repmes;
SET repmes;
RENAME Treatment = Trt
       Replicate = Rep
	   Sampling  = Week
	   Quantity  = Quant;
RUN;

PROC PRINT DATA=repmes;
RUN;

* Completely Randomized Design (CRD) with repeated measures;
* Three-way ANOVA;

* Create a column named "plotID" that has unique values for each plot;
DATA repmes;
SET  repmes;
plotID = CATS("S",Soil,"-T", Trt,"-R", Replicate);
RUN;

/* Option 1: Fit general linear model for each week */
/****************************************************/
* Treatment effects: Soil, Trt and their interactions;
* Design effects:    - ;
* Step 1: Check F-Test of ANOVA and perform backwards elimination;
* Step 2: Compare adjusted means per level;
PROC GLIMMIX DATA=repmes PLOTS=RESIDUALPANEL;	 * Show residual plots;;
WHERE Week=1; *Option to select a specific week;
*BY Week;     *Option to loop through all weeks;
CLASS Soil Trt;
MODEL Quant = Soil Trt Soil*Trt;
* LSMEANS ... /PDIFF LINES ADJUST=TUKEY;
RUN;

/* Option 2: Fit general linear model with AR(1) covariance structre among errors for entire dataset */
/*****************************************************************************************************/
* Treatment effects: Soil, Trt, Week and their interactions;
* Design effects:    - ;
* Step 1: Check F-Test of ANOVA and perform backwards elimination;
* Step 2: Compare adjusted means per level;

* Full model;
PROC MIXED DATA=repmes;
CLASS Soil Trt Week plotID;
MODEL Quantity = Soil Trt Week 
                 Soil*Trt Soil*Week Trt*Week
                 Soil*Trt*Week /DDFM=KR;
REPEATED Week /SUBJECT=plotID TYPE=AR(1);
RUN;
* Soil*Trt*Week is n.s. - Drop it from model;

* Reduced Model 1 = Final Model;
PROC MIXED DATA=repmes PLOTS=STUDENTPANEL;
CLASS Soil Trt Week plotID;
MODEL Quantity = Soil Trt Week 
                 Soil*Trt Soil*Week Trt*Week /DDFM=KR;
REPEATED Week /SUBJECT=plotID TYPE=AR(1);
*LSMEANS ... /PDIFF LINES ADJUST=TUKEY;
RUN; 
* Everything else is significant;
