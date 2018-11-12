* This is a way to write a comment ;
/* This is also a way to write a comment */

/* Creating two small datasets named "a" and "b"*/
/************************************************/
DATA a;
INPUT Trt$ y;
DATALINES;
A 1
B 2
C 3
;RUN;

* Print dataset in order to check whether everything worked;
PROC PRINT DATA=a; 
RUN;

DATA b;
INPUT Trt$ y;
DATALINES;
D 1
E 2
F 3
;RUN;

PROC PRINT DATA=b;
RUN;

/* add the two datasets "a" and "b" underneath each other and call the resulting dataset "c" */
/*********************************************************************************************/
DATA c;
SET a b;
RUN;

PROC PRINT DATA=c;
RUN;

/* merge the two datasets "a" and "b" by their common y values and call the resulting dataset "d" */
/**************************************************************************************************/
* Step 1: rename trt columns in both datasets so that they dont have the same name;
DATA a;
SET a;
RENAME trt=trt_a;
RUN;

DATA b;
SET b;
RENAME trt=trt_b;
RUN;

* Step 2: merge a & b according to values in y-column;
DATA d;
MERGE a b;
BY y;
RUN;

PROC PRINT DATA=d;
RUN;

/* adding columns and other dataset manipulations */
/**************************************************/
DATA a2;
SET a;
newcolumn = "text";
triple_y  = 3*y;
extra_y   = log(3**2)*sqrt(constant("pi"));
IF trt_A    = "A" THEN extra_y=5;
IF triple_y > 7   THEN extra_y=99;
RUN; 

PROC PRINT DATA=a2;
RUN;

/* Sort the dataset by the "extra_y" column in descending order */
/****************************************************************/
PROC SORT DATA=a2;
BY DESCENDING extra_y;
RUN;
