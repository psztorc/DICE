*Base (current policy) Run

*Calculation of Hotelling Rents
$include Include\def_hotel.gms

solve CO2 maximizing UTILITY using nlp ;
solve CO2 maximizing UTILITY using nlp ;

*Post-Solve Assignment
scc(T) = -1;
If (CO2.modelstat lt 3,
scc(T) = -1000*eeq.m(t)/(yy.m(t));
);