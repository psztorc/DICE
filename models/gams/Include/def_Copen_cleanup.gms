* Copen Cleanup
partfract(t)$(ord(T)>periodfullpart) = partfractfull;
partfract(t)$(ord(T)<periodfullpart+1) = partfract2010+(partfractfull-partfract2010)*(ord(t)-1)/periodfullpart;
partfract("1")= partfract2010;

MIU.up(t)            = limmiu*partfract(t);
MIU.up(t)$(t.val<30) = 1;
MIU.lo(t) = .001;