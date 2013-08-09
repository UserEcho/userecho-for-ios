//
//  UECommon.m
//  UserEcho for IOS test app
//
//  Created by Sergey Stukov on 8/9/13.
//  Copyright (c) 2013 UserEcho. All rights reserved.
//

#import "UECommon.h"
#import "API.h"

@implementation UECommon

+(void)loadAvatar:(NSString*)url onCompletion:(imageLoadResponse)completionBlock {

    //placeholder.image=nil;
    
    NSString* urlString = nil;
    
    
    if([url hasPrefix:@"http"])
    {
        urlString=url;
    }
    else
    {
        urlString = [NSString stringWithFormat:@"http://userecho.com%@",url];
    }
    
    NSURL* imageURL = [NSURL URLWithString:urlString];
    
    AFImageRequestOperation* imageOperation =
    [AFImageRequestOperation imageRequestOperationWithRequest: [NSURLRequest requestWithURL:imageURL]
                                                      success:^(UIImage *image) {
                                                          //NSLog(@"IP(LOAD)=%@", indexPath);
                                                          //UITableViewCell *cell2 = [tableView cellForRowAtIndexPath:indexPath];
                                                          //UIImageView *avatar2 = (UIImageView *)[cell2.contentView viewWithTag:11];
                                                          //avatar2.image=image;
                                                          //placeholder.image=image;
                                                          completionBlock(image);
                                                      }];
    
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    [queue addOperation:imageOperation];
    
}

@end
