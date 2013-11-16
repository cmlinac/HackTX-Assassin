//
//  WeaponSelectViewController.m
//  HackTX-Assassin
//
//  Created by Alan Bouzek on 11/16/13.
//  Copyright (c) 2013 cmlinac. All rights reserved.
//

#import "WeaponSelectViewController.h"

@interface WeaponSelectViewController ()

@end

@implementation WeaponSelectViewController

enum VIEWS {IMAGE, NAME, ACCURACY, RANGE, TIMING};

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
-(BOOL) prefersStatusBarHidden { return YES; }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WeaponCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UIImageView *image = (UIImageView *)[cell viewWithTag:IMAGE];
    image.contentMode = UIViewContentModeScaleAspectFill;
    image.clipsToBounds = YES;
    UILabel *name = (UILabel *)[cell viewWithTag:NAME];
    UILabel *accuracy = (UILabel *)[cell viewWithTag:ACCURACY];
    UILabel *range = (UILabel *)[cell viewWithTag:RANGE];
    UILabel *timing = (UILabel *)[cell viewWithTag:TIMING];
    switch (indexPath.row) {
        case 0:
            name.text = @"Sword";
            accuracy.text = @"100%";
            range.text = @"Close";
            timing.text = @"None, no reload";
            break;
        case 1:
            name.text = @"Bow";
            accuracy.text = @"75%";
            range.text = @"Within sight, 30 feet average";
            timing.text = @"None, 2 minute reload";
            break;
        case 2:
            name.text = @"Poison";
            accuracy.text = @"90%";
            range.text = @"Close";
            timing.text = @"Up to 24 hours, 1 day reload";
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *weapon;
    switch (indexPath.row) {
        case 0:
            weapon = @"sword";
            break;
        case 1:
            weapon = @"bow";
            break;
        case 2:
            weapon = @"poison";
            break;
    }
    [[NSUserDefaults standardUserDefaults] setObject:weapon forKey:@"weapon"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160;
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
