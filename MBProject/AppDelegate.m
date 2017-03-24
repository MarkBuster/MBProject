//
//  AppDelegate.m
//  MBProject
//
//  Created by yindongbo on 17/3/24.
//  Copyright © 2017年 Dombo. All rights reserved.
//

#import "AppDelegate.h"
#import "NavigationController.h"
#import "MainListViewController.h"
#import "MapViewController.h"
#import "ToolViewController.h"
@interface AppDelegate ()<
UITabBarControllerDelegate
>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    MainListViewController *mainListVC =[MainListViewController new];
    
    
    NavigationController *nav1 = [[NavigationController alloc] initWithRootViewController:mainListVC];
    nav1.tabBarItemTitle = @"mainList";
    nav1.tabBarItemSeletectedImageName =@"";
    nav1.tabBarItemUnSeletectedImageName = @"";
    
    MapViewController *mapVC =[MapViewController new];
    NavigationController *nav2 = [[NavigationController alloc] initWithRootViewController:mapVC];
    nav2.tabBarItemTitle = @"mapVC";
    nav2.tabBarItemSeletectedImageName =@"";
    nav2.tabBarItemUnSeletectedImageName = @"";
    
    ToolViewController *toolVC =[ToolViewController new];
    NavigationController *nav3 =[[NavigationController alloc] initWithRootViewController:toolVC];
    nav3.tabBarItemTitle = @"toolVC";
    nav3.tabBarItemSeletectedImageName =@"";
    nav3.tabBarItemUnSeletectedImageName = @"";
    
    NavigationController *nav4 =[[NavigationController alloc] initWithRootViewController:[UIViewController new]];
    nav4.tabBarItemTitle = @"empty";
    nav4.tabBarItemSeletectedImageName =@"";
    nav4.tabBarItemUnSeletectedImageName = @"";
    
    UITabBarController *tabbarController = [UITabBarController new];
    tabbarController.viewControllers = @[nav1, nav2,nav3,nav4];
    [tabbarController.tabBar setBackgroundImage:[UIColor whiteColor].image];
    tabbarController.selectedIndex = 0;
    tabbarController.delegate = self;
    self.window.rootViewController = tabbarController;
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
