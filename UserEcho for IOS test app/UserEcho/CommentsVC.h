//
//  CommentsVC.h
//  UserEcho for IOS test app
//
//  Created by Sergey Stukov on 7/24/13.
//  Copyright (c) 2013 UserEcho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    IBOutlet UIScrollView* scrollView;
    IBOutlet UITableView* commentsTable;
    IBOutlet UITextField* message;
    IBOutlet UIButton* btnSend;
}

@property (strong, nonatomic) NSNumber* topicId;

@end
