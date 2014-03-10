* Stern Scenario

PRSTP =.001;
ELASMU=1.01;

RR(t)=1/((1+prstp)**(TSTEP*(ord(T)-1)));
OPTLRSAV = (DK + .004)/(DK + .004*ELASMU + PRSTP)*GAMA;

* Solve

solve CO2 maximizing UTILITY using nlp ;
solve CO2 maximizing UTILITY using nlp ;

* Definition of STERN results
SCC(T) = -1000*eeq.m(t)/yy.m(t);


