//
//  MyAppDelegate.h
//  Dux
//
//  Created by Abhi Beckert on 2011-08-25.
//  
//  This is free and unencumbered software released into the public domain.
//  For more information, please refer to <http://unlicense.org/>
//

#import <Foundation/Foundation.h>

#import "MyOpenQuicklyController.h"

@class DuxRunBundleQuicklyWindowController;

@interface MyAppDelegate : NSObject

@property (weak) IBOutlet NSMenu *bundlesMenu;
@property (strong) IBOutlet NSWindow *aboutWindow;
@property (weak) IBOutlet NSTextField *aboutWindowVersionField;
@property (unsafe_unretained) IBOutlet NSTextView *aboutWindowCreditsTextView;

@property DuxRunBundleQuicklyWindowController *runBundleQuicklyController;

- (IBAction)showPreferences:(id)sender;
- (IBAction)newWindow:(id)sender;
- (IBAction)openBundlesFolder:(id)sender;
- (IBAction)runBundleQuickly:(id)sender;
- (IBAction)showAcknowledgements:(id)sender;

- (IBAction)orderFrontStandardAboutPanel:(id)sender;
- (IBAction)showDuxWebsite:(id)sender;

@end
