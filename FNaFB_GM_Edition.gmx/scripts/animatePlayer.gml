///animatePlayer(udlri,speed);
image_speed=argument1/16;
switch argument0 {
    case 0:
        //Up
        if image_index<9 { image_index=9; }
    break;
    case 1:
        //Down
        if image_index>2 { image_index=0; }
    break;
    case 2:
        //Left
        if image_index<3 { image_index=3; }
        if image_index>5 { image_index=3; }
    break;
    case 3:
        //Right
        if image_index<6 { image_index=6; }
        if image_index>8 { image_index=6; }
    break;
    case 4:
        //Idle
        image_speed=0;
    break;
}
