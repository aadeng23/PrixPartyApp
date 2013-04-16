//
//  EventsViewController.m
//  PrixParty
//
//  Created by Angela Deng on 2/26/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import "EventsViewController.h"
#import "EventsDetailViewController.h"

@interface EventsViewController ()

@end

@implementation EventsViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.dataController = [[EventsDataController alloc] init];
    
    [self.dataController addEventTest];
    [self.dataController addEventTest];
    [self.dataController addEventTest];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    
    //Setting background and navigation bar
    self.view.backgroundColor = [UIColor blackColor];
    self.eventsListTableView.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"navbar.png"]
                                                  forBarMetrics:UIBarMetricsDefault];
    
    //Setting segment controls
    [self.segmentedControl setImage:[UIImage imageNamed:@"listbutton.png"] forSegmentAtIndex:0];
    [self.segmentedControl setImage:[UIImage imageNamed:@"mapbutton.png"] forSegmentAtIndex:1];
    //[self.segmentedControl setDividerImage:<#(UIImage *)#> forLeftSegmentState:<#(UIControlState)#> rightSegmentState:<#(UIControlState)#> barMetrics:<#(UIBarMetrics)#>];

    //Show view
    self.eventsListTableView.hidden = NO;
    self.eventsMapView.hidden = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataController sizeOfList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell"];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"regcell.png"]];
    
    //Setting date formatter
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
    }
    
    //Getting labels from cell
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
    UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:2];
    UILabel *descriptionLabel = (UILabel *)[cell.contentView viewWithTag:3];
    Event *eventAtIndex = [self.dataController objectInListAtIndex:indexPath.row];
    
    //Setting label settings
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor colorWithWhite:0.95f alpha:1];
    nameLabel.font = [UIFont fontWithName:@"Futura" size:15.0];
    nameLabel.text = eventAtIndex.eventBasic.title;
    
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textColor = [UIColor colorWithWhite:0.65f alpha:1];
    dateLabel.font = [UIFont fontWithName:@"Futura" size:12.0];
    [dateLabel setText:[formatter stringFromDate:eventAtIndex.eventBasic.startDate]];
    
    descriptionLabel.backgroundColor = [UIColor clearColor];
    descriptionLabel.textColor = [UIColor colorWithWhite:0.95f alpha:1];
    descriptionLabel.font = [UIFont fontWithName:@"Futura" size:12.0];
    descriptionLabel.text = eventAtIndex.eventDescription;
    descriptionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    descriptionLabel.numberOfLines = 2;
    
    return cell;

}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

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
 }*/
 

#pragma mark - Table view delegate

/*- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
     EventsDetailViewController *detailViewController = [[EventsDetailViewController alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     
}*/


- (IBAction)segmentValueChanged:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
            //list view
        case 0:
            //[self.segmentedControl setImage:[UIImage imageNamed:@"listbutton.png"] forSegmentAtIndex:0];
            [self.segmentedControl setImage:[UIImage imageNamed:@"mapbutton.png"] forSegmentAtIndex:1];
            //[self.segmentedControl setDividerImage:<#(UIImage *)#> forLeftSegmentState:<#(UIControlState)#> rightSegmentState:<#(UIControlState)#> barMetrics:<#(UIBarMetrics)#>];
            self.eventsListTableView.hidden = NO;
            self.eventsMapView.hidden = YES;
            break;
        case 1:
            [self.segmentedControl setImage:[UIImage imageNamed:@"listbutton.png"] forSegmentAtIndex:0];
            //[self.segmentedControl setImage:[UIImage imageNamed:@"listbutton.png"] forSegmentAtIndex:0];
            //[self.segmentedControl setDividerImage:<#(UIImage *)#> forLeftSegmentState:<#(UIControlState)#> rightSegmentState:<#(UIControlState)#> barMetrics:<#(UIBarMetrics)#>];
            self.eventsListTableView.hidden = YES;
            self.eventsMapView.hidden = NO;
            break;
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowEventDetails"]) {
        
        EventsDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.dataController = self.dataController;
        detailViewController.event = [self.dataController objectInListAtIndex:[self.eventsListTableView indexPathForSelectedRow].row];
        
    }
}


@end


