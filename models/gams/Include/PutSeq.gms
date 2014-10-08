*File I/O - Inputs Outputs

* Define a new run using a special row
put "New Run";

*Identifying Information for this Run

put ord(Scenarios_seq);
put ord(Scenarios_seq);
put ord(Scenarios_seq);

put "Temperature Sensitivity Parameter";
put "Total Factor Productivity Growth";
put "Population Growth";


put mupTable_seq(Scenarios_seq, "TSP_seq");
put mupTable_seq(Scenarios_seq, "gTFP_seq");
put mupTable_seq(Scenarios_seq, "gPOP_seq");
put /;

*Put the Data
$include Include\PutOutputAllT.gms