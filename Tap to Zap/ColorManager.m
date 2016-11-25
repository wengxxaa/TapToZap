//
//  ColorManager.m
//  Tap to Zap
//
//  Created by Rauno Järvinen on 24/11/2016.
//  Copyright © 2016 Dark Square Games OU. All rights reserved.
//

#import "ColorManager.h"

@implementation ColorManager

- (id) init
{
    if (self = [super init]) {
        // Init
        _dayMode = NO;
        
        // Load game state
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        id dayMode = [defaults objectForKey:@"dayMode"];
        if (dayMode) {
            _dayMode = [dayMode boolValue];
        }
    }
    return self;
}

- (void) saveDayMode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:_dayMode] forKey:@"dayMode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (instancetype)sharedInstance
{
    static dispatch_once_t pred = 0;
    static ColorManager *_sharedInstance = nil;
    
    dispatch_once( &pred, ^{
        _sharedInstance = [[super alloc] init];
    });
    return _sharedInstance;
}

@end
