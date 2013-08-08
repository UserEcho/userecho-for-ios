//
//  TopicEditVC.h
//  UserEcho for IOS test app
//
//  Created by Sergey Stukov on 7/24/13.
//  Copyright (c) 2013 UserEcho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicEditVC : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    IBOutlet UITextField* topicHeader;
    IBOutlet UITextView* topicDescription;
    IBOutlet UITextField* topicType;
    IBOutlet UIButton* btnSaveTopic;
    
}

@end
