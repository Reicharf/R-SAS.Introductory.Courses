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

* Randomized Complete Block Design (RCBD);
* Two-way ANOVA;

/* Plot the data to get a first impression */
/*******************************************/
PROC SGPLOT DATA=rcbd;
VBOX Yield /CATEGORY=Variety;
RUN;

PROC SGPLOT DATA=rcbd;
VBOX Yield /CATEGORY=Fertilizer;
RUN;

/* Fit general linear model */
/****************************/
* Treatment effects: Variety, Fertilizer and their Interaction;
* Design effects:    Block;
* Step 1: Check F-Test of ANOVA and perform backwards elimination;
* Step 2: Compare adjusted means per level;

* Full model;
PROC GLIMMIX DATA=rcbd2;	                        
CLASS Variety Fertilizer Block;                            
MODEL Yield = Variety Fertilizer Variety*Fertilizer Block;
RUN; 
* Interaction is n.s. - eliminate from model;

* Reduced model 1;
PROC GLIMMIX DATA=rcbd2;
CLASS Variety Fertilizer Block;
MODEL Yield = Variety Fertilizer Block;
RUN; 
* Fertilizer is n.s. - eliminate from model;

* Reduced model 2 = Final model;
PROC GLIMMIX DATA=rcbd2 PLOTS=RESIDUALPANEL;	* Show residual plots;
CLASS Variety Fertilizer Block;
MODEL Yield = Variety Block;
LSMEANS Variety /PDIFF LINES;                   * pairwise differences between adj. means for Varieties with Tukey-test;
RUN; 
* Only variety is significant - final model;
* Note 1: Design effects stay in the model even if not significant;
* Note 2: Code for plotting adj. means can be found in previous code;
