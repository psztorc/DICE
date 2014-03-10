set tcop(t)  ampere import set       /1*19/
    tncop(t) other time periods;
    tncop(t) = not tcop(t);

*Describing the participation fraction.
set jjj ImportSyntax3 /copenpfimport/;
table ImportCPF(tcop,jjj) 'Variables to Import'
$ondelim
dummy,copenpfimport
1,0.2
2,0.390423082
3,0.379051794
4,0.434731269
5,0.42272216
6,0.410416777
7,0.707776548
8,0.692148237
9,0.840306905
10,0.834064356
11,0.939658852
12,0.936731085
13,0.933881267
14,0.930944201
15,0.928088049
16,0.925153812
17,0.922301007
18,0.919378497
19,1
$offdelim

PARAMETER
ImportedPartFrac(t)   The (Copen) participation fraction imported;

Loop(tcop, ImportedPartFrac(tcop)= ImportCPF(tcop,"copenpfimport"); );
Loop(tncop, ImportedPartFrac(tncop)= ImportCPF("19","copenpfimport"); );