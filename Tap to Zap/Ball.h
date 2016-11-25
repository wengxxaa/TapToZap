//
//  Ball.h
//  Tap to Zap
//
//  Created by Rauno Järvinen on 21/10/14.
//  Copyright (c) 2014 darksquaregames. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Ball : SKShapeNode

@property (nonatomic) int level;
@property (nonatomic) BOOL onLine;

-(id) initWithLocation:(CGPoint)location level:(int)level;
-(UIColor *)getColor;
-(int)getPoints;

@end
