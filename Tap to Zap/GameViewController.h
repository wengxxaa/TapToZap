//
//  GameViewController.h
//  Tap to Zap
//

//  Copyright (c) 2014 Dark Square Games OU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <GameKit/GameKit.h>
@import AVFoundation;

@interface GameViewController : UIViewController<GKGameCenterControllerDelegate>

@property (nonatomic) BOOL gameCenterEnabled;
@property (nonatomic, strong) NSString *leaderboardIdentifier;

@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;

@property (nonatomic) BOOL soundsOn;

-(void)reportScore:(int64_t)newScore;
-(void)showLeaderboard;
-(void)authenticateLocalPlayer;

@end
