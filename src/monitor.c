#include "monitor.h"


static int cursor_x = 0, cursor_y = 0, curBackColor = 0, curForeColor = 15;

static uint16 * const video_memory = (uint16 *)0xB8000;

// Scrolls the text on the screen up by one line.
static void scroll()
{

   // Get a space character with the default colour attributes.
   uint8 attributeByte = (0 /*black*/ << 4) | (15 /*white*/ & 0x0F);
   uint16 blank = 0x20 /* space */ | (attributeByte << 8);

   // Row 25 is the end, this means we need to scroll up
   if(cursor_y >= 25)
   {
       // Move the current text chunk that makes up the screen
       // back in the buffer by a line
       int i;
       for (i = 0*80; i < 24*80; i++)
       {
           video_memory[i] = video_memory[i+80];
       }

       // The last line should now be blank. Do this by writing
       // 80 spaces to it.
       for (i = 24*80; i < 25*80; i++)
       {
           video_memory[i] = blank;
       }
       // The cursor should now be on the last line.
       cursor_y = 24;
   }
}

// Write a single character out to the screen.
void monitor_put(char c)
{
   // The attribute byte is made up of two nibbles - the lower being the
   // foreground colour, and the upper the background colour.
   uint8  attributeByte = (curBackColor << 4) | (curForeColor & 0x0F);
   
      // The attribute byte is the top 8 bits of the word we have to send to the
   // VGA board.
   uint16 attribute = attributeByte << 8;
   uint16 *location;

   // Handle a backspace, by moving the cursor back one space
   if (c == 0x08 && cursor_x)
   {
       cursor_x--;
   }

   // Handle a tab by increasing the cursor's X, but only to a point
   // where it is divisible by 8.
   else if (c == 0x09)
   {
       cursor_x = (cursor_x+8) & ~(8-1);
   }

   // Handle carriage return
   else if (c == '\r')
   {
       cursor_x = 0;
   }

   // Handle newline by moving cursor back to left and increasing the row
   else if (c == '\n')
   {
       cursor_x = 0;
       cursor_y++;
   }
   // Handle any other printable character.
   else if(c >= ' ')
   {
       location = video_memory + (cursor_y*80 + cursor_x);
       *location = c | attribute;
       cursor_x++;
   }

   // Check if we need to insert a new line because we have reached the end
   // of the screen.
   if (cursor_x >= 80)
   {
       cursor_x = 0;
       cursor_y ++;
   }

   // Scroll the screen if needed.
   scroll();
   // Move the hardware cursor.
   //move_cursor();
}

// Clears the screen, by copying lots of spaces to the framebuffer.
void monitor_clear()
{
   // Make an attribute byte for the default colours
   uint8 attributeByte = (0 /*black*/ << 4) | (15 /*white*/ & 0x0F);
   uint16 blank = 0x20 /* space */ | (attributeByte << 8);

   int i;
   for (i = 0; i < 80*25; i++)
   {
       video_memory[i] = blank;
   }

   // Move the hardware cursor back to the start.
   cursor_x = 0;
   cursor_y = 0;
   //move_cursor();
}

// Outputs a null-terminated ASCII string to the monitor.
void monitor_write(const char *c)
{
   int i = 0;
   while (c[i])
   {
       monitor_put(c[i++]);
   }
}
