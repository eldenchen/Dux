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
 }
 [NSApp endModalSession:session];
 [window orderOut:nil]
*/

#import <Foundation/Foundation.h>

@interface COTarget : NSObject
{
  BOOL _hasBeenHit;
}

- (void)hit:(id)sender;

- (BOOL)hasBeenHit;

- (void)clear;

@end
