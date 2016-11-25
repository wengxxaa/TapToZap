//
//  ColorManager.h
//  Tap to Zap
//
//  Created by Rauno Järvinen on 24/11/2016.
//  Copyright © 2016 Dark Square Games OU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorManager : NSObject


@property (nonatomic, assign) BOOL dayMode;

+ (instancetype)sharedInstance;
- (void) saveDayMode;
- (UIColor)getColor:(int)colorId;

@end
