///draw_text_rtf(x, y, string, regular_font, bold_font, italic_font, bold_italic_font)
/*
Original draw_text_rtf script by Miah_84.  Additions by csanyk.  This script may be used or modified freely, no attribution needed.

Description: Draws a formatted string using BBCode-like syntax for internal formatting within the string.

Returns: void

Caution:  Only works for halign==left.  Not intended to draw centered or right-aligned text.


argument0 = the x position of the string
argument1 = the y position of the string
argument2 = the string.
argument3 = the regular font
argument4 = the bold font
argument5 = the italic font
argument6 = the bold italic font

The string may contain the following syntax:

[b]bold text[/b]
[i]italic text[/i]
[c=RRGGBB]colored text[/c]
TODO: [c_name=named_color]colored text using named color[/c_name] (not yet implemented)
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
p1, p2              : the first and second digits of a 2-digit hex value for a given RGB color channel
w                   : "which" color does the hex belong to. A temporary variable used to build the color for the color markup syntax
col_map             : a ds_map of the rtf string containing info about the color formatting
rtf_map             : a ds_map of the rtf string containing info about the bold and italic formatting

The ds_maps are used in the last for loop to actually build the markup sentence. Each character is assigned a color and font style using these. this helps to layout the placement for the next character and provide the correct color for each character.
*/
var next_x, next_y, rtf_x, rtf_y, str, f_r, f_b, f_i, f_bi, mode, original_color, c, i, j, sc3, sc4, sa, sb, h_r, h_b, h_g, d_r, d_g, d_g, p1, p2, w;

next_x = 0;
next_y = 0;

rtf_x  = argument0;
rtf_y  = argument1;
str    = argument2;

f_r    = argument3;
f_b    = argument4;
f_i    = argument5;
f_bi   = argument6;


original_color = draw_get_color();
c        = original_color;
rtf_map  = ds_map_create();
col_map  = ds_map_create();

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
while(i<string_length(str)) {
    i++;
    sc3 = string_copy(str, i, 3);
    sc4 = string_copy(str, i, 4);
    if(sc3 == "[b]"){
        if(mode == 1){mode = 2;}
        if(mode == 3){mode = 4;}
        sa = string_copy(str, 0, i-1);
        sb = string_copy(str, i+3, string_length(str) - i - 2);
        str = sa + sb;
        i--;
    }
    if(sc4 = "[/b]"){
        if(mode == 2){mode = 1;}
        if(mode == 4){mode = 3;}
        sa = string_copy(str, 0, i-1);
        sb = string_copy(str, i+4, string_length(str) - i - 3);
        str = sa + sb;
        i--;
    }
    if(sc3 == "[i]"){
        if(mode == 1){mode = 3;}
        if(mode == 2){mode = 4;}
        sa = string_copy(str, 0, i-1);
        sb = string_copy(str, i+3, string_length(str) - i - 2);
        str = sa + sb;
        i--;
    }
    if(sc4 == "[/i]"){
        if(mode == 3){mode=1;}
        if(mode == 4){mode=2;}
        sa = string_copy(str, 0, i-1);
        sb = string_copy(str, i+4, string_length(str) - i - 3);
        str = sa + sb;
        i--;
    }
    ds_map_add(col_map, i - 1, c);
    if(sc3 == "[c="){
        h_r = string_copy(str, i + 3, 2);
        h_g = string_copy(str, i + 5, 2);
        h_b = string_copy(str, i + 7, 2);
        d_r = hextodec(h_r);
        d_g = hextodec(h_g);
        d_b = hextodec(h_b);
        c = make_color_rgb(d_r, d_g, d_b);
        ds_map_replace(col_map, i, c);
        str = string_replace(str,"[c=" + h_r + h_g + h_b + "]", ""); //only replaces the first one, not all
        i--;
    }
    if(sc4 == "[/c]"){
        c = original_color;
        ds_map_replace(col_map, i, c);
        sa = string_copy(str, 0, i - 1);
        sb = string_copy(str, i + 4, string_length(str) - i - 3);
        str = sa + sb;
        i--;
    }
    ds_map_add(rtf_map, i, mode);
}

//draw the formatted rtf string to the screen
i=0;
while(i<string_length(str)){
    i++;
    if(string_copy(str, i, 1) == "#"){next_x = 0; next_y += string_height("#");}
    else if(next_x>room_width){next_x = 0; next_y += string_height("#");}
    if !is_undefined(ds_map_find_value(col_map, i)) draw_set_color(ds_map_find_value(col_map, i));
    switch(ds_map_find_value(rtf_map, i)){
        case 1:
        draw_set_font(f_r);
        draw_text(rtf_x + next_x, rtf_y + next_y, string_copy(str, i, 1));
        next_x += string_width(string_copy(str, i, 1));
        break;
        case 2:
        draw_set_font(f_b);
        draw_text(rtf_x + next_x, rtf_y + next_y, string_copy(str, i, 1));
        next_x += string_width(string_copy(str, i, 1));
        break;
        case 3:
        draw_set_font(f_i);
        draw_text(rtf_x + next_x, rtf_y + next_y, string_copy(str, i, 1));
        next_x += string_width(string_copy(str, i, 1));
        break;
        case 4:
        draw_set_font(f_bi);
        draw_text(rtf_x + next_x, rtf_y + next_y, string_copy(str, i, 1));
        next_x += string_width(string_copy(str, i, 1));
        break;
    }//end switch
}

//reset color
draw_set_color(original_color);
draw_set_font(fntMain);
//free up the ds_maps
ds_map_destroy(rtf_map);
ds_map_destroy(col_map);

