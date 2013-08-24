//
//  LeftMenuTVC.m
//  UserEcho for IOS test app
//
//  Created by Sergey Stukov on 8/16/13.
//  Copyright (c) 2013 UserEcho. All rights reserved.
//

#import "LeftMenuTVC.h"
#import "UEData.h"
#import "TDBadgedCell.h"
#import "UECommon.h"

#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"

@interface LeftMenuTVC ()

@end

@implementation LeftMenuTVC

NSArray* forums;

/*
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    forums=[UEData getInstance].forums;
    
    self.view.backgroundColor = [UECommon colorWithHexString:@"32394a"];
    

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [forums count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"MenuCell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    TDBadgedCell *cell = (TDBadgedCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if(cell == nil)
		cell = [[TDBadgedCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                    reuseIdentifier:CellIdentifier];
    
    
    cell.badgeString = [[[forums objectAtIndex:indexPath.row] objectForKey:@"feedback_count"] stringValue];
    cell.badgeColor = [UECommon colorWithHexString:@"61697b"];
    cell.badgeColorHighlighted = [UECommon colorWithHexString:@"61697b"];
    cell.badgeTextColor = [UECommon colorWithHexString:@"c1c7d3"];
    cell.badge.radius = 12;
    cell.badge.fontSize = 16;
    cell.showShadow = YES;

    // Configure the cell...
    UILabel *forumname = (UILabel *)[cell.contentView viewWithTag:10];
    
    forumname.text=[[forums objectAtIndex:indexPath.row] objectForKey:@"name"];
    [forumname sizeToFit];
    
    return cell;
     
}

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
    
    [UEData getInstance].forum = [[forums objectAtIndex:indexPath.row] objectForKey:@"id"];
    
     NSNotification *msg = [NSNotification notificationWithName:@"centerPanel" object:@"Refresh"];
    [[NSNotificationCenter defaultCenter] postNotification:msg];
    [self.sidePanelController showCenterPanelAnimated:YES];
    
    //[self.sidePanelController s
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (IBAction)backToMainApp {
    //[self.sidePanelController showLeftPanelAnimated:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
