data dat;
input
block    plot      N    yield;
lackfit = N;
datalines;
  1        1      70     27.5
  1        2      35     20.3
  1        3     105     31.4
  1        4     140     28.1
  1        5       0      9.9
  2        6     140     25.7
  2        7      70     30.3
  2        8       0      7.8
  2        9      35     22.6
  2       10     105     27.2
  3       11     105     33.4
  3       12       0     10.7
  3       13      35     23.9
  3       14     140     31.9
  3       15      70     29.2
;
RUN;

ODS HTML CLOSE; ODS HTML; *clear results viewer;

PROC SGPLOT DATA=dat;
SCATTER Y=yield X=N /GROUP=Block;
RUN;

* simple linear regression with block effect;
PROC GLM DATA=dat;
CLASS Block;
MODEL yield =       N   Block   /SOLUTION;
     *yield = a    +   b *N + Block_i   with i={1,2,3};
     *yield = 16.5 + 0.13*N + [-2.4, -3.1, 0];
RUN;

*********************;
* Lack-of-fit method ;
*   lackfit is copy of N, but treated as categorcial variable;

* Polynomial degree = 0;
PROC GLM DATA=dat;
CLASS Block lackfit;
MODEL yield = Block lackfit;
RUN; *lackfit is significant. Try next model;

* Polynomial degree = 1;
PROC GLM DATA=dat;
CLASS Block lackfit;
MODEL yield = N Block lackfit;
RUN; *lackfit is significant. Try next model;

* Polynomial degree = 2;
PROC GLM DATA=dat;
CLASS Block lackfit;
MODEL yield = N N*N Block lackfit;
RUN; *lackfit is n.s. -> This is our model!

*************************************************;

*polynomial regression with block effect;
PROC GLM DATA=dat PLOTS(UNPACK)=DIAGNOSTICS;
CLASS Block;
MODEL yield =             N     N*N     Block   /SOLUTION;
     *yield = a    +   b *N  +  c*N²     + Block_i         with i={1,2,3};
RUN; *yield = 11.5 + 0.42*N  + -0.002*N² + [-2.4, -3.1, 0]

*avg-Block: yield = 11.5 + 0.42*N  + -0.002*N² - 1.83
            yield = 9.67 + 0.42*N  + -0.002*N²         ;

*******************************************************;
