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

@interface TopicVC ()

@end

@implementation TopicVC

NSDictionary *topic;

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
    btnComments.tag=[self.topicId intValue];
    NSLog(@"TID=%@",self.topicId);
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
                     
                     //pass the string to the webview
                     
                     NSString *pathToCSS = [[NSBundle mainBundle] pathForResource:@"UserEcho" ofType:@"css"];
                     NSString *CSS = [NSString stringWithContentsOfFile:pathToCSS encoding:NSUTF8StringEncoding error:NULL];
                     //NSLog(@"CSS=%@",CSS);
                     NSString *html = [NSString stringWithFormat:@"<head>%@</head><body>%@</body>",CSS,[topic objectForKey:@"description"]];
                     
                     [topicDescription loadHTMLString:html baseURL:[NSURL URLWithString:@"http://userecho.com"]];
                     
                     
                     //Load user avatar
                     NSString* urlString = [NSString stringWithFormat:@"http://userecho.com%@",[[topic objectForKey:@"author"] objectForKey:@"avatar_url"]];
                     
                     NSURL* imageURL = [NSURL URLWithString:urlString];
                     
                     AFImageRequestOperation* imageOperation =
                     [AFImageRequestOperation imageRequestOperationWithRequest: [NSURLRequest requestWithURL:imageURL]
                                                                       success:^(UIImage *image) {
                                                                           
                                                                           [authorAvatar setImage: image];
                                                                           
                                                                       }];
                     
                     NSOperationQueue* queue = [[NSOperationQueue alloc] init];
                     [queue addOperation:imageOperation];
                     
                     

                     
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
    
    btnComments.frame = CGRectMake( bounds.width/2-96/2, fittingSize.height+aWebView.frame.origin.y, 96, 44 );
    
    
    
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


@end
