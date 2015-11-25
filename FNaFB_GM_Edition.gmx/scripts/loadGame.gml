///loadGame(file);
//A backward compatable version of GameMaker's built in game_load() function
//  Only has the essensials for this game, so can't be copied elsewhere

//  This is a very early concept of how the real saveload system will work, this lacks
//    quite a few critical variables, loadGame will resort to default values when data
//    is missing, a version variable in the .fnafb.meta file will allow loadGame to
//    work around critical missing data, if I code for it to handle it.

//Backward compatability system global.legacy=0 for current version, or anything else
//  for an older version.

if file_exists(argument0)&&file_exists(argument0+".meta") {
    //Open .fnafb.meta
    ini_open(argument0+".meta");
        global.copyright=ini_read_real("meta","copyright",1);
        global.gamemode=ini_read_real("meta","gamemode",0);
        var realrm=ini_read_real("meta","rm",rmStage);
        room_goto(realrm);
        if ini_read_real("meta","version",-1)!=100*version+10*major+minor global.legacy=ini_read_real("meta","version",-1);
        else global.legacy=0;
    ini_close();
    
    if global.legacy==0 { //002 was the first version with saves.
        //Decode .fnafb
        var a=file_text_open_read(argument0),i="";
        while !file_text_eof(a) {
            i+=file_text_read_string(a)+chr(13)+chr(10);
            file_text_readln(a);
        }
        file_text_close(a);
        i=base64_decode(i);
        ini_open_from_string(i);
        global.ingame=1;
        
        //Load data for ctrlGame
        with(ctrlGame) {
            newgame=0;
            gametime=ini_read_real("ctrlGame","gametime",0);
            rmpower=ini_read_real("ctrlGame","rmpower",0);
            rmindex=ini_read_real("ctrlGame","rmindex",2);
            rm=realrm;
            setchk=0;
            alarm[0]=room_speed*20*(-global.graphics+3);
        }
        
        //Load data for Freddy
        if ini_read_real("objFreddy","exists",0) with(instance_create(ini_read_real("objFreddy","x",256),ini_read_real("objFreddy","y",224),objFreddy)) {
            //variables
            image_speed=ini_read_real("objFreddy","image_speed",image_speed);
            image_index=ini_read_real("objFreddy","image_index",image_index);
            say="0";
            saydelay=-1;
            talking=0;
            udlri=ini_read_real("objFreddy","udlri",udlri);
            pudlr=ini_read_real("objFreddy","pudlr",pudlr);
            dspeed=ini_read_real("objFreddy","dspeed",dspeed);
            mspeed=ini_read_real("objFreddy","mspeed",mspeed);
            onstage=ini_read_real("objFreddy","onstage",onstage);
            tped=ini_read_real("objFreddy","tped",tped);
            moved=ini_read_real("objFreddy","moved",moved);
            move=ini_read_real("objFreddy","move",move);
            transattack=ini_read_real("objFreddy","transatack",transattack);
            steps=ini_read_real("objFreddy","steps",steps);
            hth=ini_read_real("objFreddy","hth",hth);
            mxhth=ini_read_real("objFreddy","mxhth",mxhth);
            skl=ini_read_real("objFreddy","skl",skl);
            mxskl=ini_read_real("objFreddy","mxskl",mxskl);
            atk=ini_read_real("objFreddy","atk",atk);
            def=ini_read_real("objFreddy","def",def);
            eff=ini_read_string("objFreddy","eff",eff);
            lvl=ini_read_real("objFreddy","lvl",lvl);
            xp=ini_read_real("objFreddy","xp",xp);
            //data structures
            ds_list_read(items,ini_read_string("objFreddy","ds_items",ds_list_write(items)));
            ds_list_read(itemq,ini_read_string("objFreddy","ds_itemq",ds_list_write(itemq)));
            ds_list_read(hands,ini_read_string("objFreddy","ds_hands",ds_list_write(hands)));
            ds_list_read(handq,ini_read_string("objFreddy","ds_handq",ds_list_write(handq)));
            ds_list_read(parts,ini_read_string("objFreddy","ds_parts",ds_list_write(parts)));
            ds_list_read(partq,ini_read_string("objFreddy","ds_partq",ds_list_write(partq)));
            ds_list_read(keys,ini_read_string("objFreddy","ds_keys",ds_list_write(keys)));
            ds_list_read(keyq,ini_read_string("objFreddy","ds_keyq",ds_list_write(keyq)));
            ds_list_read(equ,ini_read_string("objFreddy","ds_equ",ds_list_write(equ)));
            ds_list_read(skills,ini_read_string("objFreddy","ds_skills",ds_list_write(skills)));
        }
        //More objects to come
        ini_close();
    } else {
        dialouge("Error! This version of the game isn't compatable with this save file!#Resorting to creating a new game with settings that could be salvaged from the save data...",0,0);
    }
}
