//
//  UserEchoVC.h
//  UserEcho for IOS test app
//
//  Created by Sergey Stukov on 7/9/13.
//  Copyright (c) 2013 UserEcho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserEchoVC : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
IBOutlet UITableView* topicsTable;
    
IBOutlet UIBarButtonItem* btnBack;
IBOutlet UIBarButtonItem* btnSignIn;
    
//IBOutlet UINavigationController* ueNavController;
}

-(IBAction)backToMainApp;
-(IBAction)signIn;
//-(void)signInToUserEchoService;

@end
