// filename: tutorials/gyro.toit
/// Under MIT licence
import device
import peripherals show *
import math
import font show *
import texture show *
import two_color show *
import pixel_display show *

main:
  led_names := ["TOP LEFT", "TOP RIGHT", "BOTTOM RIGHT", "BOTTOM LEFT"]
  connection ::= device.ConsoleConnection.open
  try:
    accelerometer := Accelerometer.start
    try:
      log "started"
      while true:
        force := movement accelerometer
        log "got movement: $(%.2f force) Gs"
        sleep --ms=1000

        sans ::= font_get "sans10"
        display ::= TwoColorPixelDisplay "eink"
        display.background = WHITE
        // Draw text on the display.
        context := display.context --landscape --alignment=TEXT_TEXTURE_ALIGN_CENTER --color=BLACK --font=sans
        display.add
          display.text context 102 30 "$(%.2f force)"
        display.add
          display.text context 102 60 "shake-a-thon-units"
        display.draw
        
        l1 := Led led_names[0]
        l2 := Led led_names[1]
        l3 := Led led_names[2]
        l4 := Led led_names[3]

        if force < 1.2:
          l1.off
          l2.off
          l3.off
          l4.off
        else if force >= 1.2 and force < 2.0:
          l1.on
          l2.off
          l3.off
          l4.off
        else if force >= 2.0 and force < 3.0:
          l1.on
          l2.on
          l3.off
          l4.off
        else if force >= 3.0 and force < 4.0:
          l1.on
          l2.on
          l3.on
          l4.off
        else:
          l1.on
          l2.on
          l3.on
          l4.on
        
    finally:
      accelerometer.close
  finally:
    connection.close

/**
MOVEMENT_BOUND ::= 0.04
is_moving f/float -> bool:
  return (1 - f).abs > MOVEMENT_BOUND
*/

// Uses limit*10ms to find the mean g-force the device has been affected with.
movement acc/Accelerometer -> float:
  limit := 20
  points := []
  limit.repeat:
    points.add
      acc.read.length
    sleep --ms=10

  points.sort --in_place
  return points[limit - 1]

/**
mean points/List/*<float>*/ -> float:
  sum := points.reduce --initial=0.0: | acc/float p/float |
    acc + p
  return sum / points.size
  */