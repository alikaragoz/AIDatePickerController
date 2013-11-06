//
//  AIAppDelegate.m
//  Demo
//
//  Created by Ali Karagoz on 06/11/2013.
//  Copyright (c) 2013 Ali Karagoz. All rights reserved.
//

#import "AIAppDelegate.h"
#import "AITableViewController.h"

@implementation AIAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    
    AITableViewController *tableViewController = [[AITableViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tableViewController];
    
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
