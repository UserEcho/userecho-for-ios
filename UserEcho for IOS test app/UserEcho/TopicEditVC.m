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

@interface TopicEditVC ()

@end

@implementation TopicEditVC

UIPickerView* typePicker;
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


- (void)loadTopicTypes {

    [[API sharedInstance] get:[NSString stringWithFormat:@"forums/%@/types", [UEData getInstance].forum]
                 onCompletion:^(NSArray *json) {
                     //got stream
                     NSLog(@"Comments stream received");
                     NSLog(@"%@", json);
                     
                     NSDictionary* dict=(NSDictionary*)json;
                     
                     topicTypesStream = [dict objectForKey:@"types"];
                     
                     //NSLog(@"Loaded:%u",[commentsStream count]);
                     
                 }];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self loadTopicTypes];
    
    
    topicType.delegate = self;
    
    //Setup topic picker
    typePicker = [[UIPickerView alloc]init];
    typePicker.delegate=self;
    typePicker.dataSource=self;
    
    topicType.inputView = typePicker;
    //topicTypesStream = [[NSArray alloc] initWithObjects:@"Idea",@"Bug",@"Praise",@"Question",nil];
    topicTypesStream = @[@{@"name":@"Idea"},@{@"name":@"Bug"},@{@"name":@"Praise"},@{@"name":@"Question"}];


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
    
}

-(void)dismissKeyboard {
    
    
    if([topicDescription isFirstResponder])[topicDescription resignFirstResponder];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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


- (IBAction)btnSaveTopicTapped
{
    NSLog(@"Saving");
    
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
                    
                 }];


}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    //   [add your method here];
    //NSLog(@"RET");
    return YES;
}

@end
