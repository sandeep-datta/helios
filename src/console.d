//import deimos;

alias ubyte uint8;
alias ushort uint16;
alias uint uint32;
alias ulong uint64;

class Console
{
    private static uint16 * _videoMem = cast(uint16 *)0xB8000;
    private static uint32 _backColor;
    private static uint32 _foreColor;
    private static uint32 _x;
    private static uint32 _y;
    
    public static void clear()
    {
       // Make an attribute byte for the default colours
       uint8 attributeByte = (0 /*black*/ << 4) | (15 /*white*/ & 0x0F);
       uint16 blank = 0x20 /* space */ | (attributeByte << 8);

       
       for (int i = 0; i < 80*25; i++)
       {
           _videoMem[i] = blank;
       }

       
       _x = 0;
       _y = 0;
    }
    
    public static void write(string str)
    {
        foreach(c; str)
        {
           monitor_put(c);
        }
    }
    
    public static void writeln(string str)
    {
        write(str);
        monitor_put('\n');
    }
    
    // Write a single character out to the screen.
    private static void monitor_put(char c)
    {
       // The attribute byte is made up of two nibbles - the lower being the
       // foreground colour, and the upper the background colour.
       uint8  attributeByte = cast(uint8)((_backColor << 4) | (_foreColor & 0x0F));
       
          // The attribute byte is the top 8 bits of the word we have to send to the
       // VGA board.
       uint16 attribute = attributeByte << 8;
       uint16 *location;

       // Handle a backspace, by moving the cursor back one space
       if (c == 0x08 && _x)
       {
           _x--;
       }

       // Handle a tab by increasing the cursor's X, but only to a point
       // where it is divisible by 8.
       else if (c == 0x09)
       {
           _x = (_x+8) & ~(8-1);
       }

       // Handle carriage return
       else if (c == '\r')
       {
           _x = 0;
       }

       // Handle newline by moving cursor back to left and increasing the row
       else if (c == '\n')
       {
           _x = 0;
           _y++;
       }
       // Handle any other printable character.
       else if(c >= ' ')
       {
           location = _videoMem + (_y*80 + _x);
           *location = c | attribute;
           _x++;
       }

       // Check if we need to insert a new line because we have reached the end
       // of the screen.
       if (_x >= 80)
       {
           _x = 0;
           _y ++;
       }

       // Scroll the screen if needed.
       //scroll();
       // Move the hardware cursor.
       //move_cursor();
    }
}
