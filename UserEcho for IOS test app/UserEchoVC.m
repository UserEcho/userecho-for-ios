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
//#import "UeOauth2VC.h"

#import "GTMOAuth2SignIn.h"
#import "GTMOAuth2ViewControllerTouch.h"

@interface UserEchoVC ()

@end

@implementation UserEchoVC

NSArray *topicsStream;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.title = @"UserEcho";
    self.navigationItem.leftBarButtonItem = btnBack;
    
    self.navigationItem.rightBarButtonItem = btnSignIn;
    
    [self refreshStream];
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
    [[API sharedInstance] get:@"forums/1/feedback"
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
//    NSLog(@"TSC=%@", [topicsStream count]);
    
    static NSString *simpleTableIdentifier = @"TopicCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    //cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    
    NSDictionary* topic = [topicsStream objectAtIndex:indexPath.row];
    
    // Configure Cells
    
    //Topic header
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:10];
    //[label setText:@"XXX"];
    [label setText:[topic objectForKey:@"header"]];
    
    //label = (UILabel *)[cell.contentView viewWithTag:11];
    //[label setText:[topic objectForKey:@"comment"]];
    
    //label = (UILabel *)[cell.contentView viewWithTag:12];
    //[label setText:[topic objectForKey:@"date"]];
    
    
    //UIImageView *avatar = (UIImageView *)[cell.contentView viewWithTag:13];
    
    //avatar.image=[UIImage imageNamed:@"top_bar_background.png"];
    
    /*
    NSString* urlString = [NSString stringWithFormat:@"http://userecho.com%@",[topic objectForKey:@"authoravatar"]];
    NSURL* imageURL = [NSURL URLWithString:urlString];
    
    AFImageRequestOperation* imageOperation =
    [AFImageRequestOperation imageRequestOperationWithRequest: [NSURLRequest requestWithURL:imageURL]
                                                      success:^(UIImage *image) {
                                                          avatar.image=image;
                                                      }];
    
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    [queue addOperation:imageOperation];
    */
    
    //Load user avatar
    UIImageView *avatar = (UIImageView *)[cell.contentView viewWithTag:11];
    
    NSString* urlString = [NSString stringWithFormat:@"http://userecho.com%@",[[topic objectForKey:@"author"] objectForKey:@"avatar_url"]];
    NSURL* imageURL = [NSURL URLWithString:urlString];
    
    AFImageRequestOperation* imageOperation =
    [AFImageRequestOperation imageRequestOperationWithRequest: [NSURLRequest requestWithURL:imageURL]
                                                      success:^(UIImage *image) {
                                                          avatar.image=image;
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

NSString *kMyClientID = @"78049c2c768bf2e6f80d";     // pre-assigned by service
NSString *kMyClientSecret = @"7caa4c068663a2c4f4ea25757a7b886f14ec948c"; // pre-assigned by service
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
                                                             clientID:kMyClientID
                                                         clientSecret:kMyClientSecret];
    return auth;
}

- (void)signInToCustomService {
    NSLog(@"SignIn called");
    //[self signOut];
    
    GTMOAuth2Authentication *auth = [self authForCustomService];
    
    // Specify the appropriate scope string, if any, according to the service's API documentation
    auth.scope = @"read";
    
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
        //Authorization was successful - get location information
       // [self getLocationInfo:[auth accessToken]];
        NSLog(@"Token=%@",[auth accessToken]);
    }
}


//Search

-(void)searchStream:(NSString*)query {
    //NSLog(@"Topic load item=%@",self.topicId);
    //just call the "stream" command from the web API
    [[API sharedInstance] get:[NSString stringWithFormat:@"forums/1/feedback/search.json?query=%@",query]
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


@end
