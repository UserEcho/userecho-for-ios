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
    [btnComments setTitle:NSLocalizedStringFromTable(@"Comments",@"UserEcho",nil) forState:UIControlStateNormal];
    [btnComments sizeToFit];
    
    
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
                     
                     NSLog(@"Ratin:%@",[topic objectForKey:@"vote_diff"]);
                     rating.text=[NSString stringWithFormat:@"%@",[topic objectForKey:@"vote_diff"]];
                     
                     [btnVote addTarget: self action: @selector(Vote:withEvent:)
                      forControlEvents: UIControlEventTouchUpInside];
                     
                     
                     //pass the string to the webview
                     
                     NSString *pathToCSS = [[NSBundle mainBundle] pathForResource:@"UserEcho" ofType:@"css"];
                     NSString *CSS = [NSString stringWithContentsOfFile:pathToCSS encoding:NSUTF8StringEncoding error:NULL];
                     //NSLog(@"CSS=%@",CSS);
                     NSString *html = [NSString stringWithFormat:@"<head>%@</head><body>%@</body>",CSS,[topic objectForKey:@"description"]];
                     
                     [topicDescription loadHTMLString:html baseURL:[NSURL URLWithString:@"http://userecho.com"]];
                     
                     //Load user avatar
                     [UECommon loadAvatar:[[topic objectForKey:@"author"] objectForKey:@"avatar_url"]
                             onCompletion:^(UIImage *image) {
                                 authorAvatar.image=image;
                             }
                      ];
                     }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Description auto-height
- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    
    aWebView.scrollView.scrollEnabled = NO;
    //aWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;

    
    NSLog(@"WEB VIEW LOADED");

    CGRect frame = aWebView.frame;
    frame.size.height = 1;
    aWebView.frame = frame;
    
    CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    aWebView.frame = frame;
    
    CGSize bounds = topicScrollView.bounds.size;
    
    frame=btnComments.frame;
    
    btnComments.frame = CGRectMake( bounds.width/2-frame.size.width/2, fittingSize.height+aWebView.frame.origin.y, frame.size.width, 44 );
    
    
    
   // NSLog(@"size: %f, %f", fittingSize.width, fittingSize.height);
    
    //NSLog(@"SV size: %f, %f", topicScrollView.frame.size.width, topicScrollView.frame.size.height);
    
   topicScrollView.contentSize = CGSizeMake(topicScrollView.frame.size.width, fittingSize.height + aWebView.frame.origin.y+44+10);
    
   
    
  //  self.webViewHeightConstraint.constant = 2000;

//    textViewHeightConstraint.constant = textView.contentSize.height;
    
  //  [topicScrollView layoutIfNeeded];
    
    
   // [topicScrollView setTranslatesAutoresizingMaskIntoConstraints:YES];
//    [topicScrollView setContentSize:(CGSizeMake(320, 1000))];
  //  scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, sizeOfContent);
//    topicScrollView.translatesAutoresizingMaskIntoConstraints = NO;
//    [topicScrollView setCons]self.webViewHeightConstraint.constant = [webHeight intValue];
  
    NSLog(@"SV size: %f, %f", topicScrollView.frame.size.width, topicScrollView.frame.size.height);
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowComments"]) {
        
        CommentsVC *CommentsVC = segue.destinationViewController;
        UIButton *button=sender;
        //NSLog(@"SEG showcomments called %ld",(long)button.tag);
        
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


@end
