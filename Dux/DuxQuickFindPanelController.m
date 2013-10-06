//
//  DuxOpenQuicklyPanelController.m
//  Dux
//
//  Created by Abhi Beckert on 8/09/2013.
//
//

#import "DuxQuickFindPanelController.h"
#import <objc/message.h>


@interface DuxQuickFindPanelController()

@property DuxQuickFindPanel *panel;
@property NSSearchField *searchField;
@property NSTableView *resultsView;
@property (nonatomic) NSArray *contents;
@property (nonatomic) NSArray *oldContents;

@property NSMutableArray *matchingResultIndexes;

@end

@implementation DuxQuickFindPanelController

- (instancetype)init
{
  if (!(self = [super init]))
    return nil;
  
  self.panel = [[DuxQuickFindPanel alloc] initWithContentRect:NSMakeRect(0, 0, 450, 550)];
  
  self.searchField = [[NSSearchField alloc] initWithFrame:NSMakeRect(4, self.panel.frame.size.height - 32, self.panel.frame.size.width - 8, 28)];
  [self.searchField.cell setPlaceholderString:@"Find"];
  self.searchField.bezelStyle = NSTextFieldSquareBezel;
  self.searchField.font = [NSFont systemFontOfSize:17];
  self.searchField.delegate = self;
  [self.panel.contentView addSubview:self.searchField];
  
  self.resultsView = [[NSTableView alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)];
  self.resultsView.headerView = nil;
  self.resultsView.backgroundColor = [NSColor clearColor];
  self.resultsView.usesAlternatingRowBackgroundColors = YES;
  self.resultsView.rowHeight = 20;
  self.resultsView.dataSource = self;
  self.resultsView.delegate = self;
  self.resultsView.target = self;
  self.resultsView.action = @selector(tableViewRowClicked:);
  
  NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@"column"];
  column.width = self.panel.frame.size.width;
  [column.dataCell setFont:[NSFont systemFontOfSize:14]];
  [self.resultsView addTableColumn:column];
  
  NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(0, 0, self.panel.frame.size.width, self.panel.frame.size.height - 36)];
  scrollView.backgroundColor = self.panel.backgroundColor;
  scrollView.hasVerticalScroller = YES;
  scrollView.documentView = self.resultsView;
  [self.panel.contentView addSubview:scrollView];
  
  self.matchingResultIndexes = nil;
  
  return self;
}

- (NSString *)title
{
  return [self.searchField.cell placeholderString];
}

- (void)setTitle:(NSString *)title
{
  return [self.searchField.cell setPlaceholderString:title];
}

- (void)setContents:(NSArray *)contents
{
  _contents = contents;
  [self reload];
}

- (void)orderFrontForProjectWindow:(NSWindow *)window
{
  CGFloat x = floor(window.frame.origin.x + ((window.frame.size.width - self.panel.frame.size.width) / 2));
  CGFloat y = floor(window.frame.origin.y + ((window.frame.size.height - self.panel.frame.size.height) / 1.25));
  
  [self.panel setFrame:NSMakeRect(x, y, self.panel.frame.size.width, self.panel.frame.size.height) display:NO];
  
  [self.panel makeKeyAndOrderFront:self];
  [self.panel makeFirstResponder:self.searchField];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
  if (!self.matchingResultIndexes)
    return self.contents.count + self.oldContents.count;
  
  return self.matchingResultIndexes.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
  if (!self.matchingResultIndexes)
    return self.contents[row][@"name"];
  
  row = [self.matchingResultIndexes[row] integerValue];
  return self.contents[row][@"name"];
}

- (void)controlTextDidChange:(NSNotification *)obj
{
  [self reload];
}

