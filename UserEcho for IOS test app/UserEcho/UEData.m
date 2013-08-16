//
//  UEData.m
//  UserEcho for IOS test app
//
//  Created by Sergey Stukov on 7/25/13.
//  Copyright (c) 2013 UserEcho. All rights reserved.
//

#import "UEData.h"

@implementation UEData

@synthesize access_token;
@synthesize app_access_token;
@synthesize forum;
@synthesize forums;
@synthesize forum_allow_anonymous_feedback;
@synthesize user;

@synthesize key;
@synthesize secret;
@synthesize isAuthorised;

static UEData *instance =nil;
+(UEData *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            
            instance= [UEData new];
        }
    }
    return instance;
}
@end

