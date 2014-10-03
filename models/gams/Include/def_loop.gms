$ontext
LOOPS

The loop process is different for scalars, which are set directly, and
vectors, which are first transformed in an array and then set dynamically.
$offtext

* [Section 1 of 2] Scalar Section (not a function of T)
Set
  TSP_mup      Tsp scalar values    /"1.0","1.4","2.9","4.4","5.9"/;
*  TSP_mup      Tsp scalar values    /"2.034938033"/;

* [Section 2 of 2] Vector Section(variables are a function of T and must be rescaled in a loop (before entering into the model in a later loop))


Sets

    Vars         total vars to change                    /gTFP_mup, gPOP_mup, gTFP_LA,gTFP_LA_H/

    Scenarios    total scenarios considered                /1*5/
    incrementpop(Scenarios) each variable needs a subset   /1*5/
    incrementtfp(Scenarios) each variable needs a subset   /1*5/

    T_loop(T)    a subset of T (the periods altered)       /1*19/
    T_stop(T)    subset of T (periods of no change);
    T_stop(t)   =    not T_loop(t);

*Scenario Information goes here



Table mupTable(Vars,Scenarios)

              1          2            3          4            5
gTFP_mup     .99         .995         1.0        1.005        1.010
gPOP_mup     .99         .995         1.0        1.005        1.010
gTFP_LA      0.993       0.9965       1          1.0035       1.007
gTFP_LA_H    0.992324056 0.996162028  1.0000000  1.003837972  1.007675944;



Parameters mup(T,Scenarios,Vars)  array of scaling vars

*Initial Periods are rescaled by a number selected from this array
Loop(Vars,
     Loop(Scenarios,
          Loop(T_loop,

*   Value raised to the power of 'years past since t=0', with 2010 being x^0=1 in all cases.
          mup(T_loop,Scenarios,Vars)= (mupTable(Vars,Scenarios))**((T_loop.val-1)*tstep)  ;
*          mup(T_loop,Scenarios,Vars)= (mupTable(Vars,Scenarios))**(T_loop.val)  ;

); ); );

*Later periods remain scaled at the period 20 array, whatever it was.
Loop(Vars,
     Loop(Scenarios,
          Loop(T_stop,

          mup(T_stop,Scenarios,Vars)= mup("19",Scenarios,Vars)

); ); );




*check our work
display mup;

file mupOutput /output\1_ScalingTable.csv/; mupOutput.nd = 10 ; mupOutput.nw = 0 ; mupOutput.pw=1200; put mupOutput; mupOutput.pc=5;

*Intro and Date Headers
put "Period"; Loop(T, put T.val ); put /;
put "Date"; Loop(T, put (((T.val-1)*tstep)+2010) ); put /;

*Calculated Data
Loop(Vars,

     Loop(Scenarios,

          put Vars.te(Vars) ;
          Loop(T, put mup(T,Scenarios,Vars); );
          put /;

 ); );


putclose;