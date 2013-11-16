//
//  GameStatusViewController.h
//  HackTX-Assassin
//
//  Created by Alan Bouzek on 11/16/13.
//  Copyright (c) 2013 cmlinac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface GameStatusViewController : UIViewController

@property (nonatomic, strong) PFObject *game;

+ (UITabBarController *)makeControllerFromGame:(PFObject *)game;

@end
