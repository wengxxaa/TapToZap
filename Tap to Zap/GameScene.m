//
//  GameScene.m
//  Tap to Zap
//
//  Created by Rauno Järvinen on 21/10/14.
//  Copyright (c) 2014 Dark Square Games OU. All rights reserved.
//

#import "GameScene.h"
#import "GameState.h"
#import <Chartboost/Chartboost.h>

@implementation GameScene

static const uint32_t lineCategory =  0x1 << 0;
static const uint32_t ballCategory =  0x1 << 1;


#define SINGLEPLAYER 1
#define MULTIPLAYER 2

//static const float ZAPPER_DISTANCE = 25;
static int MAX_SPEED = 180;

static const float COOLDOWN = 0.5;

-(void)didMoveToView:(SKView *)view {
    [self initBackground];
    [self initPhysics];
    [self initMenu];
    [self initLabel];
    [self initComboLabel];
    [self initClearedLabels];
    [self initBottomLabel];
    [self initRails];
    [self initGameArea];
    [self initZappers];
    [self initSounds];
    [self initBalls];
    self.zapping = NO;
    [GameState sharedInstance].score = 0;
    self.gameOn = NO;
    self.gameCount = 0;
    self.resetingGame = NO;
    self.zapped = NO;
    self.physicsWorld.speed = 0;
    [self initMusic];
    [Chartboost cacheRewardedVideo:CBLocationMainMenu];
}

-(void)initMusic {
    NSError *error;
    NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"Background" withExtension:@"mp3"];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    [self.backgroundMusicPlayer prepareToPlay];
    if(![GameState sharedInstance].soundsOff)
        [self.backgroundMusicPlayer play];
}

