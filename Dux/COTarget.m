//
//  COTarget.m
//  Dux
//
//  Created by Abhi Beckert on 9/11/2013.
//
//

#import "COTarget.h"

@interface COTarget ()

@end

@implementation COTarget

+ (instancetype)targetWithAction:(MOJavaScriptObject *)action
{
  return [[[self class] alloc] initWithAction:action];
}

- (instancetype)initWithAction:(MOJavaScriptObject *)action
{
  if (!(self = [super init]))
  return nil;
  
  self.action = action;
  
  return self;
}

- (void)hit:(id)sender
{
  JSObjectRef actionRef = [self.action JSObject];
  
  COScript *script = [COScript currentCOScript];
  [script callJSFunction:actionRef withArgumentsInArray:@[sender]];
}

@end
