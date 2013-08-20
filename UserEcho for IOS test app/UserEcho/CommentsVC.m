//
//  CommentsVC.m
//  UserEcho for IOS test app
//
//  Created by Sergey Stukov on 7/24/13.
//  Copyright (c) 2013 UserEcho. All rights reserved.
//

#import "CommentsVC.h"
#import "API.h"
#import "UEData.h"
#import "UECommon.h"
#import <QuartzCore/QuartzCore.h>

@interface CommentsVC ()

@end

@implementation CommentsVC

NSArray *commentsStream;
NSMutableDictionary *messageHeightDictionary;

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
	
    self.navigationItem.title=@"Comments";
    
    // Do any additional setup after loading the view.
    [btnSend setTitle:NSLocalizedStringFromTable(@"Send",@"UserEcho",nil) forState:UIControlStateNormal];
    
    //CGRect frame=btnSend.frame;
    //[btnSend sizeToFit];
    
    //CGRect mframe=message.frame;
    //mframe.size.width=mframe.size.width+frame.size.width-btnSend.frame.size.width;
    //[message setFrame:mframe];

    //frame.origin.x=frame.origin.x+frame.size.width-btnSend.frame.size.width;
    //frame.size.width=btnSend.frame.size.width;

    //[btnSend setFrame:frame];
    
    
    
    
    [message setPlaceholder:NSLocalizedStringFromTable(@"Type your comment",@"UserEcho",nil)];
    
    [self registerForKeyboardNotifications];
    [self refreshStream];
    
    

    //NSLog(@"Token=%@",[UEData getInstance].access_token);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Get stream of messages
