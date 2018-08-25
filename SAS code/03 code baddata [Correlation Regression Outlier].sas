/* Import the dataset from a .txt file called "02 bad data fixed" */
* Note that the DATAFILE= line in the PROC IMPORT statement must be adjusted to display YOUR folder where the data is saved;
PROC IMPORT OUT= WORK.data 
            DATAFILE= "\\AFS\uni-hohenheim.de\hhome\p\paulschm\MY-DATA\Desktop\SAS march\02 bad data fixed.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

PROC PRINT DATA=data; 
RUN;

/* Plot the data to get a first impression */
/*******************************************/
PROC SGPLOT DATA=data;
SCATTER Y=Vision X=Ages;
REG     Y=Vision X=Ages;
XAXIS MIN=0;
YAXIS MIN=0;
RUN;

/* Correlation */
/***************/
PROC CORR DATA=data; 
VAR Vision Ages;
RUN;
* r = -0.49* (p=0.0071);

/* Simple linear Regression */
/****************************/
PROC REG DATA=data; 
MODEL Vision = Ages;  *Vision = 11.14199 - 0.09099  * Ages;
RUN;                  *R² = 0.2473;


/* Who is this outlier? */
/************************/
DATA outlier;
SET data;
IF Vision > 4 THEN DELETE; *Reduce dataset to find person with bad vision;
RUN; 

PROC PRINT DATA=outlier; *Roland is the outlier!;
RUN;

/* Kick out the outlier */
/************************/
DATA dataNoRolando;
SET data;
IF Vision < 4 THEN DELETE;        * Exclude Rolando;
*IF Person="Rolando" THEN DELETE; *Alternative Option to exlude Rolando;
RUN; 

/* Plot again, but without Rolando */
/***********************************/
PROC SGPLOT DATA=dataNoRolando;
SCATTER Y=Vision X=Ages;
REG     Y=Vision X=Ages;
XAXIS MIN=0;
YAXIS MIN=0;
RUN;

/* Correlation without Rolando */
/*******************************/
PROC CORR DATA=dataNoRolando; 
VAR Vision Ages;
RUN;
*r = -0.7* (p<.0001);

/* Regression without Rolando*/
/*****************************/
PROC REG DATA=dataNoRolando; 
MODEL Vision = Ages;  *Vision = 11.70395 - 0.10229 * Ages;
RUN;                  * R² = 0.48; 
