//
//  VoterTVC.m
//  UserEcho for IOS test app
//
//  Created by Sergey Stukov on 7/26/13.
//  Copyright (c) 2013 UserEcho. All rights reserved.
//

#import "VoterTVC.h"
#import "API.h"

@interface VoterTVC ()

@end

@implementation VoterTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}
 */

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
 */

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Topic ID=%@",self.topicId);
    NSLog(@"Action=%ld",(long)indexPath.row);
    
    NSNumber *value=[NSNumber numberWithInt:0];
    
    if(indexPath.row == 0)
        {
        value=[NSNumber numberWithInt:1];
        }
    else if (indexPath.row == 1)
        {
        value=[NSNumber numberWithInt:-1];
        }
    
    [[API sharedInstance] post:[NSString stringWithFormat:@"feedback/%@/votes",  self.topicId]
     
                        params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                value,@"value",
                                nil]
     
     
                  onCompletion:^(NSArray *json) {
                      NSLog(@"Vote completion");
                      //[self refreshStream];
                      NSLog(@"Reply=%@",json);
                      
                      NSDictionary *topic = (NSDictionary *)json;

                      UILabel *label = (UILabel *)[self.cell.contentView viewWithTag:12]; 
                      [label setText:[NSString stringWithFormat:@"%@",[[topic objectForKey:@"score"] objectForKey:@"vote_diff"]]];
                      
                      
                      [self.popover dismissPopoverAnimated:YES];
                  }];

    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
