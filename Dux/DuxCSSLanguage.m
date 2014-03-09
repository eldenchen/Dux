//
//  DuxCSSLanguage.m
//  Dux
//
//  Created by Abhi Beckert on 2011-11-20.
//  
//  This is free and unencumbered software released into the public domain.
//  For more information, please refer to <http://unlicense.org/>
//

#import "DuxCSSLanguage.h"

@implementation DuxCSSLanguage

+ (void)load
{
  [DuxLanguage registerLanguage:[self class]];
}

- (DuxLanguageElement *)baseElement
{
  return [DuxCSSBaseElement sharedInstance];
}

+ (BOOL)isDefaultLanguageForURL:(NSURL *)URL textContents:(NSString *)textContents
{
  static NSArray *extensions = nil;
  if (!extensions) {
    extensions = @[@"css", @"less", @"sass", @"scss"];
  }
  
  if (URL && [extensions containsObject:[URL pathExtension]])
    return YES;
  
  return NO;
}

- (void)findSymbolsInDocumentContents:(NSString *)string foundSymbolHandler:(BOOL(^) (NSDictionary *symbol))foundSymbolHandler finishedSearchHandler:(void(^)())finishedHandler
{
  NSRegularExpression *keywordRegex = [[NSRegularExpression alloc] initWithPattern:@"(.+?)\\s*\n*\\s*\\{" options:NSRegularExpressionCaseInsensitive error:NULL];
  
  [keywordRegex enumerateMatchesInString:string options:0 range:NSMakeRange(0, string.length) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
    NSRange range = [match rangeAtIndex:1];
  
    NSString *name = [string substringWithRange:range];
    
    BOOL continueSearching = foundSymbolHandler(@{@"range": [NSValue valueWithRange:range], @"name": name});
    if (!continueSearching)
      *stop = YES;
  }];
  
  finishedHandler();
}

@end
