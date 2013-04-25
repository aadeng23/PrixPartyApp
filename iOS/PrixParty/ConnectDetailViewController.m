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
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
}

- (void)viewDidAppear:(BOOL)animated{
   
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell;
    if(indexPath.row == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell"];
        //Getting label pointers
        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1];
        UILabel *profNameLabel = (UILabel *)[cell.contentView viewWithTag:2];
        UILabel *userNameLabel = (UILabel *)[cell.contentView viewWithTag:3];
        UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:4];
        UILabel *tweetTextLabel = (UILabel *)[cell.contentView viewWithTag:5];
        
        //Setting fonts and sizes
        profNameLabel.font = [UIFont fontWithName:@"Futura" size:14.0];
        profNameLabel.textColor = [UIColor colorWithWhite:0.95f alpha:1];
        userNameLabel.font = [UIFont fontWithName:@"Futura" size:12.0];
        userNameLabel.textColor = [UIColor colorWithWhite:0.65f alpha:1];
        dateLabel.font = [UIFont fontWithName:@"Futura" size:12.0];
        dateLabel.textColor = [UIColor colorWithWhite:0.65f alpha:1];
        tweetTextLabel.font = [UIFont fontWithName:@"Futura" size:12.0];
        tweetTextLabel.textColor = [UIColor colorWithWhite:0.95f alpha:1];
        
        //Setting content
        profNameLabel.text = self.tweet.profName;
        NSString *atUserName = @"@";
        atUserName = [atUserName stringByAppendingString:self.tweet.userName];
        userNameLabel.text = atUserName;
        dateLabel.text = [self getDateString:self.tweet.date];//date;//[formatter stringFromDate:dateString];
        tweetTextLabel.text = self.tweet.tweetText;
        imageView.image = [self imageWithRoundedCornersSize:5.0f usingImage:self.tweet.userPic];

        
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"buttonsCell"];
        
        
    }

    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == 0){
        
        UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];

        UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:5];
        NSString *cellText = textLabel.text;
        UIFont *cellFont = [UIFont fontWithName:@"Futura" size:12.0];
        CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
        
        CGSize textSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        
        return textSize.height + 120;
    }
    else{
        return 64;
    }
    
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"regcell.png"]];
}

- (NSString *)getDateString:(NSString *)origDate;{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    
    // see http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns
    [dateFormatter setDateFormat: @"EEE MMM dd HH:mm:ss Z yyyy"];
    
    NSDate *date = [dateFormatter dateFromString:origDate];
    
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    return [dateFormatter stringFromDate:date];
    
}

- (UIImage *)imageWithRoundedCornersSize:(float)cornerRadius usingImage:(UIImage *)original
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:original];
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 1.0);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds
                                cornerRadius:cornerRadius] addClip];
    // Draw your image
    [original drawInRect:imageView.bounds];
    
    // Get the image, here setting the UIImageView image
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return imageView.image;
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

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"plainnavigationbar.png"] forBarMetrics:UIBarMetricsDefault];
    }
    [super viewWillDisappear:animated];
}

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
