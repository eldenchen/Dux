//
//  DuxOpenQuicklyPanelController.h
//  Dux
//
//  Created by Abhi Beckert on 8/09/2013.
//
//

#import <Foundation/Foundation.h>
#import "DuxQuickFindPanel.h"

@interface DuxQuickFindPanelController : NSObject <NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate>

// title of the panel
@property (strong,nonatomic) NSString *title;

// array of dictionary objects, which must contain at least a "name" value
@property (strong, nonatomic) NSArray *contents;

// target/action when a find result is chosen by the user
@property (assign) id target;
@property SEL action;

// the user's currently selected seacrh result
@property (readonly) id selectedResult;

// show the panel aligned towards the top of the window
- (void)orderFrontForProjectWindow:(NSWindow *)window;

@end
