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
    IBOutlet NSLayoutConstraint* topicDescriptionHeight;
    
    
    
    IBOutlet UIScrollView* topicScrollView;
    //IBOutlet UIButton* btnComments;
    IBOutlet UIBarButtonItem* btnComments;
    
    IBOutlet UIButton* btnVote;
    
    //Official answer
    IBOutlet UIView* replyPane;
    
    IBOutlet UIImageView* replyAvatar;
    IBOutlet UIWebView* replyDescription;
    IBOutlet NSLayoutConstraint* replyDescriptionHeight;

    IBOutlet UILabel* replyStatus;
    IBOutlet UIView* replyStatusBox;

    
    
}
    
@property (assign, nonatomic) NSNumber* topicId;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeightConstraint;

@end

