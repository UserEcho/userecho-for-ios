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

@interface CommentsVC ()

@end

@implementation CommentsVC

NSArray *commentsStream;

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
    [self refreshStream];

    NSLog(@"Token=%@",[UEData getInstance].access_token);
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
    
    static NSString *simpleTableIdentifier = @"CommentCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    NSDictionary* comment = [commentsStream objectAtIndex:indexPath.row];
    
    // Configure Cells
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:10];
    [label setText:[[comment objectForKey:@"author"] objectForKey:@"name"]];
    
    label = (UILabel *)[cell.contentView viewWithTag:11];
    [label setText:[comment objectForKey:@"comment"]];
    
    //label = (UILabel *)[cell.contentView viewWithTag:12];
    //[label setText:[topic objectForKey:@"date"]];
    
    
    //Load user avatar
    UIImageView *avatar = (UIImageView *)[cell.contentView viewWithTag:13];
    
    NSString* urlString = [NSString stringWithFormat:@"http://userecho.com%@",[[comment objectForKey:@"author"] objectForKey:@"avatar_url"]];
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



@end
