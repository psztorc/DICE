
*Gams crashes if you fail to take into account pbacktime (as it produces a MIU over 1).
cprice.lo(t)$(t.val<tnopol+1)    =  min( (AmpereCpriceBoundary(T) ), pbacktime(T) );

*model co2amp /all/;
solve CO2 maximizing UTILITY using nlp ;
solve CO2 maximizing UTILITY using nlp ;
solve CO2 maximizing UTILITY using nlp ;

*Post-Equation Parameter-Assignment
scc(T) = -1000*eeq.m(t)/yy.m(t);

