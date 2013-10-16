//
//  DuxProjectWindow.m
//  Dux
//
//  Created by Abhi Beckert on 2012-12-28.
//
//  This is free and unencumbered software released into the public domain.
//  For more information, please refer to <http://unlicense.org/>
//

#import "DuxProjectWindow.h"
#import "MyTextDocument.h"
#import "DuxProjectWindowController.h"
#import "DuxPreferences.h"
#import "DuxTheme.h"

#import <objc/runtime.h>

@interface DuxProjectWindow()
// disable some method implementation warnings
- (void)drawRectOriginal:(NSRect)rect;
- (float)roundedCornerRadius;
- (NSWindow*)window;
- (NSRect)_titlebarTitleRect;
@end

@implementation DuxProjectWindow

// disable some compile time warnings for methods that will never exist (part of themeFrameDrawRect:)
- (void)drawRectOriginal:(NSRect)rect { }
- (float)roundedCornerRadius { return 0; }
- (NSWindow*)window { return nil; }
- (NSRect)_titlebarTitleRect { return NSMakeRect(0, 0, 0, 0); }

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
  if (self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag]) {
    // modify NSThemeFrame to do our custom drawing
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      // get the class definition responsible for drawing window frames (NSThemeFrame)
      id themeFrameClass = [[[self contentView] superview] class];
      
      // add the themeFrameDrawRect: method on self as a method on the themeFrame class, but name it "drawRectOriginal:"
      Method duxProjectWindowDrawRect = class_getInstanceMethod([self class], @selector(themeFrameDrawRect:));
      class_addMethod(themeFrameClass, @selector(drawRectOriginal:), method_getImplementation(duxProjectWindowDrawRect), method_getTypeEncoding(duxProjectWindowDrawRect));
      
      // swap the drawRect: and drawRectOriginal: methods on NSThemeFrame
      Method themeFrameDrawRect = class_getInstanceMethod(themeFrameClass, @selector(drawRect:));
      Method themeFrameDrawRectOriginal = class_getInstanceMethod(themeFrameClass, @selector(drawRectOriginal:));
      method_exchangeImplementations(themeFrameDrawRect, themeFrameDrawRectOriginal);
    });
  }
  
  return self;
}

- (void)awakeFromNib
{
  [super awakeFromNib];
  
//  if ([DuxPreferences editorDarkMode]) {
//    [self.toolbar setShowsBaselineSeparator:NO];
//  }
}


/**
 * this method will be copied over the top of [NSThemeFrame drawRect:]. It calls the
 * original theme frame implementation, then checks if the window is a DuxProjectWindow,
 * then draws our own custom stuff.
 */
