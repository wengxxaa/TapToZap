//
//  Zapper.h
//  Tap to Zap
//
//  Created by Rauno Järvinen on 21/10/14.
//  Copyright (c) 2014 darksquaregames. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Zapper : SKSpriteNode

-(id) initWithLocation:(CGPoint)location;
- (void)rotateTurretToFace:(SKNode *)otherZapper;

@property (nonatomic) CGPoint target;

@property (nonatomic) SKSpriteNode *turret;

@end
