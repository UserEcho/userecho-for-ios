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

@interface UserEchoVC ()

@end

@implementation UserEchoVC

NSArray *topicsStream;

- (void)backToMainApp {
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end