-(void)initMenu {
    
    self.menu = [[SKNode alloc] init];
    [self addChild:self.menu];
    
    SKSpriteNode *title = [[SKSpriteNode alloc] initWithImageNamed:@"Title"];
    [title setSize:CGSizeMake(self.frame.size.width, title.size.height)];
    [title setPosition:CGPointMake(self.frame.size.width/2, self.frame.size.height - 25)];
    [self.menu addChild:title];
    [self.menu setZPosition:100];
    
    self.playButton = [SKShapeNode node];
    [self.playButton setPath:CGPathCreateWithRoundedRect(CGRectMake(0,0, self.frame.size.width/2, 32), 16, 16, nil)];
    [self.playButton setPosition:CGPointMake(self.frame.size.width/2 - self.frame.size.width/4, self.frame.size.height/2)];
    self.playButton.strokeColor = self.playButton.fillColor = [self getColor:7];//[SKColor colorWithRed:104.0/256.0 green:102.0/256.0 blue:99.0/256.0 alpha:1.0];
    self.playButton.name = @"Leaderboard";
    SKLabelNode *playLabel = [[SKLabelNode alloc] init];
    [playLabel setFontSize:18];
    [playLabel setFontColor:[SKColor colorWithRed:180.0/256.0 green:180.0/256.0 blue:180.0/256.0 alpha:1.0]];
    [playLabel setText:@"play"];
    [playLabel setName:@"Play"];
    [playLabel setFontName:@"BaronNeueBold"];
    [playLabel setPosition:CGPointMake(self.playButton.frame.size.width/2,9)];
    [self.playButton addChild:playLabel];
    [self.menu addChild:self.playButton];
    
    self.multiplayerButton = [SKShapeNode node];
    [self.multiplayerButton setPath:CGPathCreateWithRoundedRect(CGRectMake(0,0, self.frame.size.width/2, 32), 16, 16, nil)];
    [self.multiplayerButton setPosition:CGPointMake(self.frame.size.width/2 - self.frame.size.width/4, self.frame.size.height/2 - 128)];
    self.multiplayerButton.strokeColor = self.multiplayerButton.fillColor = [self getColor:6];//[SKColor colorWithRed:104.0/256.0 green:102.0/256.0 blue:99.0/256.0 alpha:1.0];
    self.multiplayerButton.name = @"Leaderboard";
    SKLabelNode *multiplayerLabel = [[SKLabelNode alloc] init];
    [multiplayerLabel setFontSize:18];
    [multiplayerLabel setFontColor:[SKColor colorWithRed:180.0/256.0 green:180.0/256.0 blue:180.0/256.0 alpha:1.0]];
    [multiplayerLabel setText:@"multiplayer"];
    [multiplayerLabel setName:@"Multiplayer"];
    [multiplayerLabel setFontName:@"BaronNeueBold"];
    [multiplayerLabel setPosition:CGPointMake(self.multiplayerButton.frame.size.width/2,9)];
    [self.multiplayerButton addChild:multiplayerLabel];
    [self.menu addChild:self.multiplayerButton];
    
    self.leaderboardButton = [SKShapeNode node];
    [self.leaderboardButton setPath:CGPathCreateWithRoundedRect(CGRectMake(0,0, self.frame.size.width/2, 32), 16, 16, nil)];
    [self.leaderboardButton setPosition:CGPointMake(self.frame.size.width/2 - self.frame.size.width/4, self.frame.size.height/2 - 96)];
    self.leaderboardButton.strokeColor = self.leaderboardButton.fillColor = [self getColor:5];//[SKColor colorWithRed:104.0/256.0 green:102.0/256.0 blue:99.0/256.0 alpha:1.0];
    self.leaderboardButton.name = @"Leaderboard";
    SKLabelNode *leaderboardLabel = [[SKLabelNode alloc] init];
    [leaderboardLabel setFontSize:18];
    [leaderboardLabel setFontColor:[SKColor colorWithRed:180.0/256.0 green:180.0/256.0 blue:180.0/256.0 alpha:1.0]];
    [leaderboardLabel setText:@"leaderboard"];
    [leaderboardLabel setName:@"Leaderboard"];
    [leaderboardLabel setFontName:@"BaronNeueBold"];
    [leaderboardLabel setPosition:CGPointMake(self.leaderboardButton.frame.size.width/2,9)];
    [self.leaderboardButton addChild:leaderboardLabel];
    [self.menu addChild:self.leaderboardButton];
    
    self.soundButton = [SKShapeNode node];
    [self.soundButton setPath:CGPathCreateWithRoundedRect(CGRectMake(0,0, self.frame.size.width/2, 32), 16, 16, nil)];
    [self.soundButton setPosition:CGPointMake(self.frame.size.width/2 - self.frame.size.width/4, self.frame.size.height/2 - 64)];
    self.soundButton.strokeColor = self.soundButton.fillColor = [self getColor:4];
    
    [self.menu addChild:self.soundButton];
    
    self.soundButtonLabel = [[SKLabelNode alloc] init];
    [self.soundButtonLabel setFontSize:18];
    [self.soundButtonLabel setFontColor:[SKColor colorWithRed:180.0/256.0 green:180.0/256.0 blue:180.0/256.0 alpha:1.0]];
    [self.soundButtonLabel setText:@"Sounds"];
    [self.soundButtonLabel setName:@"Sounds"];
    [self.soundButtonLabel setFontName:@"BaronNeueBold"];
    [self.soundButtonLabel setPosition:CGPointMake(self.soundButton.frame.size.width/2,9)];
    [self.soundButton addChild:self.soundButtonLabel];
    
    self.moreButton = [SKShapeNode node];
    [self.moreButton setPath:CGPathCreateWithRoundedRect(CGRectMake(0,0, self.frame.size.width/2, 32), 16, 16, nil)];
    [self.moreButton setPosition:CGPointMake(self.frame.size.width/2 - self.frame.size.width/4, self.frame.size.height/2 + 64)];
    self.moreButton.strokeColor = self.moreButton.fillColor = [self getColor:3];
    
    [self.menu addChild:self.moreButton];
    
    SKLabelNode *moreLabel = [[SKLabelNode alloc] init];
    [moreLabel setFontSize:18];
    [moreLabel setFontColor:[SKColor colorWithRed:180.0/256.0 green:180.0/256.0 blue:180.0/256.0 alpha:1.0]];
    [moreLabel setText:@"More"];
    [moreLabel setName:@"More"];
    [moreLabel setFontName:@"BaronNeueBold"];
    [moreLabel setPosition:CGPointMake(self.moreButton.frame.size.width/2,9)];
    [self.moreButton addChild:moreLabel];
}

-(void)addStartBall {
    Ball *ball = [[Ball alloc] initWithLocation:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) level:6];
    [self.balls addChild:ball];
    
    int randomXVelocity = arc4random_uniform(MAX_SPEED*2) - MAX_SPEED;
    int randomYVelocity = MAX_SPEED - abs(randomXVelocity);
    if([self randomBool])
        randomYVelocity *= -1;
    
    //NSLog([NSString stringWithFormat:@"X: %i, Y: %i", randomXVelocity, randomYVelocity]);
    
    [ball.physicsBody setVelocity:CGVectorMake(randomXVelocity, randomYVelocity)];
    
    
}

-(void)turnSoundsOn {
    //NSLog(@"Sounds on");
    [GameState sharedInstance].soundsOff = NO;
    [[GameState sharedInstance] saveSoundState];
    
    [self.soundButtonLabel setText:@"Sounds on"];
    [self.backgroundMusicPlayer play];
}

-(void)turnSoundsOff {
    //NSLog(@"Sounds off");
    [GameState sharedInstance].soundsOff = YES;
    [[GameState sharedInstance] saveSoundState];
    [self.soundButtonLabel setText:@"Sounds off"];
    [self.backgroundMusicPlayer stop];
}


-(void)initComboLabel {
    self.comboLabel = [[SKLabelNode alloc] init];
    [self.comboLabel setFontSize:18];
    [self.comboLabel setFontColor:[SKColor colorWithRed:180.0/256.0 green:180.0/256.0 blue:180.0/256.0 alpha:1.0]];
    [self.comboLabel setFontName:@"BaronNeueBold"];
    [self.comboLabel setText:@"combo!"];
    [self.comboLabel setPosition:CGPointMake(0,0)];
    [self.comboLabel setHidden:YES];
    [self addChild:self.comboLabel];
}

-(void)initClearedLabels {
    self.clearedLabel = [[SKLabelNode alloc] init];
    [self.clearedLabel setFontSize:32];
    [self.clearedLabel setFontColor:[SKColor colorWithRed:180.0/256.0 green:180.0/256.0 blue:180.0/256.0 alpha:1.0]];
    [self.clearedLabel setFontName:@"BaronNeueBold"];
    [self.clearedLabel setText:@"cleared"];
    [self.clearedLabel setPosition:CGPointMake(self.frame.size.width/2,self.frame.size.height/2)];
    [self.clearedLabel setAlpha:0];
    [self addChild:self.clearedLabel];
    
    self.clearedPointsLabel = [[SKLabelNode alloc] init];
    [self.clearedPointsLabel setFontSize:32];
    [self.clearedPointsLabel setFontColor:[SKColor colorWithRed:180.0/256.0 green:180.0/256.0 blue:180.0/256.0 alpha:1.0]];
    [self.clearedPointsLabel setFontName:@"BaronNeueBold"];
    [self.clearedPointsLabel setText:@"points x 2"];
    [self.clearedPointsLabel setPosition:CGPointMake(self.frame.size.width/2,self.frame.size.height/2-50)];
    [self.clearedPointsLabel setAlpha:0];
    [self addChild:self.clearedPointsLabel];
}

-(void)showClearedLabels {
    
    [self stopZappers];
    
    SKAction *waitAction = [SKAction waitForDuration:1];
    SKAction *waitAction2 = [SKAction waitForDuration:2];
    
    SKAction *fadeInAction = [SKAction fadeAlphaTo:1.0 duration:0.5];
    SKAction *fadeInAction2 = [SKAction fadeAlphaTo:1.0 duration:0.5];
    
    [self.clearedLabel runAction:[SKAction sequence:@[waitAction, fadeInAction]]];
    [self.clearedPointsLabel runAction:[SKAction sequence:@[waitAction2, fadeInAction2]] completion:^{
        [GameState sharedInstance].score = [GameState sharedInstance].score * 2;
        [self updatePoints];
        [self stopGame];
    }];
}

-(void)hideClearedLabels {
    SKAction *fadeOutAction = [SKAction fadeAlphaTo:0 duration:0.5];
    
    [self.clearedLabel runAction:fadeOutAction];
    [self.clearedPointsLabel runAction:fadeOutAction];
}

-(void)updateScoreLabel {
    [self.scoreLabel setText:[NSString stringWithFormat:@"%i", [GameState sharedInstance].score]];
}

-(void)showComboLabel {
    if(self.comboLabel.hidden) {
        [self turnComboLabel];
        [self.comboLabel setPosition:CGPointMake(self.frame.size.width/2, (self.zapperLeft.position.y + self.zapperRight.position.y)/2 -20)];
        [self.comboLabel setHidden:NO];
    }
}

-(void)turnComboLabel {
    double angle = atan2(self.zapperLeft.position.y - self.zapperRight.position.y, self.zapperLeft.position.x - self.zapperRight.position.x);
        
    self.comboLabel.zRotation = angle - M_PI;
}

-(void)hideComboLabel {
    if(!self.comboLabel.hidden) {
        [self.comboLabel setHidden:YES];
    }
}

-(void)showMenu {
    self.gameOn = NO;
    [self.menu setHidden:NO];
    [self moveZappersToCenter];
}

-(void)moveZappersToCenter {
    [self.zapperLeft removeAllActions];
    [self.zapperRight removeAllActions];
    
    SKAction *moveToCenterAction = [SKAction moveToY:self.frame.size.height/2 duration:0.5];
    moveToCenterAction.timingMode = SKActionTimingEaseInEaseOut;
    
    [self.zapperLeft runAction:moveToCenterAction];
    [self.zapperRight runAction:moveToCenterAction completion:^{
        self.resetingGame = NO;
    }];
}

-(void)initBackground {
    self.backgroundColor = [UIColor colorWithRed:35.0/255.0
                                           green:35.0/255.0
                                            blue:35.0/255.0
                                           alpha:1.0];
}

-(void)initPhysics {
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
}

-(void)initLabel {
    self.scoreLabels = [[SKNode alloc] init];
    [self.scoreLabels setHidden:YES];
    [self addChild:self.scoreLabels];
    
    self.scoreLabel = [[SKLabelNode alloc] init];
    [self.scoreLabel setFontSize:36];
    [self.scoreLabel setFontColor:[SKColor colorWithRed:180.0/256.0 green:180.0/256.0 blue:180.0/256.0 alpha:1.0]];
    [self.scoreLabel setText:@"0"];
    [self.scoreLabel setFontName:@"BaronNeueBold"];
    [self.scoreLabel setPosition:CGPointMake(self.frame.size.width/2,self.frame.size.height - 40)];
    [self.scoreLabels addChild:self.scoreLabel];
    
    
    SKLabelNode *highScoreTitle = [[SKLabelNode alloc] init];
    [highScoreTitle setFontName:@"BaronNeueBold"];
    [highScoreTitle setFontSize:16];
    [highScoreTitle setText:@"High Score"];
    [highScoreTitle setPosition:CGPointMake(10, self.frame.size.height-20)];
    [highScoreTitle setFontColor:[SKColor colorWithRed:180.0/256.0 green:180.0/256.0 blue:180.0/256.0 alpha:1.0]];
    [highScoreTitle setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeLeft];
    [self.scoreLabels addChild:highScoreTitle];
    
    self.highScoreLabel = [[SKLabelNode alloc] init];
    [self.highScoreLabel setFontName:@"BaronNeueBold"];
    [self.highScoreLabel setFontSize:16];
    [self.highScoreLabel setPosition:CGPointMake(10, self.frame.size.height-40)];
    [self.highScoreLabel setFontColor:[SKColor colorWithRed:180.0/256.0 green:180.0/256.0 blue:180.0/256.0 alpha:1.0]];
    [self.highScoreLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeLeft];

    [self.scoreLabels addChild:self.highScoreLabel];
    [self.highScoreLabel setText:[NSString stringWithFormat:@"%d", ([GameState sharedInstance].highScore)]];
}

-(void)initRails {
    SKShapeNode* rail = [SKShapeNode node];
    [rail setPath:CGPathCreateWithRoundedRect(CGRectMake(20, 50, 10, self.frame.size.height-100), 4, 4, nil)];
    rail.strokeColor = rail.fillColor = [UIColor colorWithRed:56.0/255.0
                                                        green:56.0/255.0
                                                         blue:56.0/255.0
                                                        alpha:1.0];
    
    SKShapeNode* rail2 = [SKShapeNode node];
    [rail2 setPath:CGPathCreateWithRoundedRect(CGRectMake(self.frame.size.width-30, 50, 10, self.frame.size.height-100), 4, 4, nil)];
    rail2.strokeColor = rail2.fillColor = [UIColor colorWithRed:56.0/255.0
                                                        green:56.0/255.0
                                                         blue:56.0/255.0
                                                        alpha:1.0];
    
    [self addChild:rail];
    [self addChild:rail2];
}

-(void)initGameArea {
    
    self.gameAreaFrame = CGRectMake(0, 0, self.frame.size.width-100, self.frame.size.height-100);
    self.gameArea = [[SKShapeNode alloc] init];
    [self.gameArea setPath:CGPathCreateWithRect(self.gameAreaFrame, nil)];
    self.gameArea.strokeColor = self.gameArea.fillColor = [UIColor colorWithRed:25.0/255.0
                                                green:25.0/255.0
                                                 blue:25.0/255.0
                                                alpha:1.0];
    self.gameArea.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.gameAreaFrame];
    self.gameArea.physicsBody.collisionBitMask = 2;
    [self.gameArea.physicsBody setRestitution:1.0f];
    [self.gameArea.physicsBody setFriction:0.0f];
    [self.gameArea.physicsBody setLinearDamping:0.0f];
    [self.gameArea setPosition:CGPointMake(50,50)];
    [self.gameArea setName:@"Start"];
    [self addChild:self.gameArea];
}

-(void)initBottomLabel {
    self.bottomLabel = [[SKLabelNode alloc] init];
    [self.bottomLabel setFontName:@"BaronNeueBold"];
    [self.bottomLabel setFontSize:32];
    [self.bottomLabel setPosition:CGPointMake(self.frame.size.width/2, 10)];
    [self.bottomLabel setFontColor:[SKColor colorWithRed:180.0/256.0 green:180.0/256.0 blue:180.0/256.0 alpha:1.0]];
    [self.bottomLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
    [self.bottomLabel setText:@""];
    [self.bottomLabel setAlpha:0];
    
    [self addChild:self.bottomLabel];
}

-(void)showDontMiss {
    [self.bottomLabel setText:@"don't miss!"];
    [self.bottomLabel setAlpha:1];
    SKAction *waitAction = [SKAction waitForDuration:0.5];
    SKAction *hideAction = [SKAction fadeAlphaTo:0 duration:0.5];
    [self.bottomLabel runAction:[SKAction sequence:@[waitAction, hideAction]]];
}

-(void)showTapToReset {
    [self.bottomLabel setText:@"tap to reset"];
    SKAction *fadeInAction = [SKAction fadeAlphaTo:1 duration:1];
    SKAction *fadeOutAction = [SKAction fadeAlphaTo:0.5 duration:1];
    [self.bottomLabel runAction:[SKAction repeatActionForever:[SKAction sequence:@[fadeInAction, fadeOutAction]]]];
}

-(void)hideBottomLabel {
    [self.bottomLabel setAlpha:0];
    [self.bottomLabel removeAllActions];
}

-(void)startGame {
    self.gameOn = YES;
    [self addStartBall];
    [GameState sharedInstance].score = 0;
    self.roundPoints = 0;
    [self.zapperLeft removeAllActions];
    [self.zapperRight removeAllActions];
    [self.menu setHidden:YES];
    [self.scoreLabels setHidden:NO];
    self.physicsWorld.speed = 1;
    [self showDontMiss];
}

-(void)resetGame {
    
    [self hideBottomLabel];
    self.gameCount += 1;
    //[self.balls removeAllChildren];
    self.roundPoints = 0;
    
    [self removeAllActions];
    [self.line removeFromParent];
    [self.balls removeAllChildren];
    [self addStartBall];
    [self.scoreLabels setHidden:YES];
    [self showMenu];
    if(self.gameCount % 5 == 0)
        [Chartboost showInterstitial:CBLocationHomeScreen];
    [self hideClearedLabels];
    [[GameState sharedInstance] saveState];
    [self sendScore];
    [GameState sharedInstance].score = 0;
    [self.highScoreLabel setText:[NSString stringWithFormat:@"%d", ([GameState sharedInstance].highScore)]];
}

-(void)highlightLine {
    [self.line removeAllActions];
    SKAction *fadeInAction = [SKAction fadeAlphaTo:1 duration:COOLDOWN];
    SKAction *fadeOutAction = [SKAction fadeAlphaTo:0 duration:COOLDOWN];
    [self.line runAction:[SKAction repeatActionForever:[SKAction sequence:@[fadeInAction, fadeOutAction]]]];
}

-(void)stopGame {
    self.resetingGame = YES;
    self.physicsWorld.speed = 0;
    [self highlightLine];
    [self.zapperLeft removeAllActions];
    [self.zapperRight removeAllActions];
    [self showTapToReset];
    
    NSLog(@"Show rewarded video");
    if([Chartboost hasRewardedVideo:CBLocationMainMenu]) {
        NSLog(@"Works");
        [Chartboost showRewardedVideo:CBLocationMainMenu];
    }
    else {
        NSLog(@"No video available, cache one");
        // We don't have a cached video right now, but try to get one for next time
        [Chartboost cacheRewardedVideo:CBLocationMainMenu];
    }
}


-(void)updatePoints {
    SKAction *growAction = [SKAction scaleTo:1.1 duration:0.1];
    SKAction *shrinkAction = [SKAction scaleTo:1.0 duration:0.1];
    [self.scoreLabel setText:[NSString stringWithFormat:@"%i", [GameState sharedInstance].score]];
    [self.scoreLabel runAction:[SKAction sequence:@[growAction, shrinkAction]]];
}

-(void)initBalls {
    self.balls = [[SKNode alloc] init];
    [self addChild:self.balls];
    //[self addStartBall];
}

-(void)initZappers {
    
    self.zappers = [[SKNode alloc] init];
    [self addChild:self.zappers];
    
    self.zapperLeft = [[Zapper alloc] initWithLocation:CGPointMake(25,self.frame.size.height/2)];
    
    self.zapperRight = [[Zapper alloc] initWithLocation:CGPointMake(self.frame.size.width-25, self.frame.size.height/2)];
    
    [self.zappers addChild:self.zapperLeft];
    [self.zappers addChild:self.zapperRight];
}

-(void)initSounds {
    self.popSound = [SKAction playSoundFileNamed:@"Pop.wav" waitForCompletion:NO];
    self.zapSound = [SKAction playSoundFileNamed:@"Zap.wav" waitForCompletion:NO];
}

-(void)stopZappers {
    [self removeAllActions];
}

-(void)setTimer {
    id wait = [SKAction waitForDuration:1.25];
    id run = [SKAction runBlock:^{
        [self setRandomLocation];
    }];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[wait, run]]]];
}

-(void)setRandomLocation {
    //NSLog(@"Set random location");
    
    //zapper.target = CGPointMake(zapper.position.x, [self getRandomLocation]);
    
    SKAction *moveAction = [SKAction moveToY:[self getRandomLocation] duration:1];
    moveAction.timingMode = SKActionTimingEaseInEaseOut;
    [self.zapperLeft runAction:moveAction];
    moveAction = [SKAction moveToY:[self getRandomLocation] duration:1];
    moveAction.timingMode = SKActionTimingEaseInEaseOut;
    [self.zapperRight runAction:moveAction];
}

-(int)getRandomLocation {
    return 100 + arc4random()%(int)(self.frame.size.height-200);
}

-(void)zap {
    
    self.zapped = YES;
    self.roundPoints = 0;
    [self removeAllActions];
    if(![GameState sharedInstance].soundsOff)
        [self runAction:self.zapSound];
    
    [self.zapperLeft removeAllActions];
    [self.zapperRight removeAllActions];
    
    self.zapping = YES;
    
    CGMutablePathRef pathToDraw;
    pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, self.zapperRight.position.x, self.zapperRight.position.y);
    CGPathAddLineToPoint(pathToDraw, NULL, self.zapperLeft.position.x, self.zapperLeft.position.y);
    CGPathCloseSubpath(pathToDraw);
    
    self.line = [[SKShapeNode alloc] init];
    self.line.lineWidth = 1;
    self.line.path = pathToDraw;
    self.line.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:self.zapperLeft.position toPoint:self.zapperRight.position];
    self.line.physicsBody.categoryBitMask = lineCategory;
    self.line.physicsBody.collisionBitMask = 0;
    self.line.physicsBody.contactTestBitMask = ballCategory;
    CGPathRelease(pathToDraw);
    self.line.strokeColor = [SKColor colorWithRed:180.0/256.0 green:180.0/256.0 blue:180.0/256.0 alpha:1.0];
    
    [self addChild:self.line];
    
    SKAction *fadeOut = [SKAction fadeAlphaTo:0 duration:COOLDOWN];
    [self.line runAction:fadeOut completion:^{
        self.zapping = NO;
        [self hideComboLabel];
        if(self.ballsZapped == 0) {
            [self stopGame];
        }
        else {
            [self setRandomLocation];
            [self setTimer];
            [self.line removeFromParent];
            if(self.balls.children.count == 0)
                [self showClearedLabels];
        }
        self.ballsZapped = 0;
    }];
}

-(void)zapEffect:(Ball *)ball {
    NSString *myParticlePath = [[NSBundle mainBundle] pathForResource:@"Zap" ofType:@"sks"];
    SKEmitterNode *myParticle = [NSKeyedUnarchiver unarchiveObjectWithFile:myParticlePath];
    
    myParticle.particlePosition = ball.position;
    myParticle.particleColor = [ball getColor];
    
    [self addChild:myParticle];
}

-(void)pointEffect:(Ball *)ball {
    if([ball getPoints] > 0) {
        SKLabelNode *pointLabel = [[SKLabelNode alloc] init];
        [pointLabel setFontSize:32];
        [pointLabel setFontColor:[SKColor colorWithRed:180.0/256.0 green:180.0/256.0 blue:180.0/256.0 alpha:1.0]];
        [pointLabel setText:[NSString stringWithFormat:@"+%i", [ball getPoints]]];
        [pointLabel setFontColor:[ball getColor]];
        [pointLabel setFontName:@"BaronNeueBold"];
        [pointLabel setPosition:ball.position];
        [self addChild:pointLabel];
        
        SKAction *moveUp = [SKAction moveByX:0 y:20 duration:0.5];
        [pointLabel runAction:moveUp completion:^{
            [pointLabel removeFromParent];
        }];
    }
}

