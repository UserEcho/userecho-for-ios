//
//  UESidePanelController.m
//  UserEcho for IOS test app
//
//  Created by Sergey Stukov on 8/16/13.
//  Copyright (c) 2013 UserEcho. All rights reserved.
//

#import "UESidePanelController.h"

@interface UESidePanelController ()

@end

@implementation UESidePanelController

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

-(void) awakeFromNib
{
    [self setLeftPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"leftViewController"]];
    
    self.shouldResizeLeftPanel = YES;
    


    
    
    [self setCenterPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"centerViewController"]];
 //   [self setRightPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"]];
}

- (void)stylePanel:(UIView *)panel
{
    
}

@end
