//
//  DuxSyntaxHighlighterTests.m
//  DuxSyntaxHighlighterTests
//
//  Created by Abhi Beckert on 2013-4-26.
//
//

#import "DuxSyntaxHighlighterTests.h"
#import "DuxPHPLanguage.h"

@interface DuxSyntaxHighlighterTests ()

@property DuxLanguage *phpLanguage;
@property DuxPHPDoubleQuoteStringElement *phpDoubleQuotedStringElement;

@end

@implementation DuxSyntaxHighlighterTests

- (void)setUp
{
  [super setUp];
  
  self.phpLanguage = self.phpLanguage;
  self.phpDoubleQuotedStringElement = [[DuxPHPDoubleQuoteStringElement alloc] initWithLanguage:self.phpLanguage];
}

- (void)tearDown
{
  self.phpLanguage = nil;
  self.phpDoubleQuotedStringElement = nil;
  
  [super tearDown];
}

- (void)testPHP
{
  id nextElement = nil;
  NSUInteger length = [self.phpDoubleQuotedStringElement lengthInString:[[NSAttributedString alloc] initWithString:@"foo \"string\" bar"] startingAt:4 nextElement:&nextElement];
  STAssertNil(nextElement, @"nextElement should be nil");
  STAssertEquals(length, (NSUInteger)8, @"php string should be 8 characters long");
  
  
  nextElement = nil;
  length = [self.phpDoubleQuotedStringElement lengthInString:[[NSAttributedString alloc] initWithString:@"foo \"string$\" bar"] startingAt:4 nextElement:&nextElement];
  STAssertNil(nextElement, @"should be nil but is %@", nextElement);
  STAssertEquals(length, (NSUInteger)9, @"should be 9 but is %i", (int)length);
}

@end
