//
//  COTarget.h
//  Dux
//
//  Created by Abhi Beckert on 9/11/2013.
//
//

/* example usage in Cocoa Script:
 
 // create window
 var window = [[NSWindow alloc] init]
 
 // create OK button
 var okButton = [[NSButton alloc] initWithFrame:NSMakeRect(10, 10, 100, 100)]
 [okButton setTitle:"Continue"]
 [okButton setBezelStyle:NSRoundedBezelStyle]
 [okButton sizeToFit]
 [okButton setKeyEquivalent:"\r"]
 [[window contentView] addSubview:okButton]
 
 // show window, and wait for the OK button to be pressed
 var okButtonTarget = [COTarget new]
 [okButton setTarget:okButtonTarget]
 [okButton setAction:"hit:"]
 
 var session = [NSApp beginModalSessionForWindow:window];
 while (1) {
 if ([NSApp runModalSession:session] != NSModalResponseContinue)
 break
 
 if ([okButtonTarget hasBeenHit]) {
 break
 }
 
 [NSThread sleepForTimeInterval:0.05]
 }
 [NSApp endModalSession:session];
 [window orderOut:nil]
*/

#import <Foundation/Foundation.h>
#import "MOJavaScriptObject.h"
#import <CocoaScript/COScript.h>

@interface COTarget : NSObject

@property MOJavaScriptObject *action;

+ (instancetype)targetWithAction:(MOJavaScriptObject *)action;

- (instancetype)initWithAction:(MOJavaScriptObject *)action;

- (void)hit:(id)sender;

@end
