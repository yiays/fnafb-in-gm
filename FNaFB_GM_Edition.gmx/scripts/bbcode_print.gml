///bbcode_print(x, y, string, ds_formatting, ds_colour, regular_font, bold_font, italic_font, bold_italic_font)
/*
BBCode Decode and Draw - By Yesiateyoursheep
Based upon draw_text_rtf.

Original draw_text_rtf script by Miah_84.  Additions by csanyk.  This script may be used or modified freely, no attribution needed.

Description: Draws a formatted string using ds_lists for colour and text style. Generated in bbcode_decode
    This version groups together text that has all the same formatting and draws it all at once, which cuts a lot of fat off of the execution time.

Returns: void

Caution:  Only works for halign==left.  Not intended to draw centered or right-aligned text.


argument0 = the x position of the string
argument1 = the y position of the string
argument2 = the string.
argument3 = ds_list that contains formatting info from bbcode_decode
argument4 = ds_list that contains colour info from bbcode_decode
argument5 = the regular font
argument6 = the bold font
argument7 = the italic font
argument8 = the bold italic font
*/

/*
local var definitions

next_x, next_y      : the x and y position of the next substring of the formatted RTF draw
rtf_x, rtf_y        : the x and y position of the rtf string
str                 : the raw rtf string, with syntax formatting awaiting parsing;
f_r, f_b, f_i, f_bi : the index of regular, bold, italic, and bold italic fonts
mode                : a control flag that sets the mode that the parser is currently operating in, eg regular, bold, italic, bold&italic
original_color      : temp storage of the original drawing color, so that the function can revert back to it when needed
c                   : the current colour being used to draw text
i                   : for loop iterator, re-used several times throughout the function

*/
var next_x, next_y, rtf_x, rtf_y, str, f_r, f_b, f_i, f_bi, mode, original_color, c, i, dnow, dstr, dnowstr, dc, dmode;

next_x = 0;
next_y = 0;

rtf_x  = argument0;
rtf_y  = argument1;
str    = argument2;

f_r    = argument5;
f_b    = argument6;
f_i    = argument7;
f_bi   = argument8;

dnow=0;
dstr="";
dnowstr="";
dc=0;
dmode=1;

original_color = draw_get_color();
c = original_color;

/*
modes
1        = reg
2        = bold
3        = italic
4        = bold & italic
*/
mode     = 1;

//draw the formatted rtf string to the screen
i=0;
while(i<=string_length(str)){
    i++;
    if i==string_length(str)+1{
        dnow=1;
        dmode=mode;
        dc=c;
        dnowstr=dstr;
    }
    if !is_undefined(ds_list_find_value(argument3,i)) {//Change in text style
        dmode=mode;
        mode=ds_list_find_value(argument3,i);
        dnow=1;
        dnowstr=dstr;
        dstr=string_copy(str,i,1);
    }
    if !is_undefined(ds_list_find_value(argument4,i)) {//Change in colour
        dc=c;
        c=ds_list_find_value(argument4,i);
        if c==0 c=original_color;
        dnow=1;
        dnowstr=dstr;
        dstr=string_copy(str,i,1);
    }
    if(string_copy(str, i, 1) == "#"){ next_x = 0; next_y += string_height("#");}
    if dnow {
        draw_set_color(dc);
        switch(dmode){
            case 1:
                draw_set_font(f_r);
                draw_text(rtf_x + next_x, rtf_y + next_y, dnowstr);
                next_x += string_width(dnowstr);
            break;
            case 2:
                draw_set_font(f_b);
                draw_text(rtf_x + next_x, rtf_y + next_y, dnowstr);
                next_x += string_width(dnowstr);
            break;
            case 3:
                draw_set_font(f_i);
                draw_text(rtf_x + next_x, rtf_y + next_y, dnowstr);
                next_x += string_width(dnowstr);
            break;
            case 4:
                draw_set_font(f_bi);
                draw_text(rtf_x + next_x, rtf_y + next_y, dnowstr);
                next_x += string_width(dnowstr);
            break;
        }
        dnow=0;
    } else {
        dstr+=string_copy(str,i,1);
    }
}

//reset color
draw_set_color(original_color);
