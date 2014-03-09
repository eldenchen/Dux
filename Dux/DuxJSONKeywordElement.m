//  DuxJavaScriptLanguage.h
//  Dux
//
//  Created by Chen Hongzhi on 6/22/12.
//
//  This is free and unencumbered software released into the public domain.
//  For more information, please refer to <http://unlicense.org/>
//

#import "DuxJSONKeywordElement.h"
#import "DuxJSONLanguage.h"

@implementation DuxJSONKeywordElement

static NSCharacterSet *nextElementCharacterSet;
static NSColor *color;

+ (void)initialize
{
  if (self == [DuxJSONKeywordElement class]) {
    nextElementCharacterSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];

    color = [[DuxTheme currentTheme] colorForKey:@"constant.language.json"];
  }
}

- (id)init
{
  return [self initWithLanguage:[DuxJSONLanguage sharedInstance]];
}

- (NSUInteger)lengthInString:(NSAttributedString *)string startingAt:(NSUInteger)startingAt nextElement:(DuxLanguageElement *__strong*)nextElement
{
  NSRange foundRange = [string.string rangeOfCharacterFromSet:nextElementCharacterSet options:NSLiteralSearch range:NSMakeRange(startingAt, string.length - startingAt)];
  
  if (foundRange.location == NSNotFound)
    return string.length - startingAt;
  
  return foundRange.location - startingAt;
}

- (NSColor *)color
{
  return color;
}

@end
