PROC IMPORT OUT= WORK.rcbd 
            DATAFILE= "\\AFS\uni-hohenheim.de\hhome\p\paulschm\MY-DATA\Desktop\SAS August\R-SAS.Introductory.Courses-master\R-SAS.Introductory.Courses-master\Datasets\04 rcbd variety.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

PROC PRINT DATA=rcbd;
RUN;

* Randomized Complete Block Design (RCBD);
* One-way ANOVA;

/* Plot the data to get a first impression */
/*******************************************/
PROC SGPLOT DATA=rcbd;
VBOX Yield /CATEGORY=Variety;
RUN;

/* Fit general linear model */
/****************************/
* Treatment effects: Variety;
* Design effects:    Block;
* Step 1: Check F-Test of ANOVA;
* Step 2: Compare adjusted means per level;

PROC GLIMMIX DATA=rcbd PLOTS=RESIDUALPANEL;	* Show residual plots
CLASS Variety Block;                            * List all categorical variables in CLASS;
MODEL Yield = Variety Block;
LSMEANS Variety /PDIFF LINES;                   * pairwise differences between adj. means for Varieties with Tukey-test;
RUN;

*NOTE: Code for plotting adj. means can be found in previous code;
