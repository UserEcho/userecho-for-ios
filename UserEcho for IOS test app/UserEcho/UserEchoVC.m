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

#import "GTMOAuth2SignIn.h"
#import "GTMOAuth2ViewControllerTouch.h"

@interface UserEchoVC ()

@end

@implementation UserEchoVC

NSArray *topicsStream;
FPPopoverController *popover;

- (void)backToMainApp {
    [self dismissViewControllerAnimated:YES completion:nil];
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
        
        
        //Load user avatar
        NSString* urlString = [NSString stringWithFormat:@"http://userecho.com%@",[[UEData getInstance].user objectForKey:@"avatar_url"]];
        
        NSURL* imageURL = [NSURL URLWithString:urlString];
        
        AFImageRequestOperation* imageOperation =
        [AFImageRequestOperation imageRequestOperationWithRequest: [NSURLRequest requestWithURL:imageURL]
                                                          success:^(UIImage *image) {
                                                              
                                                              [btnUser setImage: image];
                                                              
                                                          }];
        
        NSOperationQueue* queue = [[NSOperationQueue alloc] init];
        [queue addOperation:imageOperation];
        
    }];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:btnUser, btnNewTopic, nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    //Assign captions for buttons
    btnBack.title = NSLocalizedStringFromTable(@"Back",@"UserEcho",nil);
    btnNewTopic .title = NSLocalizedStringFromTable(@"New topic",@"UserEcho",nil);
    btnSignIn.title = NSLocalizedStringFromTable(@"Sign in",@"UserEcho",nil);
    
    sbSearch.placeholder = NSLocalizedStringFromTable(@"Search2 for an ideas",@"UserEcho",nil);
    
    [sbSearch setPlaceholder:NSLocalizedStringFromTable(@"Search for an ideas",@"UserEcho",nil)];
    
    
    
    self.navigationItem.title = @"UserEcho";
    self.navigationItem.leftBarButtonItem = btnBack;
    
    //Restore authorization
    [self restoreAuth];
    
    if([UEData getInstance].isAuthorised==[NSNumber numberWithInt:1]){
        [self loadUser];
    }
        else
        {
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:btnSignIn, btnNewTopic, nil];

        }
    
    //Get default forum if forum not set
    if(![UEData getInstance].forum) {
     //   [self getDefaultForum @"xxx" completion:^{
           // [self displayBalance];  // For example...
      //  }];
//        [self getDefaultForum:<#^(void)completionBlock#>]
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
                     NSLog(@"Stream received");
                     NSLog(@"%@", json);
                     
                     NSPredicate *p = [NSPredicate predicateWithFormat:@"default = %u", 1];
                     NSArray *matchedDicts = [json filteredArrayUsingPredicate:p];
                     
                     NSString *forum_id=[[matchedDicts objectAtIndex:0] objectForKey:@"id"];
                     [UEData getInstance].forum=forum_id;
                     [UEData getInstance].forum_allow_anonymous_feedback=[[matchedDicts objectAtIndex:0] objectForKey:@"allow_anonymous_feedback"];
                     NSLog(@"%@", forum_id);
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
    //NSLog(@"Topic load item=%@",self.topicId);
    //just call the "stream" command from the web API
    [[API sharedInstance] get:[NSString stringWithFormat:@"forums/%@/feedback",[UEData getInstance].forum]
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    //NSLog(@"Cell=%@", cell);
    
    //cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    
    NSDictionary* topic = [topicsStream objectAtIndex:indexPath.row];
   //NSLog(@"Topic=%@", topic);
    
    // Configure Cells
    
    //Topic header
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:10];
    [label setText:[topic objectForKey:@"header"]];
    
    //Status
    label = (UILabel *)[cell.contentView viewWithTag:21];
//    [label setAutoresizingMask: UIViewAutoresizingFlexibleLeftMargin];
    [label setText:[[topic objectForKey:@"status_name"] uppercaseString]];
    label.layer.cornerRadius = 5;
    label.layer.masksToBounds = YES;
    //label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [label sizeToFit];
    
    CGRect frame = label.frame;
    frame.origin.x = self.view.frame.size.width-label.frame.size.width-5;
    label.frame = frame;
    
    
    //label = (UILabel *)[cell.contentView viewWithTag:11];
    //[label setText:[topic objectForKey:@"comment"]];
    
    label = (UILabel *)[cell.contentView viewWithTag:12];
    [label setText:[NSString stringWithFormat:@"%@",[topic objectForKey:@"vote_count"]]];
    
    UIButton *button = (UIButton* )[cell.contentView viewWithTag:13];
    
    [button addTarget: self action: @selector(Vote:withEvent:)
             forControlEvents: UIControlEventTouchUpInside];
    
    
    UIImageView *voterBackground = (UIImageView *)[cell.contentView viewWithTag:20];
    voterBackground.layer.cornerRadius = 5.0;
    voterBackground.layer.masksToBounds = YES;
    
    //voterBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //voterBackground.layer.borderWidth = 3.0;
    
    //Load user avatar
    UIImageView *avatar = (UIImageView *)[cell.contentView viewWithTag:11];
    avatar.image=nil;
    
    NSString* urlString = nil;
    NSString* avatarURL=[[topic objectForKey:@"author"] objectForKey:@"avatar_url"];
    if([avatarURL hasPrefix:@"http"])
    {
        urlString=avatarURL;
    }
    else
        {
        urlString = [NSString stringWithFormat:@"http://userecho.com%@",avatarURL];
        }
        
    
    //NSString* urlString = [NSString stringWithFormat:@"http://userecho.com%@",[[topic objectForKey:@"author"] objectForKey:@"avatar_url"]];
    
    
    NSURL* imageURL = [NSURL URLWithString:urlString];
    
    AFImageRequestOperation* imageOperation =
    [AFImageRequestOperation imageRequestOperationWithRequest: [NSURLRequest requestWithURL:imageURL]
                                                      success:^(UIImage *image) {
                                                      //NSLog(@"IP(LOAD)=%@", indexPath);
                                                      UITableViewCell *cell2 = [tableView cellForRowAtIndexPath:indexPath];
                                                      UIImageView *avatar2 = (UIImageView *)[cell2.contentView viewWithTag:11];
                                                      avatar2.image=image;
                                                          
                                                      }];
    
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    [queue addOperation:imageOperation];

    
    return cell;
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
