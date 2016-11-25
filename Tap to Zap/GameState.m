//
//  GameState.m
//  Tap to Zap
//
//  Created by Rauno Järvinen on 23/07/14.
//  Copyright (c) 2014 Dark Square Games OU. All rights reserved.
//

#import "GameState.h"

@implementation GameState

- (id) init
{
    if (self = [super init]) {
        // Init
        _score = 0;
        _highScore = 0;
        _soundsOff = NO;
        
        // Load game state
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        id highScore = [defaults objectForKey:@"highScore"];
        if (highScore) {
            _highScore = [highScore intValue];
        }
        
        id soundsOff =  [defaults objectForKey:@"soundsOff"];
        _soundsOff = [soundsOff boolValue];
    }
    return self;
}

- (void) saveState
{
    
    //NSLog(@"Saving the state!");
    // Update highScore if the current score is greater
    _highScore = MAX(_score, _highScore);
    
    // Store in user defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:_highScore] forKey:@"highScore"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) saveSoundState {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:_soundsOff] forKey:@"soundsOff"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (instancetype)sharedInstance
{
    static dispatch_once_t pred = 0;
    static GameState *_sharedInstance = nil;
    
    dispatch_once( &pred, ^{
        _sharedInstance = [[super alloc] init];
    });
    return _sharedInstance;
}

@end
