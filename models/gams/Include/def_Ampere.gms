
*run normally a few times
*solve CO2 maximizing UTILITY using nlp ;
*solve CO2 maximizing UTILITY using nlp ;
*solve CO2 maximizing UTILITY using nlp ;



*Gams crashes if you fail to take into account pbacktime (as it produces a MIU over 1).
cprice.fx(t)$(t.val<tnopol+1)  =  min( AmpereCpriceBoundary(T), pbacktime(T) ) ;

solve CO2 maximizing UTILITY using nlp ;

*Post-Equation Parameter-Assignment
scc(T) = -1;
If (CO2.modelstat lt 3,
scc(T) = -1000*eeq.m(t)/(yy.m(t));
);