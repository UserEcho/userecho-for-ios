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
    NSString *forum;
    NSDictionary *user;
    }

@property(nonatomic,retain)NSString *access_token;
@property(nonatomic,retain)NSString *forum;
@property(nonatomic,retain)NSDictionary *user;

+(UEData*)getInstance;

@end