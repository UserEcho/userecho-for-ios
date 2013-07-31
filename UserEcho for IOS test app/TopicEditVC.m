//
//  TopicEditVC.m
//  UserEcho for IOS test app
//
//  Created by Sergey Stukov on 7/24/13.
//  Copyright (c) 2013 UserEcho. All rights reserved.
//

#import "TopicEditVC.h"
#import "API.h"

@interface TopicEditVC ()

@end

@implementation TopicEditVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnSaveTopicTapped
{
    NSLog(@"Saving");
    
    [[API sharedInstance] post:[NSString stringWithFormat:@"forums/%u/feedback",  1]
     
     
     
                 params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               topicHeader.text,@"header",
                               @"1",@"feedback_type",
                               nil]

     
                 onCompletion:^(NSArray *json) {
                     //got stream
                     NSLog(@"Comments stream received");
                     NSLog(@"%@", json);
                    
                 }];


}

@end
