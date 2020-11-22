///Build from example code from the toiware team
///Under MIT licence

// filename: hello/hello.toit
/// Prints a message on the e-Ink display of the device.
import font show *
import texture show *
import two_color show *
import pixel_display show *
sans ::= font_get "sans10"
display ::= TwoColorPixelDisplay "eink"
main:
  display.background = WHITE
  // Draw text on the display.
  context := display.context --landscape --alignment=TEXT_TEXTURE_ALIGN_CENTER --color=BLACK --font=sans
  display.text context 102 50 "Hello from Toitbox!"
  display.draw
  