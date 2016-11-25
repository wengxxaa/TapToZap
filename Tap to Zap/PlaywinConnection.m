//
//  PlaywinConnection.m
//  Tap to Zap
//
//  Created by Rauno Järvinen on 11/10/2016.
//  Copyright © 2016 Dark Square Games OU. All rights reserved.
//

#import "PlaywinConnection.h"

@implementation PlaywinConnection

- (id) init
{
    if (self = [super init]) {
        
        
        //Add your game ID, an ID that has been generated for your game specifically in the developer console
        self.gameId = @"<INSERT_YOUR_GAME_ID_HERE>";
        self.clientId = @"<INSERT_YOUR_CLIENT_ID_HERE>";
        self.clientSecret = @"<INSERT_YOUR_CLIENT_SECRET_HERE>";
        
    }
    return self;
}

/*
 User Login
 
 grant_type=grantType&username=username&password=password&client_id=clientID&client_secret=clientSecret
 
 grantType Oauth2 grant type. Currently only the password grant type is supported 
 username Username
 password Password
 clientId Client ID
 clientSecret Client secret
 
 */
- (void)signInToPlayWin:(NSString *)username password:(NSString *)password  {
    
    NSString *post = [NSString stringWithFormat:@"grant_type=password&username=%@&password=%@&client_id=%@&client_secret=%@", username, password, self.clientId, self.clientSecret];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://api.playwin.me/api/auth/token"]];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    //If successfully signed in, save the access_token
    
    //Possible responses:
    /*
     200 Access token was successfully generated
     Response body JSON: {"access_token":"77d1aeb3fda2235a0c87d9ec19d460c1","expires_in":3600}
     access_token Access token to utilize as a Bearer token in Authorization header of protected API requests
     expires_in Expiry of token in minutes\
     400 Could not generate access token
     Response body: {"error":"","error_description":"","error_uri":"","state":""}
     error Error message error_description Error description error_uri Error URI
     state State
     500 Internal server error
     
     */
}

/*
 User Account registration
 This is the minimum set of parameters being sent to the backend on registration
 In addition you could also list:
 
 languagecode,
 countrycode,
 dateofbirth,
 gender,
 street,
 housenumber,
 housenumberext,
 postalcode,
 city,
 state,
 telephonenumber
 */
- (void)registerToPlayWin:(NSString *)username password:(NSString *)password firstname:(NSString *)firstname lastname:(NSString *)lastname email:(NSString *)email {
    
    NSString *post = [NSString stringWithFormat:@"username=%@&password=%@&firstname=%@&lastname=%@&email=%@",username, password, firstname, lastname, email];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.playwin.me/api/accounts/account/register?gameid=%@", self.gameId]]];
    
    [request setHTTPMethod:@"PUT"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    //Possible responses:
    
    //200 User account was successfully registered
    //400 Could not create account
    //500 Internal server error
}

/*
 
 User account balance
 
 Endpoint for retrieving a user's account balance.
 This endpoint is protected and requires an Authorization header with an access token. Store the access token on sign in to be able to use it here.
 
 Parameters:
 gameId Game Id
 type Type of Money (real, game)
 
 */

- (void)getPlayWinAccountBalance:(NSString *)type {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.playwin.me/api/accounts/account/balance?gameid=%@&type=%@", self.gameId]]];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:self.accessToken forHTTPHeaderField:@"Authorization"];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    //Possible responses:
    
    /*
    200 Account balance
    Example JSON: "total":100, "reserved":10, "pendingWithdraw":10, "available":80 
    400 Could not get account balance
    500 Internal server error
     */
}

#pragma mark - Kalixa

/*
 
 Kalixa deposit
 
 Endpoint for initializing a Kalixa deposit transaction. This endpoint redirects to the Kalixa payment page. Before creating a transaction, a geolocation check performed. Based on the requested payment method, the system verifies that the payment method is allowed from where the user is currently located.
 This endpoint is protected and requires an Authorization header with an access token. See the section 2 of this document for information on how to retrieve an access token.
 
 Parameters:
 
 methodId options:
 1 ECMC Deposit (Mastercard) 
 2 VISA Deposit
 12 VISA Withdrawal
 38 Mastercard Withdrawal
 4 NETeller Deposit
 5 NETeller Withdrawal
 
 amount Transaction amount
 
 */

- (void)depositToKalixa:(NSString *)methodId amount:(int)amount {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.playwin.me/api/payments/kalixa/deposit?paymentMethodId=%@&amount=%i", methodId, amount]]];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:self.accessToken forHTTPHeaderField:@"Authorization"];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    //Possible responses:
    
    /*
     307 Redirects to the Kalixa payment page 
     400 Could not initialize transaction
     401 Unauthorized based on user's location 
     500 Internal server error
     */
}

/*
 
 Kalixa Withraw
 
 Endpoint for initializing a Kalixa deposit transaction. This endpoint redirects to the Kalixa payment page. Before creating a transaction, two verifications that are performed. The first verifies that the user's available account balance is large enough to allow the requested withdraw amount. The second verification is a geolocation check. Based on the requested payment method, the system verifies that the payment method is allowed from where the user is currently located.
 This endpoint is protected and requires an Authorization header with an access token. See the section 2 of this document for information on how to retrieve an access token.
 
 Parameters:
 
 methodId options:
 1 ECMC Deposit (Mastercard)
 2 VISA Deposit
 12 VISA Withdrawal
 38 Mastercard Withdrawal
 4 NETeller Deposit
 5 NETeller Withdrawal
 
 amount Transaction amount
 
 */

- (void)withrawFromKalixa:(NSString *)methodId amount:(int)amount {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.playwin.me/api/payments/kalixa/withraw?paymentMethodId=%@&amount=%i", methodId, amount]]];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:self.accessToken forHTTPHeaderField:@"Authorization"];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    //Possible responses:
    
    /*
     307 Redirects to the Kalixa payment page 
     400 Could not initialize transaction
     401 Unauthorized based on user's location 
     500 Internal server error
     */
}

#pragma mark - Paypal

/*
 
 Paypal deposit
 
 Endpoint for initializing a Paypal deposit. This endpoint redirects to the Paypal payment page. Before creating a transaction, a geolocation check performed. The system verifies that a Paypal deposit is allowed from where the user is currently located.
 See https://developer.paypal.com/docs/integration/web/accept-paypal-payment/ for more information on the payment flow.
 This endpoint is protected and requires an Authorization header with an access token. See the section 2 of this document for information on how to retrieve an access token.
 
 Parameters:
 
 amount Transaction amount
 
 */

- (void)depositToPaypal:(int)amount {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.playwin.me/api/payments/paypal/deposit?&amount=%i", amount]]];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:self.accessToken forHTTPHeaderField:@"Authorization"];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    //Possible responses:
    
    /*
     307 Redirects to Paypal payment page 
     400 Could not initialize payment
     401 Unauthorized based on user's location 
     500 Internal server error
     */
}

/*
 
 Paypal Withraw
 
 Endpoint for initializing a Paypal withdraw. This endpoint redirects to the Paypal payment page. Before creating a transaction, two verifications that are performed. The first verifies that the user's available account balance is large enough to allow the requested withdraw amount. The second
 ©2016, PlayWin • ALL RIGHTS RESERVED.
 4 Payments
 10
 verification is a geolocation check. The system verifies that a Paypal withdraw is allowed from where the user is currently located.
 See https://developer.paypal.com/docs/integration/web/accept-paypal-payment/ for more information on the payment flow.
 This endpoint is protected and requires an Authorization header with an access token. See the section 2 of this document for information on how to retrieve an access token.
 
 Parameters:
 
 amount Amount to deposit 
 email User's Paypal email
 
 */

- (void)withrawFromPaypal:(int)amount email:(NSString *)email {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.playwin.me/api/payments/paypal/withraw?&amount=%i&email=%@", amount, email]]];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:self.accessToken forHTTPHeaderField:@"Authorization"];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    //Possible responses:
    
    /*
     307 Redirects to Paypal payment page 
     400 Could not initialize payment
     401 Unauthorized based on user's location 
     500 Internal server error

     */
}

#pragma mark - Cubits


/*
 Cubits Deposit
 
 Endpoint for initializing a Cubits deposit (invoice). This endpoint redirects to the Cubits payment page. Before creating a transaction, a geolocation check performed. The system verifies that a Cubits deposit is allowed from where the user is currently located.
 This endpoint is protected and requires an Authorization header with an access token. See the section 2 of this document for information on how to retrieve an access token.
 
 Parameters:
 
 amount Amount to deposit
 
 */

- (void)depositToCubits:(int)amount {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.playwin.me/api/payments/cubits/deposit?&amount=%i", amount]]];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:self.accessToken forHTTPHeaderField:@"Authorization"];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    //Possible responses:
    
    /*
     307 Redirects to Cubits payment page 
     400 Could not initialize payment
     401 Unauthorized based on user's location 
     500 Internal server error
     */
}

/*
 
 Cubits Withraw
 
 Endpoint for initializing a Cubits withdraw This endpoint redirects to the Cubits payment page. Before creating a transaction, two verifications that are performed. The first verifies that the user's available account balance is large enough to allow the requested withdraw amount. The second verification is a geolocation check. The system verifies that a Cubits withdraw is allowed from where the user is currently located.
 This endpoint is protected and requires an Authorization header with an access token. See the section 2 of this document for information on how to retrieve an access token.
 
 Parameters:
 
 amount Amount to deposit
 address Bitcoin address
 
 */

- (void)withrawFromCubits:(int)amount email:(NSString *)email {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.playwin.me/api/payments/cubits/withraw?&amount=%i&address=%@", amount, email]]];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:self.accessToken forHTTPHeaderField:@"Authorization"];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    //Possible responses:
    
    /*
     307 Redirects to Cubits payment page 
     400 Could not initialize payment
     401 Unauthorized based on user's location 
     500 Internal server error
     */
}


+ (instancetype)sharedInstance
{
    static dispatch_once_t pred = 0;
    static PlaywinConnection *_sharedInstance = nil;
    
    dispatch_once( &pred, ^{
        _sharedInstance = [[super alloc] init];
    });
    return _sharedInstance;
}

@end
