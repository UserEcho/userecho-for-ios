//
//  TopicVC.h
//  UserEcho for IOS test app
//
//  Created by Sergey Stukov on 7/18/13.
//  Copyright (c) 2013 UserEcho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicVC : UIViewController
{
IBOutlet UILabel* topicHeader;
IBOutlet UIWebView* topicDescription;
}
    
@property (assign, nonatomic) NSNumber* topicId;

@end

