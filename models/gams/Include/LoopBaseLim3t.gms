*The Loop Procedure
Loop (TSP_mup,

*     Set this value directly (easier for scalars than vectors [below])
     t2xco2 = TSP_mup.val;

*     Redeclare some later steps
     lam = fco22x/t2xco2;
     c1 =  c10 + c1beta*(t2xco2-2.9);


     Loop (incrementtfp,
*              Scale Up the original values by a factor.
*              al(t) = albase(t)*((1+incrementtfp.val)**(5*(t.val-1)));
               Loop(T, al(t) =    albase(t)    *  mup(T,incrementtfp,"gTFP_LA_H") ;);

            Loop (incrementpop,
*              Scale Up the original values by a factor.
*              L(t) = Lbase(t)*((1+incrementpop.val)**(5*(t.val-1)));
              Loop(T, L(t) = lbase(t) *  mup(T,incrementpop,"gPOP_mup") ;) ;

*Normal 'def_base' file.
$include Include\def_base_3t.gms

*Special 'Put' file (keeps track of multiple runs).
$include Include\PutLoop.gms
$include Include\def_base_3t_cleanup.gms

); ); );