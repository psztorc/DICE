* Base3t Cleanup

a20=0.00267 ;
a2 =0.00267 ;

*Limit on miu increase per period = .1
MIU.up(t)$(t.val<30) =  1;

*Lower limit savings rate
s.lo(t)=.01;
S.FX(lag10(t)) = optlrsav;

*Addition of Temperature Constraint
TATM.up(t)  = 15;