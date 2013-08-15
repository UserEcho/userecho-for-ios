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

+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+(NSString*)ueDate:(NSString*)date
{
    NSDateFormatter *parser = [[NSDateFormatter alloc] init];
    [parser setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSDate *date_str=[parser dateFromString:date];
    
//    NSLog(@"DATE=%@",date_str);
    
    NSDateFormatter * formatter = [[NSDateFormatter  alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDoesRelativeDateFormatting:YES];
    
    return [formatter stringFromDate:date_str];
}


@end
