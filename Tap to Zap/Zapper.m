//
//  Zapper.m
//  Tap to Zap
//
//  Created by Rauno Järvinen on 21/10/14.
//  Copyright (c) 2013 darksquaregames. All rights reserved.
//

#import "Zapper.h"

@implementation Zapper

-(id) initWithLocation:(CGPoint)location
{
    if(self = [super init]) {
        self.position = location;
        self.texture = [SKTexture textureWithImageNamed:@"ZapBase"];
        self.size = CGSizeMake(28,28);
        [self initTurret];
    }
    return self;
}

-(void)initTurret {
    self.turret = [[SKSpriteNode alloc] initWithImageNamed:@"ZapTurret"];
    [self.turret setZPosition:2];
    [self.turret setSize:CGSizeMake(32,17)];
    if(self.position.x < 200) {
        [self.turret setPosition:CGPointMake(0,0)];
        [self.turret setAnchorPoint:CGPointMake(0.26,0.5)];
    }
    else {
        [self.turret setPosition:CGPointMake(0,0)];
        [self.turret setAnchorPoint:CGPointMake(0.26,0.5)];
        [self.turret setZRotation:M_PI];
    }
    
    [self addChild:self.turret];
}

- (void)rotateTurretToFace:(SKNode *)otherZapper {
    
    double angle = atan2(otherZapper.position.y - self.position.y, otherZapper.position.x - self.position.x);
    
    if (self.turret.zRotation < 0) {
        self.turret.zRotation = self.turret.zRotation + M_PI * 2;
    }
    [self.turret runAction:[SKAction rotateToAngle:angle duration:0]];
}

@end
