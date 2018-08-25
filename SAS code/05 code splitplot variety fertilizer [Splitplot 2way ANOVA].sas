PROC IMPORT OUT= WORK.sp 
            DATAFILE= "\\AFS\uni-hohenheim.de\hhome\p\paulschm\MY-DATA\Desktop\SAS August\R-SAS.Introductory.Courses-master\R-SAS.Introductory.Courses-master\Datasets\05 split plot variety nitrogen.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

PROC PRINT DATA=sp;
RUN;

* Split Plot Design;
* Two-way ANOVA;

* Split Plot Design 
 When some factors (independent variables) are difficult 
 or impossible to change in your experiment, a completely 
 randomized design isn't possible. The result is a 
 split-plot design, which has a mixture of hard to
 randomize (or hard-to-change) and easy-to-randomize 
 (or easy-to-change) factors. The hard-to-change factors 
 are implemented first, followed by the easier-to-change factors.;
 
 * As a general principle, each randomization units needs 
   to be represented by a random effect, so each randomization unit
   has its own error term. ;

/* Fit general linear mixed model */
/**********************************/
* Treatment effects: Variety, Fertilizer and their Interaction;
* Design effects:    Block and Mainplot(=random effect);
* Step 1: Check F-Test of ANOVA and perform backwards elimination;
* Step 2: Compare adjusted means per level;

* Full model = Final model;
PROC GLIMMIX DATA=sp PLOTS=RESIDUALPANEL;   * Show residual plots;
CLASS Var N Block;
MODEL Yield = Var N Var*N Block /DDFM=KR;   * Adjust the denominator degrees of freedom according to Kenward-Roger [see note below]
RANDOM Block*N;
LSMEANS Var*N /PDIFF LINES SLICEDIFF=N;     * pairwise differences between adj. means for Variety-Fertilizer combinations;
RUN;
* The interaction is significant -> final model;

* Note 1: In this example, Block*N identifies the incomplete blocks (=main plots) within each complete block. 
  To read more about this example, see p. 59 of Prof. Piepho's lecture notes for "Mixed models for metric data" ;
* Note 2: Quote from p. 58 of Prof. Piepho's lecture notes for "Mixed models for metric data": 
  "My recommendation is to always use the Kenward-Roger method with mixed models; you can’t go wrong with this." ;
* Note 3: Design effects stay in the model even if not significant;
* Note 4: Code for plotting adj. means can be found in previous code;
