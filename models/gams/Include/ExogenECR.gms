
 set tecr(t)  ampere import set       /1*27/
    tnecr(t) other time periods;
    tnecr(t) = not tecr(t);

*Describing the participation fraction.
set jj ImportSyntax2 /copenecrimport/;
table Import2(tecr,jj) 'Variables to Import'
$ondelim
dummy,copenecrimport
1,0.02
2,0.055874801
3,0.110937151
4,0.163189757
5,0.206247482
6,0.241939219
7,0.30180914
8,0.364484979
9,0.423670192
10,0.478283881
11,0.534073643
12,0.588156847
13,0.633622
14,0.672457
15,0.705173102
16,0.733018573
17,0.756457118
18,0.776297581
19,0.794110815
20,0.822197128
21,0.839125811
22,0.854453754
23,0.868106413
24,0.880485825
25,0.891631752
26,0.901741794
27,0.9
$offdelim

PARAMETER
ImportedMiu(t)   The Emissions Control Rate Imported;

Loop(tecr, ImportedMiu(tecr)= Import2(tecr,"copenecrimport"); );
Loop(tnecr ,ImportedMiu(tnecr)= Import2("27","copenecrimport"); );


