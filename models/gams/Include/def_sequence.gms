$ontext

A sort of 'version' of def_loop, but where there are individual trials.

$offtext

Sets

    Scenarios_seq      total scenarios considered                  /1*125/

    Vars_seq                 total vars to change                  /TSP_seq, gPOP_seq, gTFP_seq/
    Vars_seq_time(Vars_seq)  vars which involve vectors            /gPOP_seq, gTFP_seq/

    T_seq(T)         a subset of T (the times periods altered)     /1*19/
    T_stop_seq(T)    subset of T (periods of no change);
    T_stop_seq(t)   =    not T_seq(t);



$include SequenceData.gms

Parameters mup_seq(T,Scenarios_seq,Vars_seq_time)  array of scaling vars

*Initial Periods are rescaled by a number selected from this array
Loop(Vars_seq_time,
     Loop(Scenarios_seq,
          Loop(T_seq,

*   Value raised to the power of 'years past since t=0', with 2010 being x^0=1 in all cases.
          mup_seq(T_seq,Scenarios_seq,Vars_seq_time)= (mupTable_seq(Scenarios_seq,Vars_seq_time))**((T_seq.val-1)*tstep)  ;

); ); );

*Later periods remain scaled at the period 20 array, whatever it was.
Loop(Vars_seq_time,
     Loop(Scenarios_seq,
          Loop(T_stop_seq,

          mup_seq(T_stop_seq,Scenarios_seq,Vars_seq_time)= mup_seq("19",Scenarios_seq,Vars_seq_time)

); ); );


*check our work
display mup_seq;