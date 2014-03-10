* Cleanup

MIU.up(t)            = limmiu*partfract(t);
MIU.up(t)$(t.val<30) = 1;
MIU.lo(t) = .0001