//
//  PlaywinConnection.h
//  Tap to Zap
//
//  Created by Rauno Järvinen on 11/10/2016.
//  Copyright © 2016 Dark Square Games OU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaywinConnection : NSObject

@property (nonatomic) NSString *gameId;
@property (nonatomic) NSString *clientId;
@property (nonatomic) NSString *clientSecret;
@property (nonatomic) NSString *accessToken;

- (void)signInToPlayWin:(NSString *)username password:(NSString *)password;
- (void)registerToPlayWin:(NSString *)username password:(NSString *)password firstname:(NSString *)firstname lastname:(NSString *)lastname email:(NSString *)email;

- (void)getPlayWinAccountBalance:(NSString *)type;

- (void)depositToKalixa:(NSString *)methodId amount:(int)amount;
- (void)withrawFromKalixa:(NSString *)methodId amount:(int)amount;

- (void)depositToPaypal:(int)amount;
- (void)withrawFromPaypal:(int)amount email:(NSString *)email;

- (void)depositToCubits:(int)amount;
- (void)withrawFromCubits:(int)amount email:(NSString *)email;

+ (instancetype)sharedInstance;

@end
