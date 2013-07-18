//
//  MainPageView.m
//  UserEcho for IOS test app
//
//  Created by Sergey Stukov on 7/9/13.
//  Copyright (c) 2013 UserEcho. All rights reserved.
//

#import "MainPageView.h"

@interface MainPageView ()

@end

@implementation MainPageView

- (void)runUserEcho {
    UIStoryboard *userechoStoryboard = [UIStoryboard storyboardWithName:@"UserEcho" bundle:nil];
    UIViewController *initialUserechoVC = [userechoStoryboard instantiateInitialViewController];
    initialUserechoVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:initialUserechoVC animated:YES];
    
}

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

@end
