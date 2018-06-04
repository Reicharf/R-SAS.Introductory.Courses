PROC IMPORT OUT= WORK.BADDAT 
            DATAFILE= "\\AFS\uni-hohenheim.de\hhome\p\paulschm\MY-DATA\Desktop\SAS march\02 bad data fixed.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
* Plot data for first impression;
PROC SGPLOT DATA=baddat;
SCATTER Y=Vision X=Ages;
REG     Y=Vision X=Ages;
XAXIS MIN=0;
YAXIS MIN=0;
RUN;

* Correlation;
PROC CORR DATA=baddat; *r = -0.49* (p=0.0071);
VAR Vision Ages;
RUN;
* Regression;
PROC REG DATA=baddat; 
MODEL Vision = Ages;  *Vision = 11.14199 - 0.09099  * Ages;
RUN;                  *         (p<.0001) (p=0.0071)
                      *R² = 0.2473;

****************************************;
* What if that one person was an error? ;

DATA baddat_nr;
SET baddat;
IF person="Rolando" THEN DELETE;
RUN;

PROC SGPLOT DATA=baddat_nr;
SCATTER Y=Vision X=Ages;
REG     Y=Vision X=Ages;
XAXIS MIN=0;
YAXIS MIN=0;
RUN;
* Correlation;
PROC CORR DATA=baddat_nr; *r = -0.70* (p<.0001);
VAR Vision Ages;
RUN;
* Regression;
PROC REG DATA=baddat_nr; 
MODEL Vision = Ages;  *Vision = 11.70395 - 0.10229  * Ages;
RUN;                  *         (p<.0001) (p<.0001)
                      * R² = 0.4849;
