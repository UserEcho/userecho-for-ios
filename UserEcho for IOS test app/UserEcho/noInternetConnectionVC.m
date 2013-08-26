//
//  noInternetConnectionVC.m
//  UserEcho for IOS test app
//
//  Created by Sergey Stukov on 8/26/13.
//  Copyright (c) 2013 UserEcho. All rights reserved.
//

#import "noInternetConnectionVC.h"

@interface noInternetConnectionVC ()

@end

@implementation noInternetConnectionVC

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

-(IBAction) exit {
    
    //do your saving and such here
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