-(void)zapBall:(Ball *)ball {
    //NSLog(@"ZAP BALL");
    SKAction *waitAction = [SKAction waitForDuration:0.05*self.ballsZapped];

    if(![GameState sharedInstance].soundsOff)
        [self runAction:[SKAction sequence:@[waitAction, self.popSound]]];
    
    self.ballsZapped += 1;
    if(self.ballsZapped > 1)
        [self showComboLabel];
    if(ball.level > 1) {
        Ball *ball1 = [[Ball alloc] initWithLocation:ball.position level:ball.level-1];
        Ball *ball2 = [[Ball alloc] initWithLocation:ball.position level:ball.level-1];
        
        //[ball1.physicsBody setVelocity:CGVectorMake(-ball.physicsBody.velocity.dx, ball.physicsBody.velocity.dy)];
        //[ball2.physicsBody setVelocity:CGVectorMake(ball.physicsBody.velocity.dx, -ball.physicsBody.velocity.dy)];
        
        int randomXVelocity = arc4random_uniform(MAX_SPEED*2) - MAX_SPEED;
        int randomYVelocity = MAX_SPEED - abs(randomXVelocity);
        if([self randomBool])
            randomYVelocity *= -1;
        
        //NSLog([NSString stringWithFormat:@"X: %i, Y: %i", randomXVelocity, randomYVelocity]);
        
        [ball1.physicsBody setVelocity:CGVectorMake(randomXVelocity, randomYVelocity)];
        [ball2.physicsBody setVelocity:CGVectorMake(-randomXVelocity, -randomYVelocity)];
        
        [self.balls addChild:ball1];
        [self.balls addChild:ball2];
    }
    self.roundPoints += [ball getPoints];
    [self updatePoints];
    [self zapEffect:ball];
    [self pointEffect:ball];
    [ball removeFromParent];
}

-(BOOL)randomBool {
    int tmp = (arc4random() % 2);
    //NSLog([NSString stringWithFormat:@"Random tmp: %i", tmp]);
    if(tmp < 1)
        return YES;
    else
        return NO;
}


-(void)didSimulatePhysics {
    if(self.zapped) {
        if(self.ballsZapped == 0) {
            self.zapped = NO;
            [self.physicsWorld setSpeed:0];
        }
        else {
            [GameState sharedInstance].score = [GameState sharedInstance].score + self.roundPoints*self.ballsZapped;
            
            self.zapped = NO;
            [self updatePoints];
            //NSLog(@"DID FINISH UPDATING");
        }
    }
    self.line.physicsBody = nil;
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    
    if(contact.bodyA.categoryBitMask == lineCategory && contact.bodyB.categoryBitMask == ballCategory)
    {
        [self zapBall:(Ball *)contact.bodyB.node];
    }
    else if(contact.bodyB.categoryBitMask == lineCategory && contact.bodyA.categoryBitMask == ballCategory)
    {
        [self zapBall:(Ball *)contact.bodyA.node];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!self.resetingGame) {
        if(self.gameOn && !self.zapping)
            [self zap];
        else if(!self.gameOn) {
            for (UITouch *touch in touches) {
                CGPoint location = [touch locationInNode:self];
                SKNode *node = (SKNode *)[self nodeAtPoint:location];
                if(CGRectContainsPoint(self.soundButton.frame, location)) {
                    if(![GameState sharedInstance].soundsOff)
                        [self turnSoundsOff];
                    else
                        [self turnSoundsOn];
                }
                else if(CGRectContainsPoint(self.moreButton.frame,location)) {
                    [Chartboost showMoreApps:CBLocationHomeScreen];
                }
                else if(CGRectContainsPoint(self.leaderboardButton.frame, location)) {
                    [self showScores];
                }
                else if(CGRectContainsPoint(self.playButton.frame, location)){
                    [self zap];
                    [self startGame];
                }
            }
        }
    }
    else {
        [self resetGame];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    [self.zapperLeft rotateTurretToFace:self.zapperRight];
    [self.zapperRight rotateTurretToFace:self.zapperLeft];
}

// HELPERS



- (void)rotateNode:(SKNode *)nodeA toFaceNode:(SKNode *)nodeB {
    
    double angle = atan2(nodeB.position.y - nodeA.position.y, nodeB.position.x - nodeA.position.x);
    
    if (nodeA.zRotation < 0) {
        nodeA.zRotation = nodeA.zRotation + M_PI * 2;
    }
    
    [nodeA runAction:[SKAction rotateToAngle:angle duration:0]];
}

//Gamecenter stuff

-(void)setViewController:(GameViewController *)controller
{
    self.controller = controller;
}

-(void)sendScore
{
    int64_t score = (int64_t)[GameState sharedInstance].highScore;
    [self.controller reportScore:score];
}

-(void)showScores
{
    [self.controller showLeaderboard];
}

@end
