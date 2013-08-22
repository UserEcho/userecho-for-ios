//
//  UETopicListCell.h
//  UserEcho for IOS test app
//
//  Created by Sergey Stukov on 8/21/13.
//  Copyright (c) 2013 UserEcho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UETopicListCell : UITableViewCell
{
IBOutlet UILabel* topicHeader;
    
IBOutlet UILabel* detailsCommentsIcon;
IBOutlet UILabel* detailsCommentsCount;
    
IBOutlet NSLayoutConstraint* statusMarginLeft;
IBOutlet NSLayoutConstraint* statusMarginRight;
}

@property(nonatomic,retain)NSLayoutConstraint *statusMarginLeft;
@property(nonatomic,retain)NSLayoutConstraint *statusMarginRight;

@property(nonatomic,retain)UILabel* detailsCommentsIcon;
@property(nonatomic,retain)UILabel* detailsCommentsCount;

@end
