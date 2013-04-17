//
//  HomeTableViewController.m
//  PrixParty
//
//  Created by Angela Deng on 4/13/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import "HomeTableViewController.h"
#import "EventsDetailViewController.h"

@interface HomeTableViewController (){
    MyManager *manager;
    NSMutableArray *topNews;
}

@end

@implementation HomeTableViewController

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
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"navbar.png"]
                   forBarMetrics:UIBarMetricsDefault];
    [self.tableView setBackgroundView:nil];
   
    manager = [MyManager sharedManager];
    topNews = [NSMutableArray new];
    
    self.emptyFavsMessage.textColor = [UIColor colorWithWhite:0.55f alpha:1];
    self.emptyFavsMessage.font = [UIFont fontWithName:@"TrebuchetMS-Italic" size:16.0];
    self.emptyFavsMessage.backgroundColor = [UIColor colorWithWhite:0.20f alpha:1];
    self.emptyFavsMessage.lineBreakMode = NSLineBreakByWordWrapping;
    self.emptyFavsMessage.numberOfLines = 0;
    self.emptyFavsMessage.text = @"You don't have any favorites right now. Go to the events page to start adding!";
    
    [topNews addObject:@"creepy"];
    
    //defaults = [NSUserDefaults standardUserDefaults];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewWillAppear: (BOOL) animated
{
    [self.tableView reloadData];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    // Return the number of rows in the section.
    //NSLog(@"size of list %u", [manager.favoritesList count]);
    if(section == 0){
        return [topNews count];
    }
    else{
        int size = [manager.favoritesList count];
        if(!size){
            self.emptyFavsView.hidden = NO;
        }
        else{
            self.emptyFavsView.hidden = YES;
        }
        return size;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if(indexPath.section == 0){ //Cell is a top news cell
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"TopNewsCell"];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"regcell.png"]];
        
        UILabel *newsTitle = (UILabel *)[cell.contentView viewWithTag:1];
        UILabel *newsDate = (UILabel *)[cell.contentView viewWithTag:2];
        UILabel *newsContent = (UILabel *)[cell.contentView viewWithTag:3];
        
        newsTitle.backgroundColor = [UIColor clearColor];
        newsTitle.textColor = [UIColor colorWithWhite:0.95f alpha:1];
        newsTitle.font = [UIFont fontWithName:@"Futura" size:15.0];
        //newsTitle.text = [topNews objectAtIndex:indexPath.row];
        newsTitle.text = @"High drama in F1 Chinese Grand Prix: Fernando Alonso wins for Ferrari";
        
        newsDate.backgroundColor = [UIColor clearColor];
        newsDate.textColor = [UIColor colorWithWhite:0.65f alpha:1];
        newsDate.font = [UIFont fontWithName:@"Futura" size:12.0];
        //newsDate.text = [topNews objectAtIndex:indexPath.row];
        newsDate.text = @"8 hours ago";
        
        newsContent.backgroundColor = [UIColor clearColor];
        newsContent.textColor = [UIColor colorWithWhite:0.95f alpha:1];
        newsContent.font = [UIFont fontWithName:@"Futura" size:12.0];
        //newsContent.text = [topNews objectAtIndex:indexPath.row];
        newsContent.lineBreakMode = NSLineBreakByTruncatingTail;
        newsContent.numberOfLines = 2;
        newsContent.text = @"After Fernando Alonso's supreme drive to victory in last weekend's Chinese Grand Prix, it looks increasingly likely the world of Formula One racing will be in flux for some time to come.";
            
    }
    else{ //Cell is a favorites cell
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"FavoriteCell"];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"regcell.png"]];
        
        //Setting date formatter
        static NSDateFormatter *formatter = nil;
        if (formatter == nil) {
            formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
        }
        
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
        UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:2];
        UILabel *descriptionLabel = (UILabel *)[cell.contentView viewWithTag:3];
        Event *eventAtIndex = [manager.favoritesList objectAtIndex:indexPath.row];
        
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor colorWithWhite:0.95f alpha:1];
        nameLabel.font = [UIFont fontWithName:@"Futura" size:15.0];
        nameLabel.text = eventAtIndex.eventName;
        
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.textColor = [UIColor colorWithWhite:0.65f alpha:1];
        dateLabel.font = [UIFont fontWithName:@"Futura" size:12.0];
        
        //r: Re-enable when dates working again
//        [dateLabel setText:[formatter stringFromDate:eventAtIndex.eventBasic.startDate]];

        
        descriptionLabel.backgroundColor = [UIColor clearColor];
        descriptionLabel.textColor = [UIColor colorWithWhite:0.95f alpha:1];
        descriptionLabel.font = [UIFont fontWithName:@"Futura" size:12.0];
        descriptionLabel.text = eventAtIndex.description;
        descriptionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        descriptionLabel.numberOfLines = 2;
        
        /*cell.textLabel.font = [UIFont fontWithName:@"Avenir-Black" size:20.0];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Avenir-Black" size:14.0];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.text = eventAtIndex.eventBasic.title;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        [[cell detailTextLabel] setText:[formatter stringFromDate:eventAtIndex.eventBasic.startDate]];*/

    }
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 100)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake (0,0,200,30)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont fontWithName:@"Futura" size:18.0];
    headerLabel.textColor = [UIColor lightGrayColor];
    if(section == 0){
        headerLabel.text = @"Top news";
    }
    else{
        headerLabel.text = @"Your favorited events";
    }
    [headerView addSubview:headerLabel];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0f;
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowEventDetails"]) {
        
        EventsDetailViewController *detailViewController = [segue destinationViewController];
        //detailViewController.dataController = self.dataController;
        detailViewController.event = [manager.favoritesList objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        
        detailViewController.navBar = self.navigationController.navigationBar;
        
        UIImage *toImage = [UIImage imageNamed:@"plainnavigationbar.png"];
        [UIView transitionWithView:self.view
                          duration:10.0f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self.navigationController.navigationBar setBackgroundImage:toImage forBarMetrics:UIBarMetricsDefault];
                        } completion:nil];
        
        //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"plainnavigationbar.png"] forBarMetrics:UIBarMetricsDefault];
        //self.navigationItem.backBarButtonItem.tintColor = [UIColor redColor];
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Return" style:UIBarButtonItemStyleBordered target:nil action:nil];
        backButton.tintColor = [UIColor clearColor];
        [[self navigationItem] setBackBarButtonItem:backButton];
    }

}
@end
