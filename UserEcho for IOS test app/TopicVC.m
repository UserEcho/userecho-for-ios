//
//  TopicVC.m
//  UserEcho for IOS test app
//
//  Created by Sergey Stukov on 7/18/13.
//  Copyright (c) 2013 UserEcho. All rights reserved.
//

#import "API.h"
#import "TopicVC.h"

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
                     
                     //pass the string to the webview
                     
                     NSString *pathToCSS = [[NSBundle mainBundle] pathForResource:@"UserEcho" ofType:@"css"];
                     NSString *CSS = [NSString stringWithContentsOfFile:pathToCSS encoding:NSUTF8StringEncoding error:NULL];
                     //NSLog(@"CSS=%@",CSS);
                     NSString *html = [NSString stringWithFormat:@"<head>%@</head><body>%@</body>",CSS,[topic objectForKey:@"description"]];
                     
                     [topicDescription loadHTMLString:html baseURL:[NSURL URLWithString:@"http://userecho.com"]];

                     
                 }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Description auto-height
- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    NSLog(@"WEB VIEW LOADED");

    CGRect frame = aWebView.frame;
    frame.size.height = 1;
    aWebView.frame = frame;
    
    CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    aWebView.frame = frame;
    
    NSLog(@"size: %f, %f", fittingSize.width, fittingSize.height);
}

@end
