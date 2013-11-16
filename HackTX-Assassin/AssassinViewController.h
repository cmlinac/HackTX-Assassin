//
//  AssassinViewController.h
//  HackTX-Assassin
//
//  Created by Chris Mlinac on 11/15/13.
//  Copyright (c) 2013 cmlinac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LobbyViewController.h"
#import "GameStatusViewController.h"

@interface AssassinViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UIAlertViewDelegate>
- (IBAction)createGamePressed:(id)sender;
- (IBAction)joinGamePressed:(id)sender;

@end
