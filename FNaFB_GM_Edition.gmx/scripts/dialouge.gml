///dialouge(text,yn,optioncount,option1,option2,...);
//Dialouge always returns answer in global.input
with instance_create(0,368,objDialouge) {
    text=argument[0];
    yn=argument[1];
    if instance_exists(objFreddy)&&other.id==objFreddy.id {
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
