///bbcode_decode(bbcode, formatting ds_list, colour ds_list)
/*
BBCode Decode and Draw - By Yesiateyoursheep
Based upon draw_text_rtf.

Original draw_text_rtf script by Miah_84.  Additions by csanyk.  This script may be used or modified freely, no attribution needed.

Description: Reads for BBCode-like tags, and fills 2 ds_lists containing formatting information.
    This script is ran once, so that bbcode_draw will run faster when drawing the formatted text.
    This script will fail if an invalid character is provided in the [c=######] tag.

Returns: Text without BBCode

Arguments:
    argument0 = bbcode-like string to decode
    argument1 = name of the ds_list to create and fill with formatting information.
    argument2 = name of the ds_list to create and fill with colour information.

The string may contain the following syntax:

[b]bold text[/b]
[i]italic text[/i]
[c=RRGGBB]colored text[/c]
I may add more features later on.
*/

/*
local var definitions

next_x, next_y      : the x and y position of the next substring of the formatted RTF draw
rtf_x, rtf_y        : the x and y position of the rtf string
str                 : the raw rtf string, with syntax formatting awaiting parsing;
f_r, f_b, f_i, f_bi : the index of regular, bold, italic, and bold italic fonts
mode                : a control flag that sets the mode that the parser is currently operating in, eg regular, bold, italic, bold&italic
original_color      : temp storage of the original drawing color, so that the function can revert back to it when needed
i, j                : for loop iterator, re-used several times throughout the function
sc3                 : a length-3 substring of str, used to parse the opening tags of the formatting syntax
sc4                 : a length-4 substring of str, used to parse the closing tags of the formatting syntax
sa, sb              : sub-strings of str, which when concatenated together, yield a string equal to str,
//                    omitting a formatting tag.
//                    Used in building the parsed rtf string
h_r, h_g, h_b       : the hex values of a RGB color, broken into the red, green, and blue values
d_r, d_g, d_b       : the dec values of a RGB color, broken into the red, green, and blue values
w                   : "which" color does the hex belong to. A temporary variable used to build the color for the color markup syntax

The ds_maps are used in the last for loop to actually build the markup sentence. Each character is assigned a color and font style using these. this helps to layout the placement for the next character and provide the correct color for each character.
*/
var str, mode, c, i, j, sc3, sc4, sa, sb, h_r, h_b, h_g, d_r, d_g, d_b;

str=argument0;

ds_list_clear(argument1);
ds_list_clear(argument2);

/*
modes
1        = reg
2        = bold
3        = italic
4        = bold & italic
*/
mode     = 1;

//begin parsing the formatting syntax out of the raw rtf string
i=0;
while(i <= string_length(str)) {
    i++;
    if string_copy(str,i,1)=="[" {
        sc3 = string_copy(str, i, 3);
        sc4 = string_copy(str, i, 4);
        if(sc3 == "[b]"){
            if(mode == 1){mode = 2;}
            if(mode == 3){mode = 4;}
            ds_list_insert(argument1, i, mode);
            str = string_replace(str,"[b]", "");
            i--;
        }
        else if(sc4 = "[/b]"){
            if(mode == 2){mode = 1;}
            if(mode == 4){mode = 3;}
            ds_list_insert(argument1, i, mode);
            str = string_replace(str,"[/b]", "");
            i--;
        }
        else if(sc3 == "[i]"){
            if(mode == 1){mode = 3;}
            if(mode == 2){mode = 4;}
            ds_list_insert(argument1, i, mode);
            str = string_replace(str,"[i]", "");
            i--;
        }
        else if(sc4 == "[/i]"){
            if(mode == 3){mode=1;}
            if(mode == 4){mode=2;}
            ds_list_insert(argument1, i, mode);
            str = string_replace(str,"[/i]", "");
            i--;
        }
        else if(sc3 == "[c="){
            h_r = string_copy(str, i + 3, 2);
            h_g = string_copy(str, i + 5, 2);
            h_b = string_copy(str, i + 7, 2);
            d_r = hextodec(h_r);
            d_g = hextodec(h_g);
            d_b = hextodec(h_b);
            c = make_color_rgb(d_r, d_g, d_b);
            ds_list_insert(argument2, i, c);
            str = string_replace(str,"[c=" + h_r + h_g + h_b + "]", ""); //only replaces the first one, not all
            i--;
        }
        else if(sc4 == "[/c]"){
            ds_list_add(argument2, i, 0);
            str = string_replace(str,"[/c]", "");
            i--;
        }
    }
}

return str;
