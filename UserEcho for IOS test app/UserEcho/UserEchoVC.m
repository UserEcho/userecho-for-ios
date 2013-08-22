//
//  UserEchoVC.m
//  UserEcho for IOS test app
//
//  Created by Sergey Stukov on 7/9/13.
//  Copyright (c) 2013 UserEcho. All rights reserved.
//

#import "UserEchoVC.h"
#import "TopicVC.h"
#import "API.h"
#import "UICKeyChainStore.h"
#import "UEData.h"
#import "FPPopoverController.h"
#import "UserMenuVC.h"
#import "VoterTVC.h"
#import "UECommon.h"

#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"

#import "GTMOAuth2SignIn.h"
#import "GTMOAuth2ViewControllerTouch.h"

#import "NSString+FontAwesome.h"
#import "UETopicListCell.h"

@interface UserEchoVC ()

@end

@implementation UserEchoVC


@synthesize topicHeader;


NSArray *topicsStream;
FPPopoverController *popover;
UIActivityIndicatorView *indicator;

- (void)backToMainApp {
    [self.sidePanelController showLeftPanelAnimated:YES];
    
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signIn {
    //SignInCode
    NSLog(@"SignIn pushed");
    //oauth2* oauth2 = [super init];
    
    //id ue_signin = [[UeOauth2VC alloc] init];
    [self signInToCustomService];
    NSLog(@"SignIn end");
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)loadUser {
    [self getCurrentUser:^{
        
        
        
        [UECommon loadAvatar:[[UEData getInstance].user objectForKey:@"avatar_url"]
                onCompletion:^(UIImage *image) {
                    //[btnUser setImage: image];
                    
                    
                    
                    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
                    [button setImage:image forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(userClicked) forControlEvents:UIControlEventTouchUpInside];
                    [button setFrame:CGRectMake(0, 0, 32, 32)];
                    button.layer.cornerRadius=5;
  //                  yourButton.layer.cornerRadius = 10; // this value vary as per your desire
                    button.clipsToBounds = YES;
                    
                    
                    [btnUser initWithCustomView:button];
                    //btnUser.layer.cornerRadius = 2;
                    
                    
                }];
    }];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:btnUser, btnNewTopic,btnSearch, nil];
}

-(void)msgResponder:(NSNotification *)notification {
    NSLog(@"name:%@ object:%@", notification.name, notification.object);
    
    if([notification.object isEqual: @"Refresh"])
    {
        [self refreshStream];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"--------Loading---------");
    
    
    // method listen to meesssage with specfic name and calls selector when it get hit
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(msgResponder:) name:@"centerPanel" object:nil];
    
    
    //Hide search
    sbSearchHeight.constant=0;
    sbSearch.hidden=YES;
    
	
    
    // Do any additional setup after loading the view.
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"glyphicons_124_message_plus.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnNewTopic) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 32, 36)];

    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 4, 0);
    [btnNewTopic initWithCustomView:button];
    
    button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"glyphicons_158_show_lines.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backToMainApp) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 32, 32)];
    [btnBack initWithCustomView:button];
    
    button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"glyphicons_386_log_in.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(signInToCustomService) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 32, 32)];
    [btnSignIn initWithCustomView:button];
    
    
    button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"glyphicons_027_search.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(searchClicked) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 32, 32)];
    [btnSearch initWithCustomView:button];
    
    sbSearch.placeholder = NSLocalizedStringFromTable(@"Search2 for an ideas",@"UserEcho",nil);
    
    [sbSearch setPlaceholder:NSLocalizedStringFromTable(@"Search for an ideas",@"UserEcho",nil)];
    
    
    
    //self.navigationItem.title = @"UserEcho";
    self.navigationItem.leftBarButtonItem = btnBack;
    
    
    //Activity indicator
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    
    
    [indicator startAnimating];
    
    
    //Restore authorization
    [self restoreAuth];
    
    if([UEData getInstance].isAuthorised==[NSNumber numberWithInt:1]){
        [self loadUser];
    }
        else
        {
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:btnSignIn, btnNewTopic, btnSearch,nil];

        }
    
    //Get default forum if forum not set
    if(![UEData getInstance].forum) {
            [self getDefaultForum:^{
            NSLog(@"Def forum received");
            [self refreshStream];
        }];
    }
    
    
}


