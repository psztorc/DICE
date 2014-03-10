* Cleanup
PRSTP =.015;
ELASMU=1.45;
miu.lo(t)=.001;
miu.fx("1")= 0.039;
tatm.fx("1")=0.8;

RR(t)=1/((1+prstp)**(TSTEP*(ord(T)-1)));
optlrsav = (dk + .004)/(dk + .004*elasmu + prstp)*gama;