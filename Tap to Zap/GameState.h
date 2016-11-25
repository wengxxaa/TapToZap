//
//  GameState.h
//  Tap to Zap
//
//  Created by Rauno Järvinen on 23/07/14.
//  Copyright (c) 2014 Dark Square Games OU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameState : NSObject

@property (nonatomic, assign) int score;
@property (nonatomic, assign) int highScore;

@property (nonatomic, assign) BOOL soundsOff;

+ (instancetype)sharedInstance;
- (void) saveState;
- (void) saveSoundState;

@end
