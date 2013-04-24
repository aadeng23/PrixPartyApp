//
//  ConnectDetailViewController.m
//  PrixParty
//
//  Created by Angela Deng on 4/24/13.
//  Copyright (c) 2013 Team DUNT. All rights reserved.
//

#import "ConnectDetailViewController.h"

@interface ConnectDetailViewController ()

@end

@implementation ConnectDetailViewController

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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [[UITableViewCell alloc ] init]; //[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
   /* profname = tweet.profName;
    userName = tweet.userName;
    date = tweet.date;
    tweetText = tweet.tweetText;
    userPic = tweet.userPic;
    
        }
        //Getting label pointers
        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1];
        UILabel *profNameLabel = (UILabel *)[cell.contentView viewWithTag:2];
        UILabel *userNameLabel = (UILabel *)[cell.contentView viewWithTag:3];
        UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:4];
        UILabel *tweetTextLabel = (UILabel *)[cell.contentView viewWithTag:5];

        //Setting fonts and sizes
        profNameLabel.font = [UIFont fontWithName:@"Futura" size:12.0];
        profNameLabel.textColor = [UIColor colorWithWhite:0.95f alpha:1];
        userNameLabel.font = [UIFont fontWithName:@"Futura" size:11.0];
        userNameLabel.textColor = [UIColor colorWithWhite:0.65f alpha:1];
        dateLabel.font = [UIFont fontWithName:@"Futura" size:11.0];
        dateLabel.textColor = [UIColor colorWithWhite:0.65f alpha:1];
        tweetTextLabel.font = [UIFont fontWithName:@"Futura" size:12.0];
        tweetTextLabel.textColor = [UIColor colorWithWhite:0.95f alpha:1];

        //Setting content
        profNameLabel.text = profname;
        NSString *atUserName = @"@";
        atUserName = [atUserName stringByAppendingString:userName];
        userNameLabel.text = atUserName;
        dateLabel.text = [self getDateString:date];//date;//[formatter stringFromDate:dateString];
        tweetTextLabel.text = tweetText;
        imageView.image = userPic;


        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"regcell.png"]];
        tweetTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        tweetTextLabel.numberOfLines = 0;*/

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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
