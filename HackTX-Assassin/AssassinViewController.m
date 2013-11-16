//
//  AssassinViewController.m
//  HackTX-Assassin
//
//  Created by Chris Mlinac on 11/15/13.
//  Copyright (c) 2013 cmlinac. All rights reserved.
//

#import "AssassinViewController.h"

@interface AssassinViewController ()

@end

@implementation AssassinViewController

enum ALERT_TAGS {ALERT_CREATE_GAME, ALERT_JOIN_GAME};

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (![PFUser currentUser])
        [self presentLogInController];
    self.navigationController.navigationBar.translucent = NO;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)showGameViewForId:(NSString *)gameId {
    PFQuery *query = [PFQuery queryWithClassName:@"Game"];
    [query whereKey:@"objectId" equalTo:gameId];
    PFObject *game = [query getFirstObject];
    UIViewController *viewController;
    if ([[game objectForKey:@"in_progress"] boolValue]) {
        viewController = [GameStatusViewController makeControllerFromGame:game];
    }
    else {
        viewController = [LobbyViewController makeControllerFromGame:game];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    if (![PFUser currentUser]) {
        [self presentLogInController];
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"playing"]) {
        [self showGameViewForId:[[NSUserDefaults standardUserDefaults] objectForKey:@"gameId"]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createGamePressed:(id)sender {
    UIAlertView *alert = [self makeGameTextAlertView];
    alert.title = @"Create game";
    alert.tag = ALERT_CREATE_GAME;
    [alert show];
}

- (IBAction)joinGamePressed:(id)sender {
    UIAlertView *alert = [self makeGameTextAlertView];
    alert.tag = ALERT_JOIN_GAME;
    alert.message = @"Enter the name of the game";
    [alert show];
}

- (UIAlertView *)makeGameTextAlertView {
    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert addButtonWithTitle:@"Cancel"];
    [alert addButtonWithTitle:@"OK"];
    alert.delegate = self;
    alert.message = @"Enter the name of the game";
    return alert;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *gameName = [alertView textFieldAtIndex:0].text;
        PFQuery *query = [PFQuery queryWithClassName:@"Game"];
        [query whereKey:@"name" equalTo:gameName];
        NSArray *foundGame = [query findObjects];
        if (alertView.tag == ALERT_CREATE_GAME) {
            if ([foundGame count]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Duplicate name" message:@"This game name is already in use. Please choose another." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else {
                PFObject *newGame = [PFObject objectWithClassName:@"Game"];
                [newGame setObject:@NO forKey:@"in_progress"];
                [newGame setObject:gameName forKey:@"name"];
                [newGame addObject:[PFUser currentUser].username forKey:@"all_players"];
                [newGame setObject:[PFUser currentUser].objectId forKey:@"master"];
                [newGame save];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"playing"];
                [[NSUserDefaults standardUserDefaults] setObject:newGame.objectId forKey:@"gameId"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self showGameViewForId:newGame.objectId];
            }
        }
        else if (alertView.tag == ALERT_JOIN_GAME) {
            if ([foundGame count]) {
                PFObject *joinGame = [foundGame objectAtIndex:0];
                if ([joinGame objectForKey:@"in_progress"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot join" message:@"This game is already in progress." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                else {
                    [[NSUserDefaults standardUserDefaults] setObject:joinGame.objectId forKey:@"gameId"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [joinGame addObject:[PFUser currentUser].username forKey:@"all_players"];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"playing"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"sword" forKey:@"weapon"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self showGameViewForId:joinGame.objectId];
                }
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not found" message:@"This game name was not found." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
    }
}

#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length && password.length) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    //    [self.navigationController popViewControllerAnimated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In" message:@"Please log in or sign up before continuing." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [self presentLogInController];
}


#pragma mark - PFSignUpViewControllerDelegate

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || !field.length) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome!" message:@"This is Skatabase.\n\n First, create or join a group from the settings menu. Then, you can create spots by holding down on the map, check in at any spot in your groups, and get notifications when friends around you are skating!\n\n You need the group name and password to join an existing group." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//    [alert show];
    [[PFUser currentUser] setObject:[self getUUID] forKey:@"uuid"];
    [[PFUser currentUser] save];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

- (void)logOut {
    [PFUser logOut];
    [self presentLogInController];
}

- (void)presentLogInController {
    // Create the log in view controller
    PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
    [logInViewController setDelegate:self]; // Set ourselves as the delegate
    
    // Create the sign up view controller
    PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
    [signUpViewController setDelegate:self]; // Set ourselves as the delegate
    
    // Assign our sign up controller to be displayed from the login controller
    [logInViewController setSignUpController:signUpViewController];
    
    // Present the log in view controller
    [self presentViewController:logInViewController animated:YES completion:NULL];
}

- (NSString *)getUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}
@end
