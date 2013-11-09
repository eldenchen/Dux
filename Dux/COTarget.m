//
//  COTarget.m
//  Dux
//
//  Created by Abhi Beckert on 9/11/2013.
//
//

#import "COTarget.h"

@implementation COTarget

- (void)hit:(id)sender
{
  _hasBeenHit = YES;
}

- (BOOL)hasBeenHit
{
  return _hasBeenHit;
}

- (void)clear
{
  _hasBeenHit = NO;
}

@end
