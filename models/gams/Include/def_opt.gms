*Optimization
*This fixes cprice('1') at 1$, for realism, without introducing a cprice constraint.
miu.up('1') = miu0;
*No additional constraints

* Solve
solve CO2 maximizing UTILITY using nlp ;
solve CO2 maximizing UTILITY using nlp ;


* Results
SCC(T) = -1000*eeq.m(t)/yy.m(t);