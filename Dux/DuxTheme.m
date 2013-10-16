//
//  DuxTheme.m
//  Dux
//
//  Created by Philippe de Reynal on 14/10/13.
//
//  This is free and unencumbered software released into the public domain.
//  For more information, please refer to <http://unlicense.org/>
//

#import "DuxTheme.h"

// See http://manual.macromates.com/en/language_grammars.html for more informations about the file format.

#define kThemeExtension @"tmTheme"

static DuxTheme *currentTheme;

@implementation DuxTheme

@synthesize name;
@synthesize background;
@synthesize foreground;
@synthesize caret;
@synthesize selection;
@synthesize settings;
@synthesize colors;

- (id) initWithDictionary:(NSDictionary *)dic
{
  self = [super init];
  if (self) {
    NSArray *root = dic[@"settings"];
    self.background = [DuxTheme colorWithHexString:root[0][@"settings"][@"background"]];
    self.foreground = [DuxTheme colorWithHexString:root[0][@"settings"][@"foreground"]];
    self.caret = [DuxTheme colorWithHexString:root[0][@"settings"][@"caret"]];
    self.selection = [DuxTheme colorWithHexString:root[0][@"settings"][@"selection"]];

    [self buildColorsDictionary:root];
  }
  return self;
}

- (void)buildColorsDictionary:(NSArray *)root
{
  self.colors = [[NSMutableDictionary alloc] init];

  for (int i = 1 ; i < root.count ; i++) {
    NSDictionary *item = root[i];
    NSColor *foregroundColor = [DuxTheme colorWithHexString:item[@"settings"][@"foreground"]];
    if (!foregroundColor) {
      continue;
    }
    NSString *scope = item[@"scope"];
    scope = [scope stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSArray *keys = [scope componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    for (id key in keys) {
      [self.colors setObject:foregroundColor forKey:key];
    }
  }
}

+ (DuxTheme *)currentTheme
{
  return currentTheme;
}

+ (void)loadThemeNamed:(NSString *)name
{
  NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:kThemeExtension];
  NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
  currentTheme = [[DuxTheme alloc] initWithDictionary:dic];
}

- (NSColor *)colorForKey:(NSString *)key
{
  id col = [self.colors objectForKey:key];
  if (col) {
    return col;
  } else {
    NSMutableArray *keys = [[NSMutableArray alloc] initWithArray:[key componentsSeparatedByString:@"."] copyItems:NO];
    NSUInteger count = keys.count - 1;
    for (int i = 0 ; i < count ; i++) {
      [keys removeLastObject];
      NSString *newKey = [keys componentsJoinedByString:@"."];
      id color = [self.colors objectForKey:newKey];
      if (color) {
        return color;
      }
    }
  }
  // default text color if none was found
  return self.foreground;
}

- (NSInteger)scrollerKnobStyle
{
  static NSInteger style;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    // compute scrollbar style depending on theme background
    CGFloat comp[4];
    NSColor *backgroundColor = self.background;
    [backgroundColor getComponents:comp];
    CGFloat brightness = 255 * (comp[0] * 299 + comp[1] * 587 + comp[2] * 114) / 1000;
    style = brightness < 128 ? NSScrollerKnobStyleLight : NSScrollerKnobStyleDark;
  });
  return style;
}

+ (NSColor *)colorWithHexString:(NSString *)string
{
  if (!string) {
    return nil;
  }
  string = [string stringByReplacingOccurrencesOfString:@"#" withString:@""];
  uint32_t hex;
  [[NSScanner scannerWithString:string] scanHexInt:&hex];
  return [DuxTheme colorWithHexValue:hex];
}

+ (NSColor *)colorWithHexValue:(uint32_t)value
{
  return [NSColor colorWithCalibratedRed:((float)((value & 0xFF0000) >> 16))/255.0
                                   green:((float)((value & 0xFF00) >> 8))/255.0
                                    blue:((float)(value & 0xFF))/255.0 alpha:1.0];
}


@end
