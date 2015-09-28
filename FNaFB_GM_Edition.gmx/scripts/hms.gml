///hms(h,m,s);
var i="";
if argument0<10 {
    i+="0"+string(argument0)+":";
} else {
    i+=string(argument0)+":";
}
if argument1<10 {
    i+="0"+string(argument1)+":";
} else {
    i+=string(argument1)+":";
}
if argument2<10 {
    i+="0"+string(argument2);
} else {
    i+=string(argument2);
}
return i;
