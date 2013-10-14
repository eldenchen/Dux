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

/*#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
 */

//see http://manual.macromates.com/en/language_grammars.html for more info on the file format.

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

+ (void)loadTheme
{
  NSString *path = [[NSBundle mainBundle] pathForResource:@"Tomorrow-Night" ofType:@"tmTheme"];
  NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];

  currentTheme = [[DuxTheme alloc] initWithDictionary:dic];

  NSLog(@"%@", [currentTheme colorForKey:@"comment.single"]);
}

- (NSColor *)colorForKey:(NSString *)key
{
  //"comment.singleline"
  id col = [self.colors objectForKey:key];
  if (!col) {
    NSArray *keys = [key componentsSeparatedByString:@"."];
    for (int i = 0 ; i < keys.count ; i++) {
      //
    }
  }
  return col;
}

+ (NSColor *)colorWithHexString:(NSString *)string
{
  string = [string stringByReplacingOccurrencesOfString:@"#" withString:@""];
  uint32_t hex;
  [[NSScanner scannerWithString:string] scanHexInt:&hex];
  return [DuxTheme colorWithHexValue:hex];
}

+ (NSColor *)colorWithHexValue:(uint32_t)value
{
  return [NSColor colorWithCalibratedRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:1.0];
}

@end
