//
//  DuxScrollView.h
//  Dux
//
//  Created by Philippe de Reynal on 12/10/13.
//
//  This is free and unencumbered software released into the public domain.
//  For more information, please refer to <http://unlicense.org/>
//

#import "DuxScrollClipView.h"
#import "DuxPreferences.h"
#import "DuxProjectWindow.h"
#import "DuxTheme.h"

@implementation DuxScrollClipView

@synthesize showLineNumbers;
@synthesize showPageGuide;
@synthesize pageGuidePosition;
@synthesize spaceWidth;
@synthesize guideFillColor;
@synthesize guideLineColor;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      [self initClipView];
    }
    return self;
}

- (void) initClipView
{
  self.showLineNumbers = [DuxPreferences showLineNumbers];
  self.showPageGuide = [DuxPreferences showPageGuide];
  self.pageGuidePosition = [DuxPreferences pageGuidePosition];
  self.spaceWidth = [@" " sizeWithAttributes:@{NSFontAttributeName: [DuxPreferences editorFont]}].width;
  
  BOOL isDark = [DuxTheme currentTheme].hasDarkBackground;
  self.guideFillColor = [[DuxTheme currentTheme].foreground colorWithAlphaComponent:isDark ? 0.05 : 0.02];
  self.guideLineColor = [[DuxTheme currentTheme].foreground colorWithAlphaComponent:isDark ? 0.3 : 0.17];
  
  
  NSNotificationCenter *notifCenter = [NSNotificationCenter defaultCenter];
  [notifCenter addObserver:self selector:@selector(showPageGuideDidChange:) name:DuxPreferencesShowPageGuideDidChangeNotification object:nil];
  [notifCenter addObserver:self selector:@selector(pageGuidePositionDidChange:) name:DuxPreferencesPageGuidePositionDidChangeNotification object:nil];
}

- (void)drawRect:(NSRect)dirtyRect
{
  [super drawRect:dirtyRect];

  //draw background
  static NSColor *backgroundColor;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    backgroundColor = [[DuxTheme currentTheme] background];
  });
  [backgroundColor set];
  NSRectFill(dirtyRect);

  // page guide
  if (self.showPageGuide) {

    float position = floorf(self.pageGuidePosition * self.spaceWidth);
    if (self.showLineNumbers) position += 34;

    if (NSMaxX(dirtyRect) > position) {
      [guideFillColor set];
      [NSBezierPath fillRect:NSMakeRect(position, NSMinY(dirtyRect), NSMaxX(dirtyRect) - position, NSMaxY(dirtyRect))];

      [guideLineColor set];
      [NSBezierPath setDefaultLineWidth:0.5];
      [NSBezierPath strokeLineFromPoint:NSMakePoint(position - 0.25, NSMinY(dirtyRect)) toPoint:NSMakePoint(position - 0.25, NSMaxY(dirtyRect))];
    }
    if ([self.window isKindOfClass:[DuxProjectWindow class]]) {
      ((DuxProjectWindow *)self.window).duxProjectWindowShowPageGuide = YES;
      ((DuxProjectWindow *)self.window).duxProjectWindowPageGuideX = [self.window.contentView convertPoint:NSMakePoint(position, 0) fromView:self].x;
    }
  } else {
    if ([self.window isKindOfClass:[DuxProjectWindow class]]) {
      ((DuxProjectWindow *)self.window).duxProjectWindowShowPageGuide = NO;
    }
  }
}

- (void)showPageGuideDidChange:(NSNotification *)notif
{
  self.showPageGuide = [DuxPreferences showPageGuide];
  [self setNeedsDisplay:YES];
}

- (void)pageGuidePositionDidChange:(NSNotification *)notif
{
  self.pageGuidePosition = [DuxPreferences pageGuidePosition];
  [self setNeedsDisplay:YES];
}

- (void)showLineNumbersDidChange:(NSNotification *)notif
{
  self.showLineNumbers = [DuxPreferences showLineNumbers];
  [self setNeedsDisplay:YES];
}

@end
