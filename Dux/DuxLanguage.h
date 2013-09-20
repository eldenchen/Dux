//
//  DuxLanguage.h
//  Dux
//
//  Created by Abhi Beckert on 2011-10-22.
//  
//  This is free and unencumbered software released into the public domain.
//  For more information, please refer to <http://unlicense.org/>
//

#import <Foundation/Foundation.h>
#import "DuxLanguageElement.h"

@interface DuxLanguage : NSObject

+ (id)sharedInstance;

+ (NSArray *)registeredLanguages; // array of all language subclasses that have registered themselves
+ (void)registerLanguage:(Class)language; // every DuxLanguage subclass is expected to call this from it's +load method

- (DuxLanguageElement *)baseElement;

- (void)wrapCommentsAroundRange:(NSRange)commentRange ofTextView:(NSTextView *)textView;
- (void)removeCommentsAroundRange:(NSRange)commentRange ofTextView:(NSTextView *)textView;

- (void)prepareToParseTextStorage:(NSTextStorage *)textStorage inRange:(NSRange)range;

// subclasses must override this to check if they are the correct editor. URL will be nil for unsaved documents, but textContents will always be set
+ (BOOL)isDefaultLanguageForURL:(NSURL *)URL textContents:(NSString *)textContents;

/**
 * Searches for an array of "symbols", possibly on a background thread, and calls the handler (on the main thread) for
 * each result. If the handler returns NO, then the search is aborted.
 * 
 * Calls finishedHandler once seraching has stopped.
 *
 * Symbol format: @{@"name": @"helloWorld", @"range": [NSValue valueWithRange:{42, 12}}}
 * 
 * Default implementation just calls the finishedHandler immediately.
 */
- (void)findSymbolsInDocumentContents:(NSString *)string foundSymbolHandler:(BOOL(^) (NSDictionary *symbol))foundSymbolHandler finishedSearchHandler:(void(^)())finishedHandler;

@end
