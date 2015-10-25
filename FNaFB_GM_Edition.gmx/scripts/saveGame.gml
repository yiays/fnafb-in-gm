///saveGame(file);
//A backward compatable version of GameMaker's built in save_game() function
//  Only has the essensials for this game, so can't be copied elsewhere

//  This is a very early concept of how the real saveload system will work, this lacks
//    quite a few critical variables, future versions of loadGame will resort to default
//    values in future versions.
file_delete(argument0);
file_delete(argument0+".meta");

//Save slotx.fnafb.meta
ini_open(argument0+".meta");
    ini_write_real("meta","exists",1);
    ini_write_real("meta","saveslot",global.saveslot);
    ini_write_real("meta","copyright",global.copyright);
    ini_write_real("meta","gamemode",global.gamemode);
    ini_write_real("meta","version",100*version+10*major+minor);
    if instance_exists(objFreddy) ini_write_real("data","freddy",1);
    ini_write_real("meta","gametime",ctrlGame.gametime);
    ini_write_real("meta","rm",room);
ini_close();

//Save slotx.fnafb
ini_open(argument0);
//Save data for ctrlGame
    ini_write_real("ctrlGame","exists",1);
    ini_write_real("ctrlGame","gametime",ctrlGame.gametime);
    ini_write_real("ctrlGame","rmpower",ctrlGame.rmpower);
    ini_write_real("ctrlGame","rmindex",ctrlGame.rmindex);

//Save data for Freddy
if instance_exists(objFreddy) {
    ini_write_real("objFreddy","exists",1);
    //variables
    ini_write_real("objFreddy","x",objFreddy.x);
    ini_write_real("objFreddy","y",objFreddy.y);
    ini_write_real("objFreddy","image_speed",objFreddy.image_speed);
    ini_write_real("objFreddy","image_index",objFreddy.image_index);
    ini_write_real("objFreddy","udlri",objFreddy.udlri);
    ini_write_real("objFreddy","pudlr",objFreddy.pudlr);
    ini_write_real("objFreddy","dspeed",objFreddy.dspeed);
    ini_write_real("objFreddy","mspeed",objFreddy.mspeed);
    ini_write_real("objFreddy","onstage",objFreddy.onstage);
    ini_write_real("objFreddy","tped",objFreddy.tped);
    ini_write_real("objFreddy","moved",objFreddy.moved);
    ini_write_real("objFreddy","move",objFreddy.move);
    ini_write_real("objFreddy","transatack",objFreddy.transattack);
    ini_write_real("objFreddy","steps",objFreddy.steps);
    ini_write_real("objFreddy","hth",objFreddy.hth);
    ini_write_real("objFreddy","mxhth",objFreddy.mxhth);
    ini_write_real("objFreddy","skl",objFreddy.skl);
    ini_write_real("objFreddy","mxskl",objFreddy.mxskl);
    ini_write_real("objFreddy","atk",objFreddy.atk);
    ini_write_real("objFreddy","def",objFreddy.def);
    ini_write_string("objFreddy","eff",objFreddy.eff);
    ini_write_real("objFreddy","lvl",objFreddy.lvl);
    ini_write_real("objFreddy","xp",objFreddy.xp);
    //data structures
    ini_write_string("objFreddy","ds_items",ds_list_write(objFreddy.items));
    ini_write_string("objFreddy","ds_itemq",ds_list_write(objFreddy.itemq));
    ini_write_string("objFreddy","ds_hands",ds_list_write(objFreddy.hands));
    ini_write_string("objFreddy","ds_handq",ds_list_write(objFreddy.handq));
    ini_write_string("objFreddy","ds_parts",ds_list_write(objFreddy.parts));
    ini_write_string("objFreddy","ds_partq",ds_list_write(objFreddy.partq));
    ini_write_string("objFreddy","ds_keys",ds_list_write(objFreddy.keys));
    ini_write_string("objFreddy","ds_keyq",ds_list_write(objFreddy.keyq));
    ini_write_string("objFreddy","ds_equ",ds_list_write(objFreddy.equ));
    ini_write_string("objFreddy","ds_skills",ds_list_write(objFreddy.skills));
}
//More objects to come
ini_close();

//Encode slotx.fnafb
var a=file_text_open_read(argument0) save="";
while !file_text_eof(a) {
    save+=file_text_read_string(a)+chr(13)+chr(10);
    file_text_readln(a);
}
file_text_close(a);
file_delete(argument0);
file_text_open_write(argument0);
file_text_write_string(a,base64_encode(save));
file_text_close(a);
