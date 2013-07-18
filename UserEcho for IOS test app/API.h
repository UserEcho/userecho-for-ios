//
//  API.h
//  UserEcho for IOS test app
//
//  Created by Sergey Stukov on 7/11/13.
//  Copyright (c) 2013 UserEcho. All rights reserved.
//

#import "AFHTTPClient.h"
#import "AFNetworking.h"

@interface API : AFHTTPClient

//API call completion block with result as json
typedef void (^JSONResponseBlock)(NSArray* json);

+(API*)sharedInstance;

//send an API command to the server
-(void)get:(NSString*)command onCompletion:(JSONResponseBlock)completionBlock;
-(void)commandWithParams:(NSMutableDictionary*)params onCompletion:(JSONResponseBlock)completionBlock;

@end
