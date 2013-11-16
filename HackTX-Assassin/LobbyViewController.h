//
//  LobbyViewController.h
//  HackTX-Assassin
//
//  Created by Alan Bouzek on 11/16/13.
//  Copyright (c) 2013 cmlinac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LobbyViewController : UITableViewController

@property (nonatomic, strong) PFObject *game;
+ (LobbyViewController *)makeControllerFromGame:(PFObject *)game;

@end
