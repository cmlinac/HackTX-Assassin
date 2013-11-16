//
//  LobbyViewController.m
//  HackTX-Assassin
//
//  Created by Alan Bouzek on 11/16/13.
//  Copyright (c) 2013 cmlinac. All rights reserved.
//

#import "LobbyViewController.h"

@interface LobbyViewController ()

@end

@implementation LobbyViewController
@synthesize game;

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
    self.navigationItem.title = [NSString stringWithFormat:@"%@ Lobby", [game objectForKey:@"name"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Leave" style:UIBarButtonItemStylePlain target:self action:@selector(leaveGame)];
    self.navigationItem.hidesBackButton = YES;
    if (![[game objectForKey:@"master"] isEqualToString:[PFUser currentUser].objectId]) {
        self.navigationItem.rightBarButtonItem.title = nil;
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"weapon"]) {
        [self showWeaponSelect];
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
    if ([[game objectForKey:@"in_progress"] boolValue]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shuffle:(NSMutableArray *)array
{
    NSUInteger count = [array count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = arc4random_uniform(nElements) + i;
        [array exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}
                                                                       
- (void)startGame {
    [game setObject:@YES forKey:@"in_progress"];
    for (NSString *player in [game objectForKey:@"all_players"]) {
        [game addObject:player forKey:@"active_players"];
    }
    NSMutableArray *actives = [game objectForKey:@"active_players"];
    [self shuffle:actives];
    [game setObject:actives forKey:@"active_players"];
    [game save];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)leaveGame {
    [game removeObject:[PFUser currentUser].username forKey:@"all_players"];
    if ([[game objectForKey:@"master"] isEqualToString:[PFUser currentUser].objectId]) {
        if ([[game objectForKey:@"all_players"] count]) {
            [game setObject:[[game objectForKey:@"all_players"] objectAtIndex:0] forKey:@"master"];
        }
    }
    [game save];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"weapon"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"playing"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) showWeaponSelect {
    UITableViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WeaponSelectViewController"];
    [self presentViewController:viewController animated:YES completion:nil];
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
    return [[game objectForKey:@"all_players"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LobbyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [[game objectForKey:@"all_players"] objectAtIndex:indexPath.row];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Players";
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

+ (LobbyViewController *)makeControllerFromGame:(PFObject *)game {
    LobbyViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LobbyViewController"];
    viewController.game = game;
    return viewController;
}

@end
