*Realistic Lim3t


a20=0.00000267;
a2 =0.00000267;

*Limit on miu increase per period = .1
MIU.up(t)$(t.val<30) = min(t.val*.1, 1);

*Lower limit savings rate
s.lo(t)=.15;

*Addition of Temperature Constraint
TATM.up(t)  = 3;



solve CO2 maximizing UTILITY using nlp ;
solve CO2 maximizing UTILITY using nlp ;

*Post-Solve Assignment
scc(T) = -1;
If (CO2.modelstat lt 3,
scc(T) = -1000*eeq.m(t)/(yy.m(t));
);