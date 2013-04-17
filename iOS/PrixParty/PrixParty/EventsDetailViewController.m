//
//  EventsDetailViewController.m
//  PrixParty
//
//  Created by Angela Deng on 3/10/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import "EventsDetailViewController.h"
#import "Event.h"
#import "MyManager.h"

@interface EventsDetailViewController (){
    
    MyManager *manager;
}
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
    
    //Set date formatter
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
    }
    
    if (theEvent) {
        
        //Name
        self.eventNameLabel.textColor = [UIColor colorWithWhite:0.65f alpha:1];
        self.eventNameLabel.font = [UIFont fontWithName:@"Futura" size:14.0];
        self.eventNameDetail.lineBreakMode = NSLineBreakByWordWrapping;
        self.eventNameDetail.numberOfLines = 0;
        self.eventNameDetail.textColor = [UIColor colorWithWhite:0.95f alpha:1];
        self.eventNameDetail.font = [UIFont fontWithName:@"Futura" size:14.0];
        self.eventNameDetail.text = theEvent.eventName;
        
        //Location
        self.eventLocationLabel.textColor = [UIColor colorWithWhite:0.65f alpha:1];
        self.eventLocationLabel.font = [UIFont fontWithName:@"Futura" size:14.0];
        self.eventLocationDetail.lineBreakMode = NSLineBreakByWordWrapping;
        self.eventLocationDetail.numberOfLines = 0;
        self.eventLocationDetail.textColor = [UIColor colorWithWhite:0.95f alpha:1];
        self.eventLocationDetail.font = [UIFont fontWithName:@"Futura" size:14.0];
        self.eventLocationDetail.text = theEvent.friendlyLocation;
        
        //Date
        self.eventDateLabel.textColor = [UIColor colorWithWhite:0.65f alpha:1];
        self.eventDateLabel.font = [UIFont fontWithName:@"Futura" size:14.0];
        self.eventDateDetail.lineBreakMode = NSLineBreakByWordWrapping;
        self.eventDateDetail.numberOfLines = 0;
        self.eventDateDetail.textColor = [UIColor colorWithWhite:0.95f alpha:1];
        self.eventDateDetail.font = [UIFont fontWithName:@"Futura" size:14.0];
        
        //r
//        NSString *completeDateString = [NSString stringWithFormat: @"%@ - %@",[formatter stringFromDate:(NSDate *)theEvent.eventBasic.startDate],[formatter stringFromDate:(NSDate *)theEvent.eventBasic.endDate]];
  //      self.eventDateDetail.text = completeDateString;
        
        //Admission
        self.eventAdmissionLabel.textColor = [UIColor colorWithWhite:0.65f alpha:1];
        self.eventAdmissionLabel.font = [UIFont fontWithName:@"Futura" size:14.0];
        self.eventAdmissionDetail.lineBreakMode = NSLineBreakByWordWrapping;
        self.eventAdmissionDetail.numberOfLines = 0;
        self.eventAdmissionDetail.textColor = [UIColor colorWithWhite:0.95f alpha:1];
        self.eventAdmissionDetail.font = [UIFont fontWithName:@"Futura" size:14.0];
        
        //r
//        NSString* admissionString = [NSString stringWithFormat:@"$%.2f", theEvent.eventAdmission];
//        self.eventAdmissionDetail.text = admissionString;
        
        //Description
        self.eventDescriptionLabel.textColor = [UIColor colorWithWhite:0.65f alpha:1];
        self.eventDescriptionLabel.font = [UIFont fontWithName:@"Futura" size:14.0];
        self.eventDescriptionDetail.lineBreakMode = NSLineBreakByWordWrapping;
        self.eventDescriptionDetail.numberOfLines = 0;
        self.eventDescriptionDetail.textColor = [UIColor colorWithWhite:0.95f alpha:1];
        self.eventDescriptionDetail.font = [UIFont fontWithName:@"Futura" size:14.0];
        self.eventDescriptionDetail.text = theEvent.description;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    UIButton *favButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if(!_event.favorite){
        [favButton setBackgroundImage:[UIImage imageNamed:@"favoritebutton.png"]  forState:UIControlStateNormal];
    }
    else{
        [favButton setBackgroundImage:[UIImage imageNamed:@"favoritebuttonselect.png"] forState:UIControlStateNormal];
    }
    favButton.showsTouchWhenHighlighted = YES;
    [favButton addTarget:self action:@selector(favoriteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    favButton.frame = CGRectMake(0, 0, 35, 30);
    UIBarButtonItem *favoriteButton = [[UIBarButtonItem alloc] initWithCustomView:favButton] ;
    self.navigationItem.rightBarButtonItem = favoriteButton;
    
    manager = [MyManager sharedManager];
    
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"regcell.png"]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = cell.detailTextLabel.text;
    UIFont *cellFont = [UIFont fontWithName:@"Futura" size:14.0];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    
    return labelSize.height + 40;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 100)];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"navbar.png"] forBarMetrics:UIBarMetricsDefault];
    }
    [super viewWillDisappear:animated];
}

- (IBAction)favoriteButtonPressed:(UIButton *)sender {


    if(!self.event.favorite){
        self.event.favorite = YES;
        [sender setBackgroundImage:[UIImage imageNamed:@"favoritebuttonselect.png"] forState:UIControlStateNormal];
        [manager.favoritesList addObject:self.event];
    }
    else{
        self.event.favorite = NO;
            [sender setBackgroundImage:[UIImage imageNamed:@"favoritebutton.png"] forState:UIControlStateNormal];
        [manager.favoritesList removeObjectIdenticalTo:self.event];
    }
}
@end
