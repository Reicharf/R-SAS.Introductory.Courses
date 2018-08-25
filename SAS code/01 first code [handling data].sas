DATA Fertiliser; *This is a comment;
INPUT Variety$ Fert$ Block; *$ tells SAS it is a character variable;
DATALINES;
Limbo A 1
Limbo B 1
Keimige A 1
Keimige B 1
Hardy A 1
Hardy B 1
;RUN;

PROC PRINT DATA=Fertiliser; 
RUN;

*  Way 1 of writing a comment ;
/* Way 2 of writing a comment */

DATA a;
INPUT Trt$ y;
DATALINES;
A 1
B 2
C 3
;RUN;

DATA b;
INPUT Trt$ y;
DATALINES;
D 1
E 2
F 3
;RUN;

*Print both datasets!;
PROC PRINT DATA=a; RUN;
PROC PRINT DATA=b; RUN;

*add two datasets underneath each other;
DATA c;
SET a b;
RUN;

*add two datasets next to each other;
* Step 1: rename trt columns;
DATA a;
SET a;
RENAME trt=trt_a;
RUN;

DATA b;
SET b;
RENAME trt=trt_b;
RUN;

* Step 2: merge a & b according to y-column;
DATA d;
MERGE a b;
BY y;
RUN;

* adding columns etc.;
DATA a2;
SET a;
newcolumn = "text";
triple_y  = 3*y;
extra_y   = log(3**2)*sqrt(constant("pi"));
IF trt_A    = "A" THEN extra_y=5;
IF triple_y > 7   THEN extra_y=99;
RUN; 

* sorting;
PROC SORT DATA=a2;
BY DESCENDING extra_y;
RUN;



















