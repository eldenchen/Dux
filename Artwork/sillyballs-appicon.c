/*
** Make a random new color for the ball.
*/
ballColor.red = Random();
ballColor.green = Random();
ballColor.blue = Random();

/*
** Set that color as the new color to use in drawing.
*/
RGBForeColor (&ballColor);

/*
** Make a Random new location for the ball, that is normalized to the window size.  
** This makes the Integer from Random into a number that is 0..windRect.bottom
** and 0..windRect.right.  They are normalized so that we don't spend most of our
** time drawing in places outside of the window.
*/
newTop = Random();
newLeft = Random();
newTop = ((newTop + 32767) * windRect.bottom) / 65536;
newLeft = ((newLeft + 32767) * windRect.right) / 65536;
SetRect(&ballRect, newLeft, newTop, newLeft + BallWidth, newTop + BallHeight);

/*
** Move pen to the new location, and paint the colored ball.
*/
MoveTo(newLeft, newTop);
PaintOval(&ballRect);

/*
** Move the pen to the middle of the new ball position, for the text
*/
MoveTo(ballRect.left + BallWidth / 2 - BobSize,
       ballRect.top + BallHeight / 2 + BobSize / 2 - 1);

/*
** Invert the color and draw the text there.  This won't look quite right in 1 bit
** mode, since the foreground and background colors will be the same.
** Color QuickDraw special cases this to not invert the color, to avoid
** invisible drawing.
*/
InvertColor(&ballColor); 
RGBForeColor(&ballColor);
DrawString("\pBob");
