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
                                                    @"cbda91c6fccd3a60870c",@"key",
                                                    @"a1e77ec52da31c52d4591ef5984a37785a320aa1",@"secret",
                                                    @"9705bb6a517d93d3c4caf114500b478a177fcfba",@"access_token",
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
