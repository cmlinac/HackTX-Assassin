//
//  GameStatusViewController.m
//  HackTX-Assassin
//
//  Created by Alan Bouzek on 11/16/13.
//  Copyright (c) 2013 cmlinac. All rights reserved.
//

#import "GameStatusViewController.h"

@interface GameStatusViewController ()

@end

@implementation GameStatusViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (UITabBarController *)makeControllerFromGame:(PFObject *)game {
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers[0] = [[GameStatusViewController alloc] init];
    tabBarController.viewControllers[1] = [[PlayerStatusViewController alloc] init];
    return tabBarController;
}

@end
