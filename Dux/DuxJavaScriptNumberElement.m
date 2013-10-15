//
//  DuxJavaScriptNumberElement.m
//  Dux
//
//  Created by Abhi Beckert on 2011-11-25.
//  
//  This is free and unencumbered software released into the public domain.
//  For more information, please refer to <http://unlicense.org/>
//

#import "DuxJavaScriptNumberElement.h"
#import "DuxJavaScriptLanguage.h"
#import "DuxPreferences.h"

@implementation DuxJavaScriptNumberElement

static NSCharacterSet *nextElementCharacterSet;
static NSCharacterSet *nonHexCharacterSet;
static NSColor *color;

+ (void)initialize
{
  [super initialize];
  
  nextElementCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
  nonHexCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFabcdef"] invertedSet];
  
  color = [[DuxTheme currentTheme] colorForKey:@"constant.numeric.js"];
}

- (id)init
{
  return [self initWithLanguage:[DuxJavaScriptLanguage sharedInstance]];
}

- (NSUInteger)lengthInString:(NSAttributedString *)string startingAt:(NSUInteger)startingAt nextElement:(DuxLanguageElement *__strong*)nextElement
{
  NSUInteger stringLength = string.string.length;
  NSRange foundRange = NSMakeRange(NSNotFound, 0);
  
  if (startingAt + 2 < stringLength && [string.string characterAtIndex:startingAt + 1] == 'x') {
    foundRange = [string.string rangeOfCharacterFromSet:nonHexCharacterSet options:NSLiteralSearch range:NSMakeRange(startingAt + 2, stringLength - startingAt - 2)];
    
    if (foundRange.location == NSNotFound)
      return stringLength - startingAt;
    
    if (foundRange.location == startingAt + 2)
      foundRange = NSMakeRange(NSNotFound, 0);
  }
  
  if (foundRange.location == NSNotFound) {
    foundRange = [string.string rangeOfCharacterFromSet:nextElementCharacterSet options:NSLiteralSearch range:NSMakeRange(startingAt, stringLength - startingAt)];
  }
  
  if (foundRange.location == NSNotFound) {
    return stringLength - startingAt;
  }
  
  return foundRange.location - startingAt;
}

- (NSColor *)color
{
  return color;
}

@end