- (void)themeFrameDrawRect:(NSRect)rect
{
	// Call original drawing method
	[(id)self drawRectOriginal:rect];
  
  // check if this is a DuxProjectWindow. if it's not, bail out now
  if (![[self window] isKindOfClass:[DuxProjectWindow class]])
    return;
  DuxProjectWindow *window = (DuxProjectWindow *)[(id)self window];
  
  
  // are we in dark mode?
//  if (![DuxPreferences editorDarkMode])
//    return;
  
  // grab gfx context
//  CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
  
  
	// Build clipping path : intersection of frame clip (bezier path with rounded corners) and rect argument
	NSRect windowRect = [window frame];
	windowRect.origin = NSMakePoint(0, 0);
  
  NSRect clipRect = NSMakeRect(1, 0, windowRect.size.width - 2, windowRect.size.height - 1);
  
	float cornerRadius = [(id)self roundedCornerRadius];
	[[NSBezierPath bezierPathWithRoundedRect:clipRect xRadius:cornerRadius yRadius:cornerRadius] addClip];
	[[NSBezierPath bezierPathWithRect:rect] addClip];
  

  
  
//  // define gradient
//  CGFloat darkColors [] = {
//    0.65, 0.65, 0.65, 0.000,
//    0.65, 0.65, 0.65, 0.400
//  };
//  CGFloat lightColors [] = {
//    0.92, 0.92, 0.92, 0.0,
//    0.92, 0.92, 0.92, 1.0
//  };
//  
//  CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
//  CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, [DuxPreferences editorDarkMode] ? darkColors : lightColors, NULL, 2);
//  CGColorSpaceRelease(baseSpace), baseSpace = NULL;
//  
//  
//  
//  // white-out the window title
//  CGContextMoveToPoint(context, 1, windowRect.size.height - 3);
//  CGContextAddLineToPoint(context, windowRect.size.width - 1, windowRect.size.height - 3);
//  CGContextAddLineToPoint(context, windowRect.size.width - 1, windowRect.size.height - 20);
//  CGContextAddLineToPoint(context, 1, windowRect.size.height - 20);
//  CGContextSetFillColorWithColor(context, self.window.backgroundColor.CGColor);
//  CGContextFillPath(context);
//  
//  
//  // draw gradient
//  CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), self.frame.size.height - 40);
//  CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), self.frame.size.height);
//  
//if ([DuxPreferences editorDarkMode]) {
//  CGContextSetBlendMode(context, kCGBlendModeScreen);
//} else {
//  CGContextSetBlendMode(context, kCGBlendModeMultiply);
//}
//  CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
//  
//  // release gradient
//  CGGradientRelease(gradient), gradient = NULL;
//  
//  
//  
//  
//  // draw a light horizontal line near the top of the window (3D bevel)
//  CGContextSetBlendMode(context, kCGBlendModeNormal);
//if ([DuxPreferences editorDarkMode]) {
//  CGContextSetStrokeColorWithColor(context, [NSColor colorWithCalibratedWhite:1 alpha:0.24].CGColor);
//} else {
//  CGContextSetStrokeColorWithColor(context, [NSColor colorWithCalibratedWhite:1 alpha:0.34].CGColor);
//}
//  CGContextSetLineWidth(context, 1.0);
//  
//  CGContextMoveToPoint(context, 0, windowRect.size.height - 1.5);
//  CGContextAddLineToPoint(context, windowRect.size.width, windowRect.size.height - 1.5);
//  
//  CGContextStrokePath(context);
//  
//  
//  
//  // draw title (we wiped it out earlier)
//  NSRect titleRect = [self _titlebarTitleRect];
//  
//  NSDictionary *attrs = @{NSFontAttributeName: [NSFont titleBarFontOfSize:0], NSForegroundColorAttributeName: [DuxPreferences editorDarkMode] ? [NSColor lightGrayColor] : [NSColor blackColor]};
//  [self.title drawInRect:titleRect withAttributes:attrs];
//  
//  
//  
  // draw pageguide
  if (window.duxProjectWindowShowPageGuide) {
    NSColor *guideFillColor = [[DuxTheme currentTheme].foreground colorWithAlphaComponent:0.015];
    NSColor *guideLineColor = [[DuxTheme currentTheme].foreground colorWithAlphaComponent:0.1];
    
    float position = window.duxProjectWindowPageGuideX;
    
    if (window.frame.size.width > position) {
      [guideFillColor set];
      [NSBezierPath fillRect:NSMakeRect(position, 0, window.frame.size.width - position, window.frame.size.height)];
      [guideLineColor set];
      [NSBezierPath strokeLineFromPoint:NSMakePoint(position - 0.25, 0) toPoint:NSMakePoint(position - 0.25, window.frame.size.height)];
    }
  }
}

- (void)setDuxProjectWindowShowPageGuide:(BOOL)duxProjectWindowShowPageGuide
{
  if (_duxProjectWindowShowPageGuide == duxProjectWindowShowPageGuide)
    return;
  
  _duxProjectWindowShowPageGuide = duxProjectWindowShowPageGuide;
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^(void){
    [self display];
  });
}

- (void)setDuxProjectWindowPageGuideX:(CGFloat)duxProjectWindowPageGuideX
{
  if (fabs(_duxProjectWindowPageGuideX - duxProjectWindowPageGuideX) < 0.1)
    return;
  
  
  _duxProjectWindowPageGuideX = duxProjectWindowPageGuideX;
  
  static BOOL didDraw;
  didDraw = NO;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^(void){
    if (didDraw)
      return;
    
    [self display];
    didDraw = YES;
  });
}

@end
