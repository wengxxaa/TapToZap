//
//  Ball.m
//  Tap to Zap
//
//  Created by Rauno Järvinen on 21/10/14.
//  Copyright (c) 2013 darksquaregames. All rights reserved.
//

#import "Ball.h"

@implementation Ball

static const uint32_t lineCategory =  0x1 << 0;
static const uint32_t ballCategory =  0x1 << 1;

-(id) initWithLocation:(CGPoint)location level:(int)level
{
    if(self = [super init]) {
        self.position = location;
        
        CGMutablePathRef path = CGPathCreateMutable();
        self.level = level;
        CGPathAddArc(path, NULL, 0,0, [self getSize], 0, M_PI*2, YES);
        self.path = path;
        self.fillColor = [self getColor];
        self.strokeColor = [self getColor];
        [self initPhysicsBody];
        self.name = @"Ball";
        self.onLine = NO;
    }
    return self;
}

-(void)initPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:[self getSize]];
    self.physicsBody.dynamic = YES;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.mass = 0.20;
    [self.physicsBody setRestitution:1.0f];
    [self.physicsBody setFriction:0.0f];
    [self.physicsBody setLinearDamping:0.0f];
    [self.physicsBody setVelocity:CGVectorMake(100.0, 100.0)];
    [self.physicsBody setAllowsRotation:NO];
    
    self.physicsBody.categoryBitMask = ballCategory;
    self.physicsBody.collisionBitMask = 2;
    self.physicsBody.contactTestBitMask = lineCategory;
}

-(UIColor *)getColor {
    if(self.level == 7)
        return [SKColor colorWithRed:14.0/256.0 green:45.0/256.0 blue:77.0/256.0 alpha:1.0];
    else if(self.level == 6)
        return [SKColor colorWithRed:19.0/256.0 green:90.0/256.0 blue:103.0/256.0 alpha:1.0];
    else if(self.level == 5)
        return [SKColor colorWithRed:4.0/256.0 green:129.0/256.0 blue:118.0/256.0 alpha:1.0];
    else if(self.level == 4)
        return [SKColor colorWithRed:19.0/256.0 green:120.0/256.0 blue:80.0/256.0 alpha:1.0];
    else if(self.level == 3)
        return [SKColor colorWithRed:178.0/256.0 green:148.0/256.0 blue:28.0/256.0 alpha:1.0];
    else if(self.level == 2)
        return [SKColor colorWithRed:174.0/256.0 green:68.0/256.0 blue:27.0/256.0 alpha:1.0];
    else if(self.level == 1)
        return [SKColor colorWithRed:142.0/256.0 green:26.0/256.0 blue:26.0/256.0 alpha:1.0];
    else
        return [UIColor redColor];
}

-(int)getPoints {
    if(self.level == 7)
        return 0;
    else if(self.level == 6)
        return 0;
    else if(self.level == 5)
        return 10;
    else if(self.level == 4)
        return 20;
    else if(self.level == 3)
        return 40;
    else if(self.level == 2)
        return 60;
    else if(self.level == 1)
        return 80;
    
    return 0;
}

-(float)getSize {
    if(self.level == 6)
        return 80;
    else
        return self.level * 8;
}

-(void)zap {
    
}

@end
