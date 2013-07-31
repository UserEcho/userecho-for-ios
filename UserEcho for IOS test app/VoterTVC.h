//
//  VoterTVC.h
//  UserEcho for IOS test app
//
//  Created by Sergey Stukov on 7/26/13.
//  Copyright (c) 2013 UserEcho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserEchoVC.h"

@interface VoterTVC : UITableViewController

@property(nonatomic,assign) UserEchoVC *delegate;

@end
