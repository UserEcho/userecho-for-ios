//
//  UILabelUE.m
//  UserEcho for IOS test app
//
//  Created by Sergey Stukov on 8/21/13.
//  Copyright (c) 2013 UserEcho. All rights reserved.
//

#import "UILabelUE.h"

@implementation UILabelUE

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) layoutSubviews {
    [super layoutSubviews];
    self.preferredMaxLayoutWidth = self.bounds.size.width;
}

@end
