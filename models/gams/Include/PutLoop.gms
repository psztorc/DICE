*File I/O - Inputs Outputs

* Define a new run using a special row
put "New Run";

*Identifying Information for this Run

put ord(TSP_mup);
put ord(incrementtfp);
put ord(incrementpop);

put "Temperature Sensitivity Parameter";
put "Total Factor Productivity Growth";
put "Population Level";

put TSP_mup.val;
put mupTable("gTFP_mup",incrementtfp);
put mupTable("gPOP_mup",incrementpop);
put /;

*Put the Data
$include Include\PutOutputAllT.gms