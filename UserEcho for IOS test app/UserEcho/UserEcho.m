//
//  UserEcho.m
//  UserEcho for IOS test app
//
//  Created by Sergey Stukov on 7/31/13.
//  Copyright (c) 2013 UserEcho. All rights reserved.
//

#import "UserEcho.h"
#import "UEData.h"

@implementation UserEcho

+(void)presentUserEchoCommunity:(UIViewController *)parentViewController config:(NSMutableDictionary *)config{
    
    //Configure token
    [UEData getInstance].key=[config valueForKey:@"key"];
    [UEData getInstance].secret=[config valueForKey:@"secret"];
    [UEData getInstance].app_access_token=[config valueForKey:@"access_token"];
    [UEData getInstance].access_token=[config valueForKey:@"access_token"];
    NSLog(@"Token=%@",[UEData getInstance].access_token);
    
    UIStoryboard *userechoStoryboard = [UIStoryboard storyboardWithName:@"UserEcho" bundle:nil];
    UIViewController *initialUserechoVC = [userechoStoryboard instantiateInitialViewController];
    initialUserechoVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [parentViewController presentViewController:initialUserechoVC animated:YES completion:Nil];
}

+(NSString *)version {
    return @"1.0.1";
}

@end
