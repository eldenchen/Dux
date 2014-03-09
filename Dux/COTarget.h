//
//  COTarget.h
//  Dux
//
//  Created by Abhi Beckert on 9/11/2013.
//
//

/* example usage in Cocoa Script:
 
 // create a window
 var window = [[NSWindow alloc] init]
 
 // create an OK button
 var okButton = [[NSButton alloc] initWithFrame:NSMakeRect(10, 10, 100, 100)]
 [okButton setTitle:"Continue"]
 [okButton sizeToFit]
 [okButton setKeyEquivalent:"\r"]
 [[window contentView] addSubview:okButton]
 
 //// put more stuff in the window here; text fields, etc ////
 
 // show window, and wait for the OK button to be pressed
 var okButtonTarget = [COTarget targetWithAction:function(sender) {
   [window orderOut:nil];
   [NSApp stopModal];
 }]
 [okButton setTarget:okButtonTarget]
 [okButton setAction:"callAction:"]
 
 // run modal
 [NSApp runModalForWindow:window];
*/

#import <Foundation/Foundation.h>
#import "MOJavaScriptObject.h"
#import <CocoaScript/COScript.h>

@interface COTarget : NSObject

@property MOJavaScriptObject *action;

+ (instancetype)targetWithAction:(MOJavaScriptObject *)action;

- (instancetype)initWithAction:(MOJavaScriptObject *)action;

- (void)callAction:(id)sender;

@end
