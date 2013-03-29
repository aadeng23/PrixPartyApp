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
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:200.0f/255.0f green:22.0f/255.0f blue:22.0f/255.0f alpha:0.5f];
    self.eventsListTableView.backgroundColor = [UIColor clearColor];
    
    UIImage * targetImage = [UIImage imageNamed:@"background.png"];
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.f);
    [targetImage drawInRect:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:resultImage];
    
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
    
    UIImage *rowBackground;
    //UIImage *selectionBackground;
    NSInteger sectionRows = [self.eventsListTableView numberOfRowsInSection:[indexPath section]];
    NSInteger row = [indexPath row];
    
    /*if (row == 0 && row == sectionRows - 1)
    {
        rowBackground = [UIImage imageNamed:@"topAndBottomRow.png"];
        //selectionBackground = [UIImage imageNamed:@"topAndBottomRowSelected.png"];
    }
    else */if (row == 0)
    {
        rowBackground = [UIImage imageNamed:@"Top_Cel.png"];
        //selectionBackground = [UIImage imageNamed:@"topRowSelected.png"];
    }
    else if (row == sectionRows - 1)
    {
        rowBackground = [UIImage imageNamed:@"BottomCel.png"];
        //selectionBackground = [UIImage imageNamed:@"bottomRowSelected.png"];
    }
    else
    {
        rowBackground = [UIImage imageNamed:@"CenterCel.png"];
        //selectionBackground = [UIImage imageNamed:@"middleRowSelected.png"];
    }
    ((UIImageView *)cell.backgroundView).image = rowBackground;
    //((UIImageView *)cell.selectedBackgroundView).image = selectionBackground;
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Top_Cel.png"]];
    
    cell.textLabel.font = [UIFont fontWithName:@"Avenir-Black" size:20.0];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Avenir-Black" size:14.0];
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


