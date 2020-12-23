//
//  AppDelegate.m
//  IJKMoviePlayerSample
//
//  Created by chaney on 2020/12/22.
//  Copyright © 2020 Chaney Lau. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    ViewController * controller = [[ViewController alloc] init];
    UINavigationController * navigation = [[UINavigationController alloc] initWithRootViewController:controller];
    navigation.navigationBar.tintColor = [UIColor blackColor];
    navigation.navigationBar.barStyle = UIBarStyleDefault;
    navigation.navigationBar.translucent = YES;

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = navigation;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
