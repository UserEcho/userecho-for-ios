//
//  VoterTVC.h
//  UserEcho for IOS test app
//
//  Created by Sergey Stukov on 7/26/13.
//  Copyright (c) 2013 UserEcho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserEchoVC.h"
#import "FPPopoverController.h"

@interface VoterTVC : UITableViewController

@property(nonatomic,assign) UserEchoVC *delegate;
@property(assign, nonatomic) NSNumber* topicId;
@property(assign, nonatomic) FPPopoverController *popover;

//@property(assign, nonatomic) UITableViewCell *cell;
@property(assign, nonatomic) UILabel *placeholder;


@end
