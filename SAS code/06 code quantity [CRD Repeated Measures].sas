PROC IMPORT OUT= WORK.repmes 
            DATAFILE= "\\AFS\uni-hohenheim.de\hhome\p\paulschm\MY-DATA\D
esktop\SAS Jan\05 data repeated measures.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

/* Shorten column names */
DATA repmes;
SET  repmes;
RENAME Sampling=Week Treatment=Trt;
RUN;

DATA repmes;
SET  repmes;
plotID = CATS("S",Soil,"-T", Trt,"-R", Replicate);
RUN;


PROC MIXED DATA=repmes;
CLASS Soil Trt Week plotID;
MODEL Quantity = Soil Trt Week 
				 Soil*Trt Soil*Week Trt*Week
				 Soil*Trt*Week  /DDFM=KR;
REPEATED Week /SUBJECT=plotID TYPE=AR(1);
RUN;
* Soil*Trt*Week is n.s. - Drop it from model;

/***************/
/* Final Model */
/***************/
PROC MIXED DATA=repmes PLOTS=studentpanel;
CLASS Soil Trt Week plotID;
MODEL Quantity = Soil Trt Week 
				 Soil*Trt Soil*Week Trt*Week /DDFM=KR;
REPEATED Week /SUBJECT=plotID TYPE=AR(1);
RUN; *Everything is significant;



PROC MIXED DATA=repmes;
WHERE Week=1;
CLASS Soil Trt;
MODEL Quantity = Soil Trt Soil*Trt /DDFM=KR;
LSMEANS Soil*Trt /PDIFF;
ODS OUTPUT LSMEANS=mylsmeans;
RUN;

/* Get Letter Display 
PROC GLIMMIX DATA=repmes;
WHERE Week=1;
CLASS Soil Trt;
MODEL Quantity = Soil Trt Soil*Trt /DDFM=KR;
LSMEANS Soil*Trt /PDIFF LINES;
RUN;
*/

DATA mylsmeans;
SET  mylsmeans;
low = Estimate - StdErr;
upp = Estimate + StdErr;
RUN;

PROC SGPLOT DATA=mylsmeans;
VBARPARM RESPONSE=Estimate CATEGORY=Soil/ GROUP=Trt GROUPDISPLAY=CLUSTER 
										  LIMITLOWER=low LIMITUPPER=upp;
XAXIS LABEL="My label";
YAXIS LABEL="y-axis";
RUN;
