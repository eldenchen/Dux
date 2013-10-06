//
//  DuxPHPLanguage.m
//  Dux
//
//  Created by Abhi Beckert on 2011-11-16.
//  
//  This is free and unencumbered software released into the public domain.
//  For more information, please refer to <http://unlicense.org/>
//

#import "DuxPHPLanguage.h"

static NSRegularExpression *keywordsExpression;
static NSIndexSet *keywordIndexSet = nil;
static NSRange keywordIndexRange = {NSNotFound, 0};
static __weak id keywordIndexString = nil;

@implementation DuxPHPLanguage

+ (void)load
{
  [DuxLanguage registerLanguage:[self class]];
}

- (DuxLanguageElement *)baseElement
{
  return [DuxPHPBaseElement sharedInstance];
}

- (void)wrapCommentsAroundRange:(NSRange)commentRange ofTextView:(NSTextView *)textView
{
  NSString *existingString = [textView.textStorage.string substringWithRange:commentRange];
  
  NSString *commentedString= [NSString stringWithFormat:@"// %@", existingString];
  commentedString = [commentedString stringByReplacingOccurrencesOfString:@"(\n)" withString:@"$1// " options:NSRegularExpressionSearch range:NSMakeRange(0, commentedString.length)];
  
  [textView insertText:commentedString replacementRange:commentRange];
  [textView setSelectedRange:NSMakeRange(commentRange.location, commentedString.length)];
}

- (void)removeCommentsAroundRange:(NSRange)commentRange ofTextView:(NSTextView *)textView
{
  NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"^\\s*// ?" options:NSRegularExpressionAnchorsMatchLines error:NULL];
  
  NSMutableString *newString = [[textView.textStorage.string substringWithRange:commentRange] mutableCopy];
  [expression replaceMatchesInString:newString options:0 range:NSMakeRange(0, newString.length) withTemplate:@""];
  
  [textView insertText:[newString copy] replacementRange:commentRange];
  [textView setSelectedRange:NSMakeRange(commentRange.location, newString.length)];
}

+ (NSIndexSet *)keywordIndexSet
{
  return keywordIndexSet;
}

+ (NSRange)keywordIndexRange
{
  return keywordIndexRange;
}

+ (id)keywordIndexString
{
  return keywordIndexString;
}

- (void)prepareToParseTextStorage:(NSTextStorage *)textStorage inRange:(NSRange)range
{
  [super prepareToParseTextStorage:textStorage inRange:range];
  
  [self findKeywordsInString:textStorage.string inRange:range];
}

- (void)findKeywordsInString:(NSString *)string inRange:(NSRange)range
{
  if (!keywordsExpression) {
    NSArray *keywords = [[NSArray alloc] initWithObjects:@"abstract", @"and", @"array", @"as", @"break", @"case", @"catch", @"cfunction", @"class", @"clone", @"const", @"continue", @"declare", @"default", @"die", @"do", @"double", @"else", @"elseif", @"empty", @"enddeclare", @"endfor", @"endforeach", @"endif", @"endswitch", @"endwhile", @"eval", @"exit", @"extends", @"false", @"final", @"float", @"for", @"foreach", @"function", @"global", @"goto", @"if", @"implements", @"include", @"instanceof", @"int", @"integer", @"interface", @"isset", @"namespace", @"new", @"null", @"old_function", @"or", @"print"@"private", @"protected", @"public", @"return", @"require", @"require_once", @"string", @"static", @"switch", @"throw", @"true", @"try", @"use", @"var", @"while", @"xor", @"__CLASS__", @"__DIR__", @"__FILE__", @"__FUNCTION__", @"__LINE__", @"__METHOD__", @"__NAMESPACE__", nil];
    
    keywordsExpression = [[NSRegularExpression alloc] initWithPattern:[[NSString alloc] initWithFormat:@"\\b(%@)\\b", [keywords componentsJoinedByString:@"|"]] options:NSRegularExpressionCaseInsensitive error:NULL];
  }
  
  NSMutableIndexSet *keywordIndexesMutable = [[NSIndexSet indexSet] mutableCopy];
  [keywordsExpression enumerateMatchesInString:string options:0 range:range usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
    [keywordIndexesMutable addIndexesInRange:match.range];
  }];
  
  keywordIndexSet = [keywordIndexesMutable copy];
  keywordIndexRange = range;
  keywordIndexString = string;
}

+ (BOOL)isDefaultLanguageForURL:(NSURL *)URL textContents:(NSString *)textContents
{
  if (URL && [[URL pathExtension] isEqualToString:@"php"])
    return YES;
  
  if (textContents.length >= 5 && [[textContents substringToIndex:5] isEqualToString:@"<?php"])
    return YES;
  
  return NO;
}

- (void)findSymbolsInDocumentContents:(NSString *)string foundSymbolHandler:(BOOL(^) (NSDictionary *symbol))foundSymbolHandler finishedSearchHandler:(void(^)())finishedHandler
{
  NSArray *keywords = [[NSArray alloc] initWithObjects:@"class", @"function", @"interface", nil];
  NSRegularExpression *keywordRegex = [[NSRegularExpression alloc] initWithPattern:[[NSString alloc] initWithFormat:@"\\b((%@\\s+([a-z0-9_]+)))\\b", [keywords componentsJoinedByString:@"\\s+([a-z0-9_]+))|("]] options:NSRegularExpressionCaseInsensitive error:NULL];
  
  string = string.copy;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    __block BOOL finishedHandlerCalled = NO;
    
    [keywordRegex enumerateMatchesInString:string options:0 range:NSMakeRange(0, string.length) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
      NSUInteger m = match.numberOfRanges;
      for (NSUInteger i = 2; i < m; i++) {
        BOOL isNameMatch = ((i - 1) % 2) == 0;
        if (!isNameMatch)
          continue;
        
        NSRange range = [match rangeAtIndex:i];
        if (range.location == NSNotFound)
          continue;
        
        NSString *name = [string substringWithRange:range];
        
        __block BOOL continueSearching;
        dispatch_sync(dispatch_get_main_queue(), ^{
          continueSearching = foundSymbolHandler(@{@"range": [NSValue valueWithRange:range], @"name": name});
        });
        if (!continueSearching) {
          finishedHandler();
          finishedHandlerCalled = YES;
          *stop = YES;
        }
      }
    }];
    
    if (!finishedHandlerCalled)
      finishedHandler();
  });
}

@end
