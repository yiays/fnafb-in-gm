///dialouge(text,yn,optioncount,option1,option2,...);
//Dialouge always returns answer in global.input
with instance_create(0,368,objDialouge) {
    text=argument[0];
    yn=argument[1];
    if other==instance_find(objFreddy,0) {
        avatar=other.saychar;
    } else {
        avatar=-1;
    }
    var i=0;
    options=argument[2];
    repeat(argument[2]) {
        otext[i]=argument[i+3];
        i++;
    }
}