-(void)refreshStream {
    //NSLog(@"Topic load item=%@",self.topicId);
    //just call the "stream" command from the web API
    [[API sharedInstance] get:[NSString stringWithFormat:@"feedback/%@/comments", self.topicId]
     
                 onCompletion:^(NSArray *json) {
                     //got stream
                     NSLog(@"Comments stream received");
                     NSLog(@"%@", json);
                     
                     commentsStream = json;
                     NSLog(@"Loaded:%u",[commentsStream count]);
                     //NSLog(@"To table reload");
                     [commentsTable reloadData];
                     
                 }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [commentsStream count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Cell For Row called");
    
    static NSString *simpleTableIdentifier = @"CommentCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    NSDictionary* comment = [commentsStream objectAtIndex:indexPath.row];
    
    // Configure Cells
    UILabel *username = (UILabel *)[cell.contentView viewWithTag:10];
    
    [username setText:[[comment objectForKey:@"author"] objectForKey:@"name"]];
    username.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:13];
    //[username sizeToFit];
    
    
    // Configure Cells
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:20];
    //label.text=[NSString stringWithFormat:@"%@",[[comment objectForKey:@"author"] objectForKey:@"title"]];
    //[label sizeToFit];
    
    //CGRect frame = label.frame;
    //frame.origin.x=username.frame.origin.x+username.frame.size.width+5;
    //label.frame=frame;
    

    
    
    // Configure Cells
    label = (UILabel *)[cell.contentView viewWithTag:12];
    
    NSDateFormatter *parser = [[NSDateFormatter alloc] init];
    [parser setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSDate *date_str=[parser dateFromString:[comment objectForKey:@"submit_date"]];
    
    NSLog(@"DATE=%@",date_str);
    
    NSDateFormatter * formatter = [[NSDateFormatter  alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDoesRelativeDateFormatting:YES];
    
    label.text = [formatter stringFromDate:date_str];
    
    
    //Set comment
    UIWebView* view = (UIWebView *)[cell.contentView viewWithTag:11];
    
    NSString *pathToCSS = [[NSBundle mainBundle] pathForResource:@"UserEcho" ofType:@"css"];
    NSString *CSS = [NSString stringWithContentsOfFile:pathToCSS encoding:NSUTF8StringEncoding error:NULL];
    //NSLog(@"CSS=%@",CSS);
    NSString *html = [NSString stringWithFormat:@"<head>%@</head><body>%@</body>",CSS,[comment objectForKey:@"comment"]];
    
    [view loadHTMLString:html baseURL:[NSURL URLWithString:@"http://userecho.com"]];
    //[label setText:[comment objectForKey:@"comment"]];
    
    //Load user avatar
    [UECommon loadAvatar:[[comment objectForKey:@"author"] objectForKey:@"avatar_url"]
            onCompletion:^(UIImage *image) {
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                UIImageView *avatar = (UIImageView *)[cell.contentView viewWithTag:13];
               avatar.image=image;
                avatar.layer.cornerRadius=4.0;
            }];

    return cell;
}

-(IBAction)btnSendTapped
{
    NSLog(@"Send MSG %@",message.text);
    //NSLog(@"Topic load item=%@",self.topicId);
    [message resignFirstResponder];

    
    [[API sharedInstance] post:[NSString stringWithFormat:@"feedback/%@/comments",  self.topicId]
     
                        params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                message.text,@"comment",
                                nil]
     
     
                  onCompletion:^(NSArray *json) {
                      NSLog(@"Comment posted");
                      [self refreshStream];
                      
                  }];
    
    //Cleanup field
    message.text=nil;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    //   [add your method here];
    //NSLog(@"RET");
    return YES;
}

//Description auto-height
- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    
    aWebView.scrollView.scrollEnabled = NO;
  
    NSLog(@"WEB VIEW LOADED");
    
    //CGRect frame = aWebView.frame;
    //frame.size.height = 1;
    //aWebView.frame = frame;
    
    //CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
    //frame.size = fittingSize;
    //aWebView.frame = frame;
    
   // NSLog(@"TAG=%ld",(long)aWebView.tag);
    
    UITableViewCell *cell = (UITableViewCell *)[[aWebView superview] superview];
    NSLog(@"Cell=%@",cell);
    NSIndexPath *indexPath = [commentsTable indexPathForCell:cell];
    NSLog(@"IPF=%@",indexPath);
    
    //Fast scroll exception fix
    if(indexPath==nil)
        return;
    
    // Create a new dictionary if none exists.
    if (messageHeightDictionary == nil)
        messageHeightDictionary = [NSMutableDictionary new];
    
    // Store the height of the webview in the dictionary for this postId.
    
//    [messageHeightDictionary setObject:[NSString stringWithFormat:@"%f", aWebView.frame.size.height] forKey:indexPath];
    [messageHeightDictionary setObject:[NSString stringWithFormat:@"%f", aWebView.scrollView.contentSize.height] forKey:indexPath];
    
    //aWebView.scrollView.contentSize.height;
    
    
    [commentsTable beginUpdates];
    //[commentsTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [commentsTable endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"IP=%@",indexPath);
    
    NSString* height=[messageHeightDictionary objectForKey:indexPath];
    NSLog(@"Height=%@",height);
    if(height)
        {
            if([height floatValue]<21) height=@"21";
        return [height floatValue]+25;

        }
    else
    {
            return 46;
        
    }
}

//Keyboard
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    NSLog(@"KEYB Show KH=%f",kbSize.height);
    
    //Support for orientation
    BOOL isPortrait = UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
    CGFloat height = isPortrait ? kbSize.height : kbSize.width;
    NSLog(@"The keyboard height is: %f", height);
    
    bottomMargin.constant = height;
    
    //UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    //scrollView.contentInset = contentInsets;
    //scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    /*
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    NSLog(@"ORIGIN=%f",message.superview.frame.origin.y);
    if (!CGRectContainsPoint(aRect, message.superview.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, message.superview.frame.origin.y+60-kbSize.height);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
     */
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSLog(@"KEYB Hidden");
    bottomMargin.constant = 0;
    /*
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
     */
}



@end
