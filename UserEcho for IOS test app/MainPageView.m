//
//  MainPageView.m
//  UserEcho for IOS test app
//
//  Created by Sergey Stukov on 7/9/13.
//  Copyright (c) 2013 UserEcho. All rights reserved.
//

#import "MainPageView.h"
#import "UserEcho.h"

@interface MainPageView ()

@end

@implementation MainPageView

- (void)runUserEcho {

    [UserEcho presentUserEchoCommunity:self config:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                    @"d0322478cc300ffd1c97",@"key",
                                                    @"24c2e5135727019f8b3026966fdb3e548a8bbf9c",@"secret",
                                                    @"62775a3003433201796fc86b3cb1c98a160ae4c9",@"access_token",
                                                    nil]];
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
