//
//  TopicEditVC.m
//  UserEcho for IOS test app
//
//  Created by Sergey Stukov on 7/24/13.
//  Copyright (c) 2013 UserEcho. All rights reserved.
//

#import "TopicEditVC.h"
#import "API.h"
#import "UEData.h"
#import "TopicVC.h"

@interface TopicEditVC ()

@end

@implementation TopicEditVC

//UIPickerView* typePicker;
NSArray *topicTypesStream;
NSNumber *topicStatusId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"IP=%@",indexPath);
    //[self.view.window addSubview: typePicker];
    
    //Choose status clicked
    if(indexPath.row==2)
        {
            //Dismiss keyboard
            [self.view endEditing:YES];
        
            
            //show the app menu
            UIActionSheet *selector = [[UIActionSheet alloc] initWithTitle:@"Choose feedback type"
                                         delegate:self
                                cancelButtonTitle:nil
                           destructiveButtonTitle:nil
                                                      otherButtonTitles:nil];
             //showInView:self.view];
            
            //Prepare array of types
            for (id object in topicTypesStream) {
                // do something with object
                [selector addButtonWithTitle:[object objectForKey:@"name"]];
            }
            
            [selector showInView:self.view];
            
    
        
        }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"i=%ld",(long)buttonIndex);

    NSString *returnStr = [[topicTypesStream objectAtIndex:buttonIndex] objectForKey:@"name"];
    NSLog(@"Chosed=%@",returnStr);
    
    topicStatusId = [[topicTypesStream objectAtIndex:buttonIndex] objectForKey:@"id"];
    topicType.text = returnStr;

}


- (void)loadTopicTypes {

    [[API sharedInstance] get:[NSString stringWithFormat:@"forums/%@/types", [UEData getInstance].forum]
                 onCompletion:^(NSArray *json) {
                     //got stream
                     NSLog(@"Comments stream received");
                     NSLog(@"%@", json);
                     
                     NSDictionary* dict=(NSDictionary*)json;
                     
                     topicTypesStream = [dict objectForKey:@"types"];
                     
                     //Init selector
                     topicType.text=[[topicTypesStream objectAtIndex:0] objectForKey:@"name"];
                     topicStatusId=[[topicTypesStream objectAtIndex:0] objectForKey:@"id"];


                 }];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.navigationItem.title = @"Submit a feedback";
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 80)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(10,10, 300, 40);
    [btn setTitle:@"Submit" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnSaveTopicTapped) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:btn];
    
    topicEditTV.tableFooterView = headerView;
    
    
    
    // Do any additional setup after loading the view.
    
    [self loadTopicTypes];
    
    
    //topicType.delegate = self;
    
    //Setup topic picker
//    typePicker = [[UIPickerView alloc]init];
  //  typePicker.delegate=self;
    //typePicker.dataSource=self;
    
    //topicType.inputView = typePicker;
    //topicTypesStream = [[NSArray alloc] initWithObjects:@"Idea",@"Bug",@"Praise",@"Question",nil];
    topicTypesStream = @[@{@"name":@"Idea"},@{@"name":@"Bug"},@{@"name":@"Praise"},@{@"name":@"Question"}];

    /*
    //Hide textview when tap outside
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    //view to catch  tap
    UIView *view = [[UIView alloc] init];
    
    //leave the navigation bar alone
    view.frame = CGRectMake(0, 60, screenWidth, screenHeight-60);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [view addGestureRecognizer:tap];
    
    [self.view addSubview:view];
    [self.view sendSubviewToBack:view];
     */
    
}

-(void)dismissKeyboard {
    
    
    if([topicDescription isFirstResponder])[topicDescription resignFirstResponder];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






/*
//Picker configuration
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *returnStr = [[topicTypesStream objectAtIndex:row] objectForKey:@"name"];
    NSLog(@"Chosed=%@",returnStr);
    
    topicStatusId = [[topicTypesStream objectAtIndex:row] objectForKey:@"id"];
    topicType.text = returnStr;
    
    if (pickerView) pickerView.hidden = !pickerView.hidden;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 200;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *returnStr = @"";
    if (pickerView == typePicker)
    {
        returnStr = [[topicTypesStream objectAtIndex:row] objectForKey:@"name"];
    }
    
    return returnStr;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == typePicker)
    {
        return [topicTypesStream count];
    }
return 0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
*/

- (void)textViewDidChange:(UITextView *)textView
{
    if([topicDescription.text length]==0)
        {
            topicDescriptionPlaceholder.hidden = NO;
        }
    else
    {
        topicDescriptionPlaceholder.hidden = YES;
    
    }
    
}


- (IBAction)btnSaveTopicTapped
{
    //NSLog(@"Saving %@",[topicDescription.text length]);
    
    //Simple check that required data exists
    if([topicHeader.text length]==0)
        {
            UITableViewCell* cell=[topicEditTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [cell setBackgroundColor:[UIColor colorWithRed:(float)0xff/0xff green:(float)0xd3/0xff blue:(float)0xd3/0xff alpha:1.0]];
            return;
        }
    
    if([topicDescription.text length]==0)
    {
        UITableViewCell* cell=[topicEditTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        [cell setBackgroundColor:[UIColor colorWithRed:(float)0xff/0xff green:(float)0xd3/0xff blue:(float)0xd3/0xff alpha:1.0]];
        return;
    }
    
    
    [[API sharedInstance] post:[NSString stringWithFormat:@"forums/%@/feedback",  [UEData getInstance].forum]
     
     
                 params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               topicHeader.text,@"header",
                               topicStatusId,@"feedback_type",
                               topicDescription.text,@"description",
                               nil]
     
                 onCompletion:^(NSArray *json) {
                     //got stream
                     NSLog(@"Topic posted");
                     //NSLog(@"%@", json);
                     
                     

                                            
                      
                     
                     //Display view with new topic
                     NSNumber* id=[[json objectAtIndex:0] objectForKey:@"id"];
                     [self performSegueWithIdentifier:@"ShowTopic" sender:id];
                     
                     
                     //Remove current view from nav
                     NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
                     [allViewControllers removeObjectIdenticalTo: self];
                     self.navigationController.viewControllers = allViewControllers;

                     
                    
                 }];


}

//Pass topicID
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"PREP SEG");
    if ([@"ShowTopic" compare: segue.identifier]==NSOrderedSame) {
        TopicVC* TopicVC = segue.destinationViewController;
        TopicVC.topicId = sender;
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    //   [add your method here];
    //NSLog(@"RET");
    return YES;
}

@end
