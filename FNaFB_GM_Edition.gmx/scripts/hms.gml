///hms(h,m,s);
var i, h, m, s;
i="";

s = argument0;

h = floor(s / 3600);
if(h < 10) h = "0"+string(h);
m = floor(s / 60);
if(m < 10) m = "0"+string(m);
s = floor(s mod 60);
if(s < 10) s = "0"+string(s);
//Creates the time in H:M:S format
i = string(h)+':'+string(m)+':'+string(s);

return i;