- (void)reload
{
  // no search string? show all possible items
  if (self.searchField.stringValue.length == 0) {
    self.matchingResultIndexes = nil;
    [self.resultsView reloadData];
    if ((self.contents.count + self.oldContents.count) > 0)
      [self.resultsView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    
    return;
  }
  
  // build a regex pattern from the search string
  NSString *searchString = self.searchField.stringValue;
  NSMutableString *searchPattern = [NSMutableString stringWithString:@""];
  NSString *operatorChars = @"*?+[(){}^$|\\./";
  for (int charPos = 0; charPos < searchString.length; charPos++) {
    NSString *character = [searchString substringWithRange:NSMakeRange(charPos, 1)];
    
    if ([operatorChars rangeOfString:character].location != NSNotFound)
      character = [NSString stringWithFormat:@"\\%@", character];
    
    [searchPattern appendFormat:@"%@.*", character];
  }
  NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:searchPattern options:NSRegularExpressionCaseInsensitive error:NULL];
  
  // perform the search
  self.matchingResultIndexes = @[].mutableCopy;
  NSInteger contentsCount = self.contents.count + self.oldContents.count;
  for (NSUInteger index = 0; index < contentsCount; index++) {
    NSString *name = index < self.contents.count ? self.contents[index][@"name"] : self.oldContents[index - self.contents.count][@"name"];
    
    if ([expression rangeOfFirstMatchInString:name options:0 range:NSMakeRange(0, name.length)].location == NSNotFound)
      continue;
    
    [self.matchingResultIndexes addObject:[NSNumber numberWithInteger:index]];
  }
  
  // update table view
  [self.resultsView reloadData];
  if (self.matchingResultIndexes.count > 0)
    [self.resultsView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
}

- (void)tableViewRowClicked:(id)sender
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
  [self.target performSelector:self.action withObject:self];
#pragma clang diagnostic pop
  
  [self.panel orderOut:self];
}

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector
{
  if (control == self.searchField) {
    if (commandSelector == @selector(insertNewline:)) {
      if ([self numberOfRowsInTableView:self.resultsView] > 0) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.action withObject:self];
#pragma clang diagnostic pop
      }
      
      [self.panel orderOut:self];
      return YES;
    }
    
    if (commandSelector == @selector(cancelOperation:)) {
      [self.panel orderOut:self];
      return YES;
    }
    
    if (commandSelector == @selector(moveDown:)) {
      NSInteger nextIndex = self.resultsView.selectedRow + 1;
      
      if (nextIndex >= [self numberOfRowsInTableView:self.resultsView])
        nextIndex = 0;
      
      [self.resultsView selectRowIndexes:[NSIndexSet indexSetWithIndex:nextIndex] byExtendingSelection:NO];
      [self.resultsView scrollRowToVisible:nextIndex];
      
      return YES;
    }
    
    if (commandSelector == @selector(moveUp:)) {
      NSInteger nextIndex = self.resultsView.selectedRow - 1;
      
      if (nextIndex < 0)
        nextIndex = [self numberOfRowsInTableView:self.resultsView] - 1;
      
      [self.resultsView selectRowIndexes:[NSIndexSet indexSetWithIndex:nextIndex] byExtendingSelection:NO];
      [self.resultsView scrollRowToVisible:nextIndex];
      
      return YES;
    }
  }
  
  return NO;
}

- (id)selectedResult
{
  if ([self numberOfRowsInTableView:self.resultsView] == 0)
    return nil;
  
  NSInteger row = [self.resultsView selectedRow];
  if (row < 0)
    row = 0;
  
  if (!self.matchingResultIndexes)
    return row < self.contents.count ? self.contents[row] : self.oldContents[row - self.contents.count];
  
  row = [self.matchingResultIndexes[row] integerValue];
  return row < self.contents.count ? self.contents[row] : self.oldContents[row - self.contents.count];
}

- (void)beginAddingFindResults
{
  self.oldContents = self.contents;
  self.contents = @[];
}

- (void)addFindResult:(NSDictionary *)resultRecord
{
  if ([self.oldContents containsObject:resultRecord]) {
    NSMutableArray *oldContentsMutable = self.oldContents.mutableCopy;
    [oldContentsMutable removeObject:resultRecord];
    self.oldContents = oldContentsMutable.copy;
  }
  self.contents = [self.contents arrayByAddingObject:resultRecord];
}

- (void)endAddingFindResults
{
  self.oldContents = nil;
  [self reload];
  NSLog(@"end");
}

@end
