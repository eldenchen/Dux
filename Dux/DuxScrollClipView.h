//
//  DuxScrollView.h
//  Dux
//
//  Created by Philippe de Reynal on 12/10/13.
//
//  This is free and unencumbered software released into the public domain.
//  For more information, please refer to <http://unlicense.org/>
//

#import <Cocoa/Cocoa.h>

@interface DuxScrollClipView : NSClipView

@property BOOL showLineNumbers;
@property BOOL showPageGuide;
@property NSUInteger pageGuidePosition;
@property CGFloat spaceWidth;

@property (nonatomic, strong) NSColor *guideFillColor;
@property (nonatomic, strong) NSColor *guideLineColor;

@end
