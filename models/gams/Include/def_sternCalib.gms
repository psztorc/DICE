*Calibrated Stern Scenario

PRSTP =.001;
ELASMU=2.1;
miu.lo(t)=.01;
miu.fx("1")= 0.038976;
tatm.fx("1")=0.83;

RR(t)=1/((1+prstp)**(TSTEP*(ord(T)-1)));
OPTLRSAV = (DK + .004)/(DK + .004*ELASMU + PRSTP)*GAMA;

* Solve
solve CO2 maximizing UTILITY using nlp ;
solve CO2 maximizing UTILITY using nlp ;
solve CO2 maximizing UTILITY using nlp ;

* Definition of STERN results
SCC(T) = -1000*eeq.m(t)/yy.m(t);