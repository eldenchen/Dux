//
//  DuxScrollView.h
//  Dux
//
//  Created by Philippe de Reynal on 12/10/13.
//
//  This is free and unencumbered software released into the public domain.
//  For more information, please refer to <http://unlicense.org/>
//

#import "DuxScrollView.h"
#import "DuxPreferences.h"
#import "DuxScrollClipView.h"

@implementation DuxScrollView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      self.contentView = [[DuxScrollClipView alloc] initWithFrame:frame];
      [self initScrollView];
    }
    return self;
}

- (void)initScrollView
{
  self.borderType = NSNoBorder;
  self.hasVerticalScroller = YES;
  self.hasHorizontalScroller = NO;
  self.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
}

@end