- (void) getCurrentUser:(void (^)(void))completionBlock{
 
    [[API sharedInstance] get:@"users/current"
                 onCompletion:^(NSArray *json) {
                     //Convert to dict
                     NSLog(@"Auth reply received");
                     NSDictionary *reply=(NSDictionary*)json;

                     if([[reply objectForKey:@"status"] isEqual: @"success"])
                        {
                        NSLog(@"Auth OK");
                        [UEData getInstance].user=[reply objectForKey:@"user"];
                        completionBlock();
                        }
                     else
                     {
                         NSLog(@"Auth NONE");
                         [self logOut];
                     }
                     
                     
                 }];
    
}


- (void) getDefaultForum:(void (^)(void))completionBlock{
    [[API sharedInstance] get:@"forums"
                 onCompletion:^(NSArray *json) {
                     //got stream
                     //NSLog(@"Stream received");
                     //NSLog(@"Forums=%@", json);
                     
                     [UEData getInstance].forums=[(NSDictionary*)json objectForKey:@"forums"];
                     
                     NSPredicate *p = [NSPredicate predicateWithFormat:@"default = %u", 1];
                     NSArray *matchedDicts = [[UEData getInstance].forums filteredArrayUsingPredicate:p];
                     
                     NSString *forum_id=[[matchedDicts objectAtIndex:0] objectForKey:@"id"];
                     [UEData getInstance].forum=forum_id;
                     [UEData getInstance].forum_allow_anonymous_feedback=[[matchedDicts objectAtIndex:0] objectForKey:@"allow_anonymous_feedback"];
                     //NSLog(@"%@", forum_id);
                     completionBlock();
                 }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Get stream of topics
-(void)refreshStream {
    [indicator startAnimating];
    //NSLog(@"Topic load item=%@",self.topicId);
    //just call the "stream" command from the web API
    [[API sharedInstance] get:[NSString stringWithFormat:@"forums/%@/feedback",[UEData getInstance].forum]
                                   onCompletion:^(NSArray *json) {
                                   [indicator stopAnimating];
                                   //got stream
                                   NSLog(@"Stream received");
                                   NSLog(@"%@", json);

                                   topicsStream = json;// allValues];//[json objectForKey:@"result"];
                                   NSLog(@"Loaded:%u",[topicsStream count]);
                                   NSLog(@"To table reload");
                                   [topicsTable reloadData];
                                   
                               }];
}



//static NSString *CellIdentifier = @"CellIdentifier";

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 3;
    NSLog(@"TSC=%u", [topicsStream count]);
    return [topicsStream count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"----");
    NSLog(@"IP=%@", indexPath);
    
    static NSString *simpleTableIdentifier = @"TopicCell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    UETopicListCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    //NSLog(@"Cell=%@", cell);
    
    //cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    
    NSDictionary* topic = [topicsStream objectAtIndex:indexPath.row];
   //NSLog(@"Topic=%@", topic);
    
    // Configure Cells
    
    NSLog(@"STATUS=%@",[topic objectForKey:@"status"]);

    //Status
    UIView *status = (UIView*)[cell.contentView viewWithTag:200];
    status.layer.cornerRadius = 2;
    status.layer.masksToBounds = YES;
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:21];
    
    if([[[topic objectForKey:@"status"] objectForKey:@"id"] intValue]>1)
        {
            cell.statusMarginLeft.constant=8;
            cell.statusMarginRight.constant=8;

            [label setText:[[[topic objectForKey:@"status"] objectForKey:@"name"] uppercaseString]];

            //Set color
            UIColor* color = [UECommon colorWithHexString:[NSString stringWithFormat:@"%@",[[topic objectForKey:@"status"] objectForKey:@"color"]]];
            [status setBackgroundColor:color];
        }
    else
    {
        [label setText:@""];
        cell.statusMarginLeft.constant=0;
        cell.statusMarginRight.constant=0;
        
    }
    
    
    //Topic header
    label = (UILabel *)[cell.contentView viewWithTag:10];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    label.textColor = [UECommon colorWithHexString:@"333333"];
    [label setText:[topic objectForKey:@"header"]];
    
    UILabel* author = (UILabel *)[cell.contentView viewWithTag:151];
    author.text = [[topic objectForKey:@"author"] objectForKey:@"name"];
    
    UILabel* date = (UILabel *)[cell.contentView viewWithTag:152];
    date.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
    date.textColor = [UECommon colorWithHexString:@"808080"];
    date.text = [NSString stringWithFormat:@" - %@",[UECommon ueDate:[topic objectForKey:@"updated"]]];
    
    if([(NSNumber*)[topic objectForKey:@"comment_count"] intValue]>0)
        date.text = [NSString stringWithFormat:@"%@ - ",date.text];
    
    if([(NSNumber*)[topic objectForKey:@"comment_count"] intValue]>0)
    {
    UILabel* ico = cell.detailsCommentsIcon;
    ico.font = [UIFont fontWithName:kFontAwesomeFamilyName size:11];
    ico.textColor = [UECommon colorWithHexString:@"808080"];
    ico.text = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-comment"];
    
    UILabel* comments = cell.detailsCommentsCount;
    comments.font = [UIFont fontWithName:@"Helvetica" size:11];
    comments.textColor = [UECommon colorWithHexString:@"808080"];
    comments.text = [(NSNumber*)[topic objectForKey:@"comment_count"] stringValue];
    }
    else
    {
    cell.detailsCommentsIcon.hidden=YES;
    cell.detailsCommentsCount.hidden=YES;
    }
    
    
    
    label = (UILabel *)[cell.contentView viewWithTag:12];
    [label setText:[NSString stringWithFormat:@"%@",[topic objectForKey:@"vote_count"]]];
    
    UIButton *button = (UIButton* )[cell.contentView viewWithTag:13];
    
    [button addTarget: self action: @selector(Vote:withEvent:)
             forControlEvents: UIControlEventTouchUpInside];
    
    
    UIImageView *voterBackground = (UIImageView *)[cell.contentView viewWithTag:20];
    voterBackground.layer.cornerRadius = 5.0;
    voterBackground.layer.masksToBounds = YES;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* topic = [topicsStream objectAtIndex:indexPath.row];
    
    CGSize status_size = [[[[topic objectForKey:@"status"] objectForKey:@"name"] uppercaseString] sizeWithFont:[UIFont systemFontOfSize:10]];
    
    if([[[topic objectForKey:@"status"] objectForKey:@"id"] intValue]<2)
    {
        status_size.width=0;
    }
    
    
    //60 - Header origin x
    //18 - Status padding + margin
    //320 - screen width
    
    CGSize size = [[topic objectForKey:@"header"] sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:12] constrainedToSize:CGSizeMake(topicsTable.frame.size.width-60-status_size.width-16-16, 480.0) lineBreakMode:NSLineBreakByWordWrapping];
    
    if(size.height+30<53)
        return 53;
    
    return size.height+30;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"IP=%@",indexPath);
    //NSLog(@"%@",[topicsStream objectAtIndex:[indexPath row]]);
    NSDictionary* topic = [topicsStream objectAtIndex:indexPath.row];
    NSNumber* id=[topic objectForKey:@"id"];
    NSLog(@"ID=%@",id);
    [self performSegueWithIdentifier:@"ShowTopic" sender:id];
}

//Pass topicID
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"PREP SEG");
    if ([@"ShowTopic" compare: segue.identifier]==NSOrderedSame) {
        TopicVC* TopicVC = segue.destinationViewController;
        TopicVC.topicId = sender;
    }
}

static NSString *const kKeychainItemName = @"UserEcho: auth";

- (GTMOAuth2Authentication *)authForCustomService {
    
    //NSURL *tokenURL = [NSURL URLWithString:@"https://api.example.com/oauth/token"];
    NSURL *tokenURL = [NSURL URLWithString:@"https://userecho.com/oauth2/access_token/"];
    
    // We'll make up an arbitrary redirectURI.  The controller will watch for
    // the server to redirect the web view to this URI, but this URI will not be
    // loaded, so it need not be for any actual web page.
    NSString *redirectURI = @"https://userecho.com/OAuthCallback";
    
    GTMOAuth2Authentication *auth;
    auth = [GTMOAuth2Authentication authenticationWithServiceProvider:@"Custom Service"
                                                             tokenURL:tokenURL
                                                          redirectURI:redirectURI
                                                             clientID:[UEData getInstance].key
                                                         clientSecret:[UEData getInstance].secret];
    return auth;
}

- (void)signInToCustomService {
    NSLog(@"SignIn called");
    //[self signOut];
    
    GTMOAuth2Authentication *auth = [self authForCustomService];
    
    // Specify the appropriate scope string, if any, according to the service's API documentation
    auth.scope = @"read write";
    
    NSURL *authURL = [NSURL URLWithString:@"https://userecho.com/oauth2/authorize/"];
    
    // Display the authentication view
    GTMOAuth2ViewControllerTouch *viewController;
    viewController = [[GTMOAuth2ViewControllerTouch alloc] initWithAuthentication:auth
                                                                  authorizationURL:authURL
                                                                  keychainItemName:kKeychainItemName
                                                                          delegate:self
                                                                  finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    
    // Now push our sign-in view
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)viewController:(GTMOAuth2ViewControllerTouch * )viewController
      finishedWithAuth:(GTMOAuth2Authentication * )auth
                 error:(NSError * )error
{
    [self.navigationController popToViewController:self animated:NO];
    if (error != nil) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error Authorizing with UserEcho"
                                                         message:[error localizedDescription]
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alert show];
    } else {
        //Authorization was successful
        //NSLog(@"Auth=%@",auth);
        
        //Save token to keychain for later use
        [UICKeyChainStore setString:[auth accessToken] forKey:@"access_token"];
        
        //Store to global var
        [UEData getInstance].access_token= [auth accessToken];
        
        //Set auth flag
        [UEData getInstance].isAuthorised = [NSNumber numberWithInt:1];
        [self loadUser];
        
        [self getDefaultForum:^{
            NSLog(@"Def forum received");
            [self refreshStream];
        }];
    }
}


//Search

-(void)searchStream:(NSString*)query {
    //NSLog(@"Query=%@",query);
    //just call the "stream" command from the web API
    
    NSString* strURL = [NSString stringWithFormat:@"forums/%@/feedback/search",[UEData getInstance].forum];
    //NSLog(@"Query+URL=%@",strURL);
    //NSString* encodedURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [[API sharedInstance] get:strURL
                       params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               query,@"query",
                               nil]
                 onCompletion:^(NSArray *json) {
                     //got stream
                     NSLog(@"Stream received");
                     //NSLog(@"%@", json);
                     
                     topicsStream = json;// allValues];//[json objectForKey:@"result"];
                     NSLog(@"Loaded:%u",[topicsStream count]);
                     NSLog(@"To table reload");
                     [topicsTable reloadData];
                 }];
}






-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"SB Search clicked");
    [self searchStream:searchBar.text];
    [searchBar setShowsCancelButton:NO animated:YES];
    [self.view endEditing:YES];
}


-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"SB Cancel clicked");
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    
    searchBar.hidden=YES;
    sbSearchHeight.constant=0;
    
    /*
    CGRect frame=topicsTable.frame;
    NSLog(@"TOpics table frame=%f",frame.origin.y);
    frame.origin.y=1;
    //frame.origin.x=20;
    frame.size.height=frame.size.height+44;
    topicsTable.frame=frame;
    */
    
    [self refreshStream];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	[searchBar becomeFirstResponder];
	[searchBar setShowsCancelButton:YES animated:YES];
    
}

//Restore Auth
- (void)restoreAuth {
    // Get the saved authentication, if any, from the keychain.
    NSString *access_token=[UICKeyChainStore stringForKey:@"access_token"];
    //If exists store to global var
    if(access_token)
        {
        [UEData getInstance].access_token = access_token;
        [UEData getInstance].isAuthorised = [NSNumber numberWithInt:1];
        //NSLog(@"Restored Token=%@",access_token);
        }
  
}

- (IBAction)searchClicked{
    //NSLog(@"Search button clicked");
    sbSearchHeight.constant=44;
    sbSearch.hidden=NO;
  
  /*
    CGRect frame=topicsTable.frame;
    frame.origin.x=10;
    frame.origin.y=44;
    frame.size.height=frame.size.height-44;
    topicsTable.frame=frame;*/
//  [topicsTable setFrame:CGRectMake(0, 0, 320, 188)];
}


//UserMenu
- (IBAction)userClicked{
    //the view controller you want to present as popover
    UserMenuVC *controller = [[UIStoryboard storyboardWithName:@"UserEcho" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"UserMenu"];
    controller.delegate = self;
    
    //our popover
    popover = [[FPPopoverController alloc] initWithViewController:controller];
    popover.contentSize = CGSizeMake(120,83);
    
    //the popover will be presented from the okButton view
    UIView* btnView = [btnUser valueForKey:@"view"];
    //On these cases is better to specify the arrow direction
    [popover setArrowDirection:FPPopoverArrowDirectionUp];
    [popover presentPopoverFromView:btnView];
   
}

//LogOut
- (void)logOut{
    NSLog(@"Logout");
    [UICKeyChainStore removeAllItems];
    [UEData getInstance].isAuthorised=[NSNumber numberWithInt:0];
    [UEData getInstance].access_token=[UEData getInstance].app_access_token;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:btnSignIn, btnNewTopic, nil];
    [popover dismissPopoverAnimated:YES];
}

//Vote
- (void)Vote: (id) sender withEvent: (UIEvent *) event{
    
    NSLog(@"Vote");
    UITouch * touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView: topicsTable];
    NSIndexPath * indexPath = [topicsTable indexPathForRowAtPoint: location];
    NSLog(@"Index=%@",indexPath);
    
    //UITableViewCell *cell = (UITableViewCell *)[(UIView *)sender superview];
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    //Present vote popover
    VoterTVC *controller = [[UIStoryboard storyboardWithName:@"UserEcho" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"VoterMenu"];
    controller.delegate = self;
    
    NSDictionary* topic = [topicsStream objectAtIndex:indexPath.row];
    NSNumber* id=[topic objectForKey:@"id"];
    
    controller.topicId = id;
    
    //our popover
    popover = [[FPPopoverController alloc] initWithViewController:controller];
    popover.contentSize = CGSizeMake(180,120);
    
    controller.popover = popover;
    
    UITableViewCell *cell = [topicsTable cellForRowAtIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:12];
    controller.placeholder = label;
    
    //the popover will be presented from the okButton view
    //UIView* btnView = [sender valueForKey:@"view"];
    //On these cases is better to specify the arrow direction
    [popover setArrowDirection:FPPopoverArrowDirectionLeft];
    [popover presentPopoverFromView:sender];
    
    
}

-(IBAction)btnNewTopic {
    NSLog(@"AF=%@",[UEData getInstance].forum_allow_anonymous_feedback);
    
    NSNumber* permission=[UEData getInstance].forum_allow_anonymous_feedback;
    
    if([permission isEqualToNumber:[NSNumber numberWithInt:1]])
        {
            NSLog(@"xxx");
        }
    else
    {
          NSLog(@"restricted");
    }
    
    if(([UEData getInstance].isAuthorised==[NSNumber numberWithInt:1] || [permission isEqualToNumber:[NSNumber numberWithInt:1]])){

        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TopicEditVC"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Authorisation required",nil)
                                                        message:NSLocalizedString(@"Sign in first to leave feedback.",nil)
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    
}

@end
