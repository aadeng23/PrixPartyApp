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
        self.eventNameLabel.textColor = [UIColor lightGrayColor];
        self.eventNameLabel.font = [UIFont fontWithName:@"Avenir-Book" size:14.0];
        self.eventNameDetail.lineBreakMode = NSLineBreakByWordWrapping;
        self.eventNameDetail.numberOfLines = 0;
        self.eventNameDetail.textColor = [UIColor whiteColor];
        self.eventNameDetail.font = [UIFont fontWithName:@"Avenir-Book" size:14.0];
        self.eventNameDetail.text = theEvent.eventBasic.title;
        
        //Location
        self.eventLocationLabel.textColor = [UIColor lightGrayColor];
        self.eventLocationLabel.font = [UIFont fontWithName:@"Avenir-Book" size:14.0];
        self.eventLocationDetail.lineBreakMode = NSLineBreakByWordWrapping;
        self.eventLocationDetail.numberOfLines = 0;
        self.eventLocationDetail.textColor = [UIColor whiteColor];
        self.eventLocationDetail.font = [UIFont fontWithName:@"Avenir-Book" size:14.0];
        self.eventLocationDetail.text = @"COOL"; //theEvent.eventLocation;
        
        //Date
        self.eventDateLabel.textColor = [UIColor lightGrayColor];
        self.eventDateLabel.font = [UIFont fontWithName:@"Avenir-Book" size:14.0];
        self.eventDateDetail.lineBreakMode = NSLineBreakByWordWrapping;
        self.eventDateDetail.numberOfLines = 0;
        self.eventDateDetail.textColor = [UIColor whiteColor];
        self.eventDateDetail.font = [UIFont fontWithName:@"Avenir-Book" size:14.0];
        NSString *completeDateString = [NSString stringWithFormat: @"%@ - %@",[formatter stringFromDate:(NSDate *)theEvent.eventBasic.startDate],[formatter stringFromDate:(NSDate *)theEvent.eventBasic.endDate]];
        self.eventDateDetail.text = completeDateString;
        
        //Admission
        self.eventAdmissionLabel.textColor = [UIColor lightGrayColor];
        self.eventAdmissionLabel.font = [UIFont fontWithName:@"Avenir-Book" size:14.0];
        self.eventAdmissionDetail.lineBreakMode = NSLineBreakByWordWrapping;
        self.eventAdmissionDetail.numberOfLines = 0;
        self.eventAdmissionDetail.textColor = [UIColor whiteColor];
        self.eventAdmissionDetail.font = [UIFont fontWithName:@"Avenir-Book" size:14.0];
        NSString* admissionString = [NSString stringWithFormat:@"$%.2f", theEvent.eventAdmission];
        self.eventAdmissionDetail.text = admissionString;
        
        //Description
        self.eventDescriptionLabel.textColor = [UIColor lightGrayColor];
        self.eventDescriptionLabel.font = [UIFont fontWithName:@"Avenir-Book" size:14.0];
        self.eventDescriptionDetail.lineBreakMode = NSLineBreakByWordWrapping;
        self.eventDescriptionDetail.numberOfLines = 0;
        self.eventDescriptionDetail.textColor = [UIColor whiteColor];
        self.eventDescriptionDetail.font = [UIFont fontWithName:@"Avenir-Book" size:14.0];
        self.eventDescriptionDetail.text = theEvent.eventDescription;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIImage * targetImage = [UIImage imageNamed:@"background.png"];
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.f);
    [targetImage drawInRect:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    self.view.backgroundColor = [UIColor colorWithPatternImage:resultImage];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = cell.detailTextLabel.text;
    UIFont *cellFont = [UIFont fontWithName:@"Avenir-Book" size:14.0];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    
    return labelSize.height + 40;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

@end
