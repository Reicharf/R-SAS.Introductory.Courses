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

*sort it and print it!;
PROC SORT DATA=data; 
BY Person;
RUN;
PROC PRINT DATA=data;
RUN;

* draw graph to get first impression;
PROC SGPLOT DATA=data;
SCATTER Y=blood_alc X=drinks;
XAXIS MIN=0 LABEL="number of drinks";
YAXIS MIN=0 LABEL="blood alcohol";
RUN;

**************************************;
* Correlation of drinks and blood_alc;
PROC CORR DATA=data;
VAR drinks blood_alc;
ODS OUTPUT PearsonCorr = out;
RUN;

*format columns;
DATA out2; 
SET out;
RENAME blood_alc  = correlation 
       pblood_alc = pvalue;
DROP Variable drinks pdrinks;
RUN;

*format rows;
DATA out3;
SET out2;
IF correlation=1 THEN DELETE;
RUN;

* export ;
PROC EXPORT DATA= WORK.OUT3 
            OUTFILE= "\\AFS\uni-hohenheim.de\hhome\p\paulschm\MY-DATA\De
sktop\SAS march\exported_correlation.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=YES;
RUN;

*******************************************************;
* Regression of drinks and blood_alc;

PROC REG DATA=data;
MODEL blood_alc = drinks;
     *blood_alc =     a    +    b   *drinks - what is a and b?;
     *blood_alc = -0.04203 + 0.12572*drinks;
RUN;

PROC SGPLOT DATA=data;
SCATTER Y=blood_alc X=drinks;
REG     Y=blood_alc X=drinks;
XAXIS MIN=0 LABEL="number of drinks";
YAXIS MIN=0 LABEL="blood alcohol";
RUN;

PROC REG DATA=data;
MODEL blood_alc = drinks /NOINT;
     *blood_alc =     0    +    b   *drinks - what is b?;
     *blood_alc =     0    + 0.11900*drinks;
RUN;




