//
//  GameScene.h
//  Tap to Zap
//

//  Copyright (c) 2014 Dark Square Games OU. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Ball.h"
#import "Zapper.h"
#import "GameViewController.h"

@interface GameScene : SKScene<SKPhysicsContactDelegate>

@property (nonatomic) SKNode *menu;
@property (nonatomic) SKNode *scoreLabels;
@property (nonatomic) SKLabelNode *scoreLabel;
@property (nonatomic) SKLabelNode *highScoreLabel;
@property (nonatomic) SKLabelNode *comboLabel;
@property (nonatomic) SKLabelNode *bottomLabel;


@property (nonatomic) SKShapeNode *playButton;
@property (nonatomic) SKShapeNode *multiplayerButton;
@property (nonatomic) SKShapeNode *leaderboardButton;
@property (nonatomic) SKShapeNode *soundButton;
@property (nonatomic) SKLabelNode *soundButtonLabel;
@property (nonatomic) SKShapeNode *moreButton;

@property (nonatomic) SKNode *balls;
@property (nonatomic) SKNode *zappers;
@property (nonatomic) Zapper *zapperLeft;
@property (nonatomic) Zapper *zapperRight;
@property (nonatomic) SKShapeNode *line;

@property (nonatomic) SKShapeNode *gameArea;
@property (nonatomic) CGRect gameAreaFrame;

@property (nonatomic) int roundPoints;
@property (nonatomic) int ballsZapped;
@property (nonatomic) BOOL gameOn;
@property (nonatomic) BOOL resetingGame;

@property (nonatomic) BOOL zapping;
@property (nonatomic) BOOL zapped;

@property (nonatomic) int gameCount;

//Cleared

@property (nonatomic) SKLabelNode *clearedLabel;
@property (nonatomic) SKLabelNode *clearedPointsLabel;

//Sounds

@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;

@property (nonatomic) SKTexture *soundsOffTexture;
@property (nonatomic) SKTexture *soundsOnTexture;

@property (nonatomic) SKAction *popSound;
@property (nonatomic) SKAction *zapSound;

@property (nonatomic) GameViewController *controller;
-(void)setViewController:(GameViewController *)controller;

@end
