//
//  DuxTheme.m
//  Dux
//
//  Created by Philippe de Reynal on 14/10/13.
//
//  This is free and unencumbered software released into the public domain.
//  For more information, please refer to <http://unlicense.org/>
//

#import <Foundation/Foundation.h>

@interface DuxTheme : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSColor *background;
@property (nonatomic, strong) NSColor *foreground;
@property (nonatomic, strong) NSColor *caret;
@property (nonatomic, strong) NSColor *selection;

@property (nonatomic, strong) NSDictionary *settings;
@property (nonatomic, strong) NSMutableDictionary *colors;

- (NSColor *)colorForKey:(NSString *)key;

+ (DuxTheme *)currentTheme;

+ (void)loadThemeNamed:(NSString *)name;

@end
