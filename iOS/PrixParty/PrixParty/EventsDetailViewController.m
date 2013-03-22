//
//  EventsDetailViewController.m
//  PrixParty
//
//  Created by Angela Deng on 3/10/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import "EventsDetailViewController.h"
#import "Event.h"

@interface EventsDetailViewController ()
- (void)configureView;
@end

@implementation EventsDetailViewController

- (void)setEvent:(Event *) newEvent
{
    if (_event != newEvent) {
        _event = newEvent;
        
        [self configureView];
    }
    
}

- (void)configureView
{
    Event *theEvent = self.event;
    static NSDateFormatter *formatter = nil;
    
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
    }
    
    if (theEvent) {
        
        /*NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],UITextAttributeTextColor,[UIFont fontWithName:@"Avenir-Black" size:14.0f],UITextAttributeFont,nil];*/
        
        /*UIFont *font = [UIFont fontWithName:@"Avenir-Black" size:9.0];
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:UITextAttributeFont];

        [self.navigationItem.backBarButtonItem setTitleTextAttributes:attributes forState:UIControlStateNormal];*/
        
        //Name
        self.eventNameLabel.textColor = [UIColor darkGrayColor];
        self.eventNameLabel.font = [UIFont fontWithName:@"Avenir-Book" size:14.0];
        self.eventNameDetail.lineBreakMode = UILineBreakModeWordWrap;
        self.eventNameDetail.numberOfLines = 0;
        self.eventNameDetail.font = [UIFont fontWithName:@"Avenir-Book" size:14.0];
        self.eventNameDetail.text = theEvent.eventBasic.title;
        
        //Location
        self.eventLocationLabel.textColor = [UIColor darkGrayColor];
        self.eventLocationLabel.font = [UIFont fontWithName:@"Avenir-Book" size:14.0];
        self.eventLocationDetail.lineBreakMode = UILineBreakModeWordWrap;
        self.eventLocationDetail.numberOfLines = 0;
        self.eventLocationDetail.font = [UIFont fontWithName:@"Avenir-Book" size:14.0];
        self.eventLocationDetail.text = @"COOL"; //theEvent.eventLocation;
        
        //Date
        self.eventDateLabel.textColor = [UIColor darkGrayColor];
        self.eventDateLabel.font = [UIFont fontWithName:@"Avenir-Book" size:14.0];
        self.eventDateDetail.lineBreakMode = UILineBreakModeWordWrap;
        self.eventDateDetail.numberOfLines = 0;
        self.eventDateDetail.font = [UIFont fontWithName:@"Avenir-Book" size:14.0];
        NSString *completeDateString = [NSString stringWithFormat: @"%@ - %@",[formatter stringFromDate:(NSDate *)theEvent.eventBasic.startDate],[formatter stringFromDate:(NSDate *)theEvent.eventBasic.endDate]];
        self.eventDateDetail.text = completeDateString;
        
        //Admission
        self.eventAdmissionLabel.textColor = [UIColor darkGrayColor];
        self.eventAdmissionLabel.font = [UIFont fontWithName:@"Avenir-Book" size:14.0];
        self.eventAdmissionDetail.lineBreakMode = UILineBreakModeWordWrap;
        self.eventAdmissionDetail.numberOfLines = 0;
        self.eventAdmissionDetail.font = [UIFont fontWithName:@"Avenir-Book" size:14.0];
        NSString* admissionString = [NSString stringWithFormat:@"$%.2f", theEvent.eventAdmission];
        self.eventAdmissionDetail.text = admissionString;
        
        //Description
        self.eventDescriptionLabel.textColor = [UIColor darkGrayColor];
        self.eventDescriptionLabel.font = [UIFont fontWithName:@"Avenir-Book" size:14.0];
        self.eventDescriptionDetail.lineBreakMode = UILineBreakModeWordWrap;
        self.eventDescriptionDetail.numberOfLines = 0;
        self.eventDescriptionDetail.font = [UIFont fontWithName:@"Avenir-Book" size:14.0];
        self.eventDescriptionDetail.text = theEvent.eventDescription;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//TABLE STUFF

/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"NameCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    return cell;
}*/


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //NSString *cellText = cell.textLabel.text;
    //NSLog(@"text %@", cellText);
    /*UIFont *cellFont = [UIFont fontWithName:@"Avenir-Book" size:14.0];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    return labelSize.height + 20;*/

    return 80;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

@end
