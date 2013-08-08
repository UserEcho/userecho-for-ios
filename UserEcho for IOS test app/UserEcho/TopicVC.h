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
    
    IBOutlet UIImageView* authorAvatar;
    IBOutlet UIImageView* voterBackground;
    IBOutlet UILabel* rating;
    
    IBOutlet UIWebView* topicDescription;
    IBOutlet UIScrollView* topicScrollView;
    IBOutlet UIButton* btnComments;
    IBOutlet UIButton* btnVote;
}
    
@property (assign, nonatomic) NSNumber* topicId;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeightConstraint;

@end

