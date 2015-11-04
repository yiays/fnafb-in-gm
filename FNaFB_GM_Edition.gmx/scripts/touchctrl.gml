///touchctrl(destroy[,conditionalkeep]);
/* TouchCtrl - The all-in-one script for controling on screen buttons.
    conditionalkeep - Don't destroy touch controls if usemouse is disabled
*/
if argument[0] { //Destroy
    if instance_exists(ctrlTouch) {
        if argument[1]{
            if global.usemouse {
                //Destroy
                with(ctrlTouch){
                    instance_destroy();
                }
                return 1;
            } else {
                //Keep
                return 0;
            }
        } else {
            //Destroy
            with(ctrlTouch){
                instance_destroy();
            }
            return 1;
        }
    } else {
        //Already destroyed
        return 1;
    }
} else if global.touch {
    if !instance_exists(ctrlTouch) {
        //Create
        instance_create(0,0,ctrlTouch);
        return 1;
    } else {
        //Keep
        return 0;
    }
}
