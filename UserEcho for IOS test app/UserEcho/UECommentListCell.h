//
//  UECommentListCell.h
//  UserEcho for IOS test app
//
//  Created by Sergey Stukov on 8/21/13.
//  Copyright (c) 2013 UserEcho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UECommentListCell : UITableViewCell
{
IBOutlet NSLayoutConstraint* commentHeight;
}

@property(nonatomic,retain)NSLayoutConstraint *commentHeight;

@end
