*The Sequence Procedure
Loop (Scenarios_seq,

*     Set this value directly (easier for scalars than vectors [below])
     t2xco2 = mupTable_seq(Scenarios_seq,"TSP_seq");

*     Redeclare some later steps
     lam = fco22x/t2xco2;
     c1 =  c10 + c1beta*(t2xco2-2.9);



*     Scale Up the original tfp values by a factor.
      Loop(T, al(t) = albase(t) * mup_seq(T,Scenarios_seq,"gTFP_seq") ;);

*     Scale Up the original pop values by a factor.
      Loop(T, L(t) = lbase(t) *  mup_seq(T,Scenarios_seq,"gPOP_seq") ;) ;

*Normal 'def_base' file.
$include Include\def_base.gms

*Special 'Put' file (keeps track of multiple runs).
$include Include\PutSeq.gms
$include Include\def_base_cleanup.gms

);