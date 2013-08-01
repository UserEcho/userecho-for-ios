//
//  UserEcho.h
//  UserEcho for IOS test app
//
//  Created by Sergey Stukov on 7/31/13.
//  Copyright (c) 2013 UserEcho. All rights reserved.
//

//#import <Foundation/Foundation.h>

@interface UserEcho : NSObject

// Modally present the UserEcho community view
+ (void)presentUserEchoCommunity:(UIViewController *)parentViewController config:(NSMutableDictionary *)config;

// Get the current version number of the UserEcho iOS SDK
+ (NSString *)version;

@end
