//
//  UEData.h
//  UserEcho for IOS test app
//
//  Created by Sergey Stukov on 7/25/13.
//  Copyright (c) 2013 UserEcho. All rights reserved.
//

//#import <Foundation/Foundation.h>

@interface UEData : NSObject {
    NSString *access_token;
    NSString *app_access_token;
    NSString *forum;
    NSArray *forums;
    NSNumber *forum_allow_anonymous_feedback;
    NSDictionary *user;
    NSNumber *isAuthorised;
    
    
    NSString *key;
    NSString *secret;
    }

@property(nonatomic,retain)NSString *access_token;
@property(nonatomic,retain)NSString *app_access_token;
@property(nonatomic,retain)NSString *forum;
@property(nonatomic,retain)NSArray *forums;
@property(nonatomic,retain)NSNumber *forum_allow_anonymous_feedback;
@property(nonatomic,retain)NSDictionary *user;
@property(nonatomic,retain)NSNumber *isAuthorised;
@property(nonatomic,retain)NSString *key;
@property(nonatomic,retain)NSString *secret;

+(UEData*)getInstance;

@end