//
//  TopicVC.m
//  UserEcho for IOS test app
//
//  Created by Sergey Stukov on 7/18/13.
//  Copyright (c) 2013 UserEcho. All rights reserved.
//

#import "API.h"
#import "TopicVC.h"
#import "CommentsVC.h"
#import "FPPopoverController.h"
#import "VoterTVC.h"
#import "UECommon.h"

@interface TopicVC ()

@end

@implementation TopicVC

NSDictionary *topic;
FPPopoverController *popover;

NSString *topicDescriptionHTML;

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
    
    //[btnComments sizeToFit];
    
    [[UIDevice currentDevice]beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasOrientationChanged:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];

    
    
    btnComments.tag=[self.topicId intValue];
    NSLog(@"TID=%@",self.topicId);
    
    
    voterBackground.layer.cornerRadius = 5.0;
    voterBackground.layer.masksToBounds = YES;
    
    [self getTopic];
}


//Get topic
-(void)getTopic {
    //NSLog(@"Topic load item=%@",self.topicId);
    [[API sharedInstance] get:[NSString stringWithFormat:@"feedback/%@", self.topicId]
                 onCompletion:^(NSArray *json) {
                     //got stream
                     NSLog(@"Stream received");
                     topic = [json objectAtIndex:0];
                     NSLog(@"Topic:%@",topic);
                     
                     //Update placeholders on screen
                     topicHeader.text=[topic objectForKey:@"header"];
                     
                     
                     topicHeader.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
                     topicHeader.textColor = [UECommon colorWithHexString:@"333333"];
                     
                     //CGRect frame = topicHeader.frame;
                     //frame.size.width = status_x-frame.origin.x-5;
                     //label.frame = frame;
                     
                     //NSLog(@"POSIT=%d %f",status_x,frame.origin.x);
                     
                     
                     [btnComments setTitle:[NSString stringWithFormat:@"(%@) %@",[topic objectForKey:@"comment_count"],NSLocalizedStringFromTable(@"Comments",@"UserEcho",nil)]];
                     
                     
                     
                     [topicHeader setText:[topic objectForKey:@"header"]];
                     //topicHeader.lineBreakMode = NSLineBreakByWordWrapping;
                     //topicHeader.numberOfLines = 0;
                     //[topicHeader sizeToFit];
                     
                     //Resize topic top view
                     //int topview_height=topicHeader.frame.size.height+14;
                     //if(topview_height<50) topview_height=50;
                     
                     //UIView* topview=topicHeader.superview;
                     //CGRect frame = topview.frame;
                     //frame.size.height=topview_height;
                     //topview.frame=frame;

                     
                     NSLog(@"Rating:%@",[topic objectForKey:@"vote_diff"]);
                     rating.text=[NSString stringWithFormat:@"%@",[topic objectForKey:@"vote_diff"]];
                     
                     
                     /*
                     int uvote=[[topic objectForKey:@"cur_user_vote"] intValue];
                     switch (uvote) {
                         case -1:
                             voterBackground.backgroundColor=[UIColor redColor];
                             break;
                        
                         case 1:
                             voterBackground.backgroundColor=[UIColor greenColor];
                             break;
                             
                         default:
                             voterBackground.backgroundColor=[UIColor blueColor];
                             break;
                     }
                     */
                     
                     
                     
                     [btnVote addTarget: self action: @selector(Vote:withEvent:)
                      forControlEvents: UIControlEventTouchUpInside];
                     
                     
                     //pass the string to the webview
                     
                     //frame = topicDescription.frame;
                     //frame.origin.y=topview.frame.size.height+10;
                     //topicDescription.frame=frame;
                     
                     
                     
                     NSString *pathToCSS = [[NSBundle mainBundle] pathForResource:@"UserEcho" ofType:@"css"];
                     NSString *CSS = [NSString stringWithContentsOfFile:pathToCSS encoding:NSUTF8StringEncoding error:NULL];
                     //NSLog(@"CSS=%@",CSS);
                     
                     topicDescriptionHTML = [NSString stringWithFormat:@"<head>%@</head><body>%@</body>",CSS,[topic objectForKey:@"description"]];
                     
                     [topicDescription loadHTMLString:topicDescriptionHTML baseURL:[NSURL URLWithString:@"http://userecho.com"]];
                     
                     //Load user avatar
                     [UECommon loadAvatar:[[topic objectForKey:@"author"] objectForKey:@"avatar_url"]
                             onCompletion:^(UIImage *image) {
                                 authorAvatar.image=image;
                                 authorAvatar.layer.cornerRadius = 5.0;
                             }
                      ];
                     
                     
                     //Reply
                     NSNumber* status = [[topic objectForKey:@"status"] objectForKey:@"id"];
                     
                     //frame=replyPane.frame;
                     //frame.size.height=0;
                     //replyPane.frame=frame;
                     
                     if([status intValue]>1) {
                         //replyStatus.text=[topic objectForKey:@"status_name"];
                         replyStatus.hidden = false;
                         
                         
                         
                         [replyStatus setText:[[[topic objectForKey:@"status"] objectForKey:@"name"] uppercaseString]];
                         
                         replyStatusBox.layer.cornerRadius = 2;
                         replyStatusBox.layer.masksToBounds = YES;
                         //[replyStatus sizeToFit];
                         
                         //CGRect frame = replyStatus.frame;
                         //frame.size.height+=10;
                         //frame.size.width+=10;
                         
                         //frame.origin.x = self.view.frame.size.width-frame.size.width-15;
                         
                         //replyStatus.frame = frame;
                         
                         //Set color
                         UIColor* color = [UECommon colorWithHexString:[NSString stringWithFormat:@"%@",[[topic objectForKey:@"status"] objectForKey:@"color"]]];
                         [replyStatusBox setBackgroundColor:color];
                         
                         
                         
                         
                         
                         
                         
                         
                         
                         
                         
                         
                         
                         
                         
                         
                         [UECommon loadAvatar:[[topic objectForKey:@"response"] objectForKey:@"avatar_url"]
                                 onCompletion:^(UIImage *image) {
                                     replyAvatar.image=image;
                                     replyAvatar.layer.cornerRadius = 5.0;
                                 }
                          ];
                         
                         replyAvatar.hidden=false;
                         
                         NSString *html = [NSString stringWithFormat:@"<head>%@</head><body>%@</body>",CSS,[topic objectForKey:@"admin_comment"]];
                         
                         [replyDescription loadHTMLString:html baseURL:[NSURL URLWithString:@"http://userecho.com"]];
                         
                         replyDescription.opaque = NO;
                         replyDescription.backgroundColor = [UIColor clearColor];
                         
                         replyDescription.hidden=false;
                         
                     
                        }
                     
                     
                     
                     
                     
                     
                     }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Description auto-height
- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    
    if(aWebView==replyDescription)
        {
        NSLog(@"Reply");
        replyDescriptionHeight.constant=aWebView.scrollView.contentSize.height;
        }
    
    if(aWebView==topicDescription)
        {
            NSLog(@"Topic H=%f",aWebView.scrollView.contentSize.height);
          //  [topicDescription sizeToFit];
            topicDescriptionHeight.constant=aWebView.scrollView.contentSize.height;
            
        }
    
    //CGSize bounds = topicScrollView.bounds.size;
    //Resize main view to fit content
   // topicScrollView.contentSize = CGSizeMake(topicScrollView.frame.size.width, topicDescription.frame.size.height + topicDescription.frame.origin.y+replyPane.frame.size.height+44+10);
    
    
    
    //NSLog(@"SV size: %f, %f", topicScrollView.frame.size.width, topicScrollView.frame.size.height);
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowComments"]) {
        
        CommentsVC *CommentsVC = segue.destinationViewController;
        UIBarButtonItem *button=sender;
        NSLog(@"SEG showcomments called %ld",(long)button.tag);
        
        CommentsVC.topicId = [NSNumber numberWithInt:button.tag];
        //NSLog(@"SEG showcomments called %@",TopicCommentsScreen.topicId2);
    }
}


