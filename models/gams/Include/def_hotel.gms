*START Hotelling rent calculation
* This is only necessary when economy uses up carbon resources (cca(last)>fosslim)
a2 = 0;
solve CO2 maximizing UTILITY using nlp;
photel(t)=cprice.l(t);
*END Hotelling rent calculation
*assign as constraint
cprice.up(t)$(t.val<tnopol+1) = max(photel(t),cpricebase(t));
*restore damages
a2 = a20;