PROC IMPORT OUT= WORK.sorghum 
            DATAFILE= "\\AFS\uni-hohenheim.de\hhome\p\paulschm\MY-DATA\D
esktop\SAS october\R-SAS.Introductory.Courses-master\Datasets\06 sorghum
 repeated measures.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

DATA sorghum;
SET  sorghum;
RENAME y  =yield
	   rep=block;
RUN;

PROC SGPLOT DATA=sorghum;
VBOX yield / CATEGORY=var GROUP=week;
RUN;

* In this experiment, the observational units (=plots) 
* were actually measured multiple times: once per week, 
* over five weeks. This is called "repeated measures" or 
* "repeated measurements". The aim of the experiment is 
* (just like in the last examples) to compare treatment 
* levels (=varieties). And since we here have an RCBD with 
* variety being the only treatment and qualitative factor, 
* the model to be used here is very similar to that of the 
* "04 rcbd variety" example. The difference, however, is 
* that due to the repeated measures, the error term of the 
* model should be allowed to be correlated between weeks.
*
* For more info on repeated measures see ch. 7 of "Quantitative 
* Methods in Biosciences", ch. 6 in "Mixed models for metric data"
* and Example 4 of 
* Piepho HP, Edmondson RN. A tutorial on the statistical 
* analysis of factorial experiments with qualitative and quantitative 
* treatment factor levels. J Agro Crop Sci. 2018;204:429-455.

/* Option 1: Fit general linear model for each week */
/******************/
* Treatment effects: Var   ;
* Design effects:    Block ;
PROC SORT DATA=sorghum;
BY week;
RUN;

PROC GLIMMIX DATA=sorghum;
*WHERE week=1; *Option to select a specific week;
BY Week;     *Option to loop through all weeks;
CLASS var block;
MODEL yield = var block;
RUN;

/* Option 2: Fit general linear model */
/* with AR(1) covariance structre     */
/* among errors for entire dataset    */
/**************/
* Treatment effects: Var          ;
* Design effects:    Block, Week* ;
* Step 1: Compare Covariance structures via AIC;
* Step 2: Check F-Test of ANOVA;
* Step 3: Compare adjusted means per level;


/* Step 1 */
* Create a column named "plotID" that has 
* unique values for each plot;
DATA sorghum; 
SET sorghum;
plotID = CATS("V", var, "-B", block);
RUN;

* IID (=default) covariance structure;
PROC MIXED DATA=sorghum;
CLASS var block week plotID;
MODEL yield = week week*var week*block /DDFM=KR;
RUN; * AIC = -1.7 ;

* AR(1) covariance structure;
PROC GLIMMIX DATA=sorghum;
CLASS var block week plotID;
MODEL yield = week week*var week*block /DDFM=KR;
RANDOM week /SUBJECT=plotID TYPE=AR(1) RESIDUAL;
RUN; * AIC = -42.0 <- better!;

/* Step 2/3 */
PROC GLIMMIX DATA=sorghum;
CLASS var block week plotID;
MODEL yield = week week*var week*block /DDFM=KR;
RANDOM week /RESIDUAL SUBJECT=plotID TYPE=AR(1);
LSMEANS week*var/PDIFF LINES SLICEDIFF=week;
RUN;