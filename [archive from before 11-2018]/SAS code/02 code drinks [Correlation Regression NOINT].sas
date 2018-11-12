DATA data;
INPUT Person$ drinks blood_alc;
DATALINES;
Peter 1 0.2
Max   5 0.2
Peter 1 0.1
Max   2 0.3
Peter 3 0.3
Max   4 0.5
Peter 5 0.5
Max   5 0.6
Peter 6 0.8
Max   7 0.8
Peter 8 0.9
Max   8 1.0
Peter 9 1.3
;
RUN;

/* Sort the dataset by person and then print it */
/************************************************/
PROC SORT DATA=data; 
BY Person;
RUN;

PROC PRINT DATA=data;
RUN;

/* Plot the data to get a first impression */
/*******************************************/
PROC SGPLOT DATA=data;
SCATTER Y=blood_alc X=drinks;
XAXIS MIN=0 LABEL="number of drinks";
YAXIS MIN=0 LABEL="blood alcohol";
RUN;

/* Correlation */
/***************/
PROC CORR DATA=data;
VAR drinks blood_alc;
RUN;
* r = 0.92 (p-value < 0.0001);

/* Simple linear Regression */
/****************************/
PROC REG DATA=data;
MODEL blood_alc = drinks;
     *blood_alc =     a    +    b   *drinks;
     *blood_alc = -0.04203 + 0.12572*drinks;
RUN;

* Plot data again, but with regression line;
PROC SGPLOT DATA=data;
SCATTER Y=blood_alc X=drinks;
REG     Y=blood_alc X=drinks;
XAXIS MIN=0 LABEL="number of drinks";
YAXIS MIN=0 LABEL="blood alcohol";
RUN;

/* Simple linear Regression, but forcing the intercept to be 0 */
/***************************************************************/
PROC REG DATA=data;
MODEL blood_alc = drinks /NOINT;
     *blood_alc =     0    +    b   *drinks;
     *blood_alc =     0    + 0.11900*drinks;
RUN;
