* def Copen
* Note that this is not yet recalibrated

partfract(t) = ImportedPartFrac(t)   ;
MIU.fx(t)   = ImportedMiu(t)    ;
MIU.up("1") = 1.5;
MIU.lo("1") = 0;

display partfract;

* Solve
solve CO2 maximizing UTILITY using nlp ;
solve CO2 maximizing UTILITY using nlp ;

* Results
SCC(T) = -1000*eeq.m(t)/yy.m(t);