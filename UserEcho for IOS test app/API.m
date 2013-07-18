//
//  API.m
//  UserEcho for IOS test app
//
//  Created by Sergey Stukov on 7/11/13.
//  Copyright (c) 2013 UserEcho. All rights reserved.
//

#import "API.h"

//the web location of the service
#define UEAPIHost @"https://userecho.com"
#define UEAPIPath @"api/"

#define UEToken @"60a7a52377471538d0c87d84fe5c6a21677dcaf3"

@implementation API

#pragma mark - Singleton methods
/**
 * Singleton methods
 */
+(API*)sharedInstance
{
    static API *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:UEAPIHost]];
    });
    
    return sharedInstance;
}

#pragma mark - init
//intialize the API class with the destination host name

-(API*)init
{
    //call super init
    self = [super init];
    
    if (self != nil) {
        //initialize the object
        //user = nil;
        
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        
        // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    
    return self;
}

//GET method
-(void)get:(NSString*)command onCompletion:(JSONResponseBlock)completionBlock
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@%@.json",UEAPIHost, UEAPIPath, command ]];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];

    [request addValue:[NSString stringWithFormat:@"Bearer %@", UEToken] forHTTPHeaderField:@"Authorization"];
    
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //success!
        //NSString *response = [operation responseString];
        //NSLog(@"RESP=%@", response);
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //failure :(
        NSLog(@"%@",error);
        completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    
    NSLog(@"API GET %@", url);
    
    [operation start];
}

-(void)commandWithParams:(NSMutableDictionary*)params onCompletion:(JSONResponseBlock)completionBlock
{
    NSMutableURLRequest *apiRequest =
    [self multipartFormRequestWithMethod:@"POST"
                                    path:UEAPIPath
                              parameters:params
               constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                   //TODO: attach file if needed
               }];
    
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: apiRequest];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //success!
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //failure :(
        completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error1"]);
    }];
    
    [operation start];
}

@end