//Vote
- (void)Vote: (id) sender withEvent: (UIEvent *) event{
    
    NSLog(@"Vote");

    //Present vote popover
    VoterTVC *controller = [[UIStoryboard storyboardWithName:@"UserEcho" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"VoterMenu"];
    
    //controller.delegate = self;
    
    //NSDictionary* topic = [topicsStream objectAtIndex:indexPath.row];
    //NSNumber* id=[self topicId];//[topic objectForKey:@"id"];
    
    controller.topicId = [self topicId];
    
    //our popover
    popover = [[FPPopoverController alloc] initWithViewController:controller];
    popover.contentSize = CGSizeMake(180,120);
    
    controller.popover = popover;
    
    //UITableViewCell *cell = [topicsTable cellForRowAtIndexPath:indexPath];
    controller.placeholder = rating;
    
    //the popover will be presented from the okButton view
    //UIView* btnView = [sender valueForKey:@"view"];
    //On these cases is better to specify the arrow direction
    [popover setArrowDirection:FPPopoverArrowDirectionLeft];
    [popover presentPopoverFromView:sender];
    
    
}

- (void)hasOrientationChanged:(NSNotification *)notification {
    /*
    UIDeviceOrientation currentOrientation;
    currentOrientation = [[UIDevice currentDevice] orientation];
    if(currentOrientation == UIDeviceOrientationLandscapeLeft){
        NSLog(@"left");
    }
    
    if(currentOrientation == UIDeviceOrientationLandscapeRight){
        NSLog(@"right");
    }
    */
//    [topicDescription reload];
    //[topicDescription sizeToFit];
    //topicDescriptionHeight.constant=topicDescription.scrollView.contentSize.height;
    NSLog(@"Orient changed");
//    [topicDescription loadHTMLString:@"" baseURL:[NSURL URLWithString:@"http://userecho.com"]];
  //  [topicDescription sizeToFit];
    //[topicDescription loadHTMLString:topicDescriptionHTML baseURL:[NSURL URLWithString:@"http://userecho.com"]];
    
}


@end
