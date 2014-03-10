
*Describing the participation fraction.

set tamp(t)  ampere import set       /1*19/
    tnamp(t) other time periods;
tnamp(t) = not tamp(t);

parameter
AmpereCpriceBoundary(T)  Value under Ampere, below which cprice cant fall;

set j ImportSyntax /amperecpriceimport/;
table Import(tamp,j) 'Variables to Import'
$ondelim
dummy,amperecpriceimport

1,12.5
2,15.21
3,18.5
4,22.5
5,27.4
6,33.3
7,40.55
8,49.3
9,60
10,73
11,88.8
12,108.1
13,131.5
14,160
15,194.65
16,236.8
17,288.1
18,350.55
19,426.5

$offdelim

Loop(tamp, AmpereCpriceBoundary(tamp)= Import(tamp,"amperecpriceimport"); );
Loop(tnamp, AmpereCpriceBoundary(tnamp)= Import("19","amperecpriceimport"); );