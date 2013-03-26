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

/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataController = [[EventsDataController alloc] init];
        [self.dataController addEventTest];
    }
    return self;
}*/

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
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    self.eventsListTableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    self.eventsListTableView.hidden = NO;
    self.eventsMapView.hidden = YES;
    
    UIFont *font = [UIFont fontWithName:@"Avenir-Black" size:14.0];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:UITextAttributeFont];
    [self.segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];

    
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
    // Return the number of rows in the section.
    
    return [self.dataController sizeOfList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"EventCell";
    
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    Event *eventAtIndex = [self.dataController objectInListAtIndex:indexPath.row];
    
    cell.textLabel.font = [UIFont fontWithName:@"Avenir-Black" size:20.0];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Avenir-Black" size:14.0];
    
    UIImage *rowBackground = [UIImage imageNamed:@"Top_Cel.png"];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Top_Cel.png"]];
   
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.text = eventAtIndex.eventBasic.title;
    [[cell detailTextLabel] setText:[formatter stringFromDate:eventAtIndex.eventBasic.startDate]];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

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
            self.eventsListTableView.hidden = NO;
            self.eventsMapView.hidden = YES;
            break;
        case 1:
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
        detailViewController.event = [self.dataController objectInListAtIndex:[self.eventsListTableView indexPathForSelectedRow].row];
    }
}


@end


