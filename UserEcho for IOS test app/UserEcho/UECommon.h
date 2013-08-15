//
//  UECommon.h
//  UserEcho for IOS test app
//
//  Created by Sergey Stukov on 8/9/13.
//  Copyright (c) 2013 UserEcho. All rights reserved.
//

//#import <Foundation/Foundation.h>

@interface UECommon : NSObject

// typedef for the callback type
typedef void (^imageLoadResponse)(UIImage *image);

+(void)loadAvatar:(NSString*)url onCompletion:(imageLoadResponse)completionBlock;
+(UIColor*)colorWithHexString:(NSString*)hex;
+(NSString*)ueDate:(NSString*)date;

@end
