$ontext

A sort of 'version' of def_loop, but where there are individual trials.

$offtext

Sets

    Scenarios_seq      total scenarios considered                   /1*10/

    Vars_seq                 total vars to change            /TSP_seq, gPOP_seq, gTFP_seq/
    Vars_seq_time(Vars_seq)  vars which involve vectors      /gPOP_seq, gTFP_seq/

    incrementpop_seq(Scenarios_seq)  each variable needs a subset   /1*10/
    incrementtfp_seq(Scenarios_seq)  each variable needs a subset   /1*10/

    T_seq(T)         a subset of T (the periods altered)       /1*19/
    T_stop_seq(T)    subset of T (periods of no change);
    T_stop_seq(t)   =    not T_seq(t);



Table mupTable_seq(Vars_seq,Scenarios_seq)
                 1           2            3           4            5            6           7           8            9           10
TSP_seq     2.034938033 3.254160271 3.9831757592 2.311649648 2.0366790909 4.6073359922 4.043799395 2.628545186 2.2650378244 2.5621468797
gPOP_seq    1.008890567 1.000233153 0.9916984212 1.009895410 0.9980288824 1.0079129259 1.007537168 0.995929696 0.9926518382 0.9953182182
gTFP_seq    1.000472973 1.002837964 0.9982081797 1.006984925 0.9941410530 0.9929243157 1.000069161 1.001204855 1.0052089556 1.0023710220  ;


Parameters mup_seq(T,Scenarios_seq,Vars_seq)  array of scaling vars

*Initial Periods are rescaled by a number selected from this array
Loop(Vars_seq,
     Loop(Scenarios_seq,
          Loop(T_seq,

*   Value raised to the power of 'years past since t=0', with 2010 being x^0=1 in all cases.
          mup_seq(T_seq,Scenarios_seq,Vars_seq)= (mupTable_seq(Vars_seq,Scenarios_seq))**((T_seq.val-1)*tstep)  ;

); ); );

*Later periods remain scaled at the period 20 array, whatever it was.
Loop(Vars_seq,
     Loop(Scenarios_seq,
          Loop(T_stop_seq,

          mup_seq(T_stop_seq,Scenarios_seq,Vars_seq)= mup_seq("19",Scenarios_seq,Vars_seq)

); ); );


*check our work
display mup_seq;