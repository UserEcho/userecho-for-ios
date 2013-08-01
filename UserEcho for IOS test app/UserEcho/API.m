//
//  API.m
//  UserEcho for IOS test app
//
//  Created by Sergey Stukov on 7/11/13.
//  Copyright (c) 2013 UserEcho. All rights reserved.
//

#import "API.h"
#import "UEData.h"

//the web location of the service
#define UEAPIHost @"https://userecho.com"
#define UEAPIPath @"api/"
//#define UEToken @"60a7a52377471538d0c87d84fe5c6a21677dcaf3"

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

-(void)get:(NSString*)command params:(NSMutableDictionary*)params onCompletion:(JSONResponseBlock)completionBlock
{
    //NSLog(@"Params=%@",params);
    NSMutableArray* parametersArray = [[NSMutableArray alloc] init];
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        //NSLog(@"Key=%@ Obj=%@",key,obj);
        [parametersArray addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
    }];
    
    NSString* parameterString = [parametersArray componentsJoinedByString:@"&"];
    NSString* encodedParams = [parameterString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //[self get:command onCompletion:completionBlock];
    
    NSString* token=[UEData getInstance].access_token;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@%@.json?%@",UEAPIHost, UEAPIPath, command,encodedParams ]];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request addValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
    
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

//GET method
-(void)get:(NSString*)command onCompletion:(JSONResponseBlock)completionBlock
{
    NSString* token=[UEData getInstance].access_token;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@%@.json",UEAPIHost, UEAPIPath, command ]];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request addValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
    
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

-(void)post:(NSString*)command params:(NSMutableDictionary*)params onCompletion:(JSONResponseBlock)completionBlock
{
    NSString* token=[UEData getInstance].access_token;
    //if(!token) token=UEToken;
    
    NSString* path = [NSString stringWithFormat:@"%@/%@%@.json",UEAPIHost, UEAPIPath, command ];
    
    NSString *jsonString=nil;
    NSData *jsonArray=nil;
    
    if([NSJSONSerialization isValidJSONObject:params])
    {
      jsonArray = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
      jsonString = [[NSString alloc]initWithData:jsonArray encoding:NSUTF8StringEncoding];
    }
    
    
    NSMutableURLRequest *request =
    [self multipartFormRequestWithMethod:@"POST"
                                    path:path
                              parameters:params
               constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                   //TODO: attach file if needed
               }];
    
    [request setHTTPBody: jsonArray];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
    
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //success!
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //failure :(
        NSLog(@"OP=%@",operation.responseString);
        completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    
    [operation start];
}

@end
