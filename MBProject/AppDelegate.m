//
//  AppDelegate.m
//  MBProject
//
//  Created by yindongbo on 17/3/24.
//  Copyright © 2017年 Dombo. All rights reserved.
//

#import "AppDelegate.h"
#import "NavigationController.h"
#import "MessageListViewController.h"
#import "MapViewController.h"
#import "ToolViewController.h"
#import "LoginViewController.h"

#import "XMPPManager.h"
@interface AppDelegate ()<
UITabBarControllerDelegate
>

@property (nonatomic, strong) NavigationController *tempNav;
@end

@implementation AppDelegate

/**
 即时通讯
 发帖评论
 地图
 其他（直播、音频）
 */
 
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    
    if ([kMBUserDefaults valueForKey:kUserName]) {
//         进入主界面
        [self pushToMainVC];
    }else {
//        登录界面
        [self pushToLoginVC];
    }
    
    [kMBNotificationCetner addObserver:self selector:@selector(pushToMainVC) name:kAppDelegate_PushToMainVC object:nil];
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


#pragma mark - CustomMethod
- (void)pushToLoginVC {
    if (!_tempNav) {
        LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        _tempNav = [[NavigationController alloc] initWithRootViewController:loginVC];
    }
    self.window.rootViewController = _tempNav;
}

- (void)pushToMainVC {
    
    [[XMPPManager sharedManager] connect];
    
    MessageListViewController *mainListVC =[MessageListViewController new];
    NavigationController *nav1 = [[NavigationController alloc] initWithRootViewController:mainListVC];
    nav1.tabBarItemTitle = @"mainList";
    nav1.tabBarItemSeletectedImageName =@"icon_tababr_chat_select";
    nav1.tabBarItemUnSeletectedImageName = @"icon_tababr_chat_normal";
    
    MapViewController *mapVC =[MapViewController new];
    NavigationController *nav2 = [[NavigationController alloc] initWithRootViewController:mapVC];
    nav2.tabBarItemTitle = @"mapVC";
    nav2.tabBarItemSeletectedImageName =@"icon_tababr_publicAccount_select";
    nav2.tabBarItemUnSeletectedImageName = @"icon_tababr_publicAccount_normal";
    
    ToolViewController *toolVC =[ToolViewController new];
    NavigationController *nav3 =[[NavigationController alloc] initWithRootViewController:toolVC];
    nav3.tabBarItemTitle = @"toolVC";
    nav3.tabBarItemSeletectedImageName =@"icon_tababr_Undefine_Xnet_select";
    nav3.tabBarItemUnSeletectedImageName = @"icon_tababr_Undefine_Xnet_normal";
    
    NavigationController *nav4 =[[NavigationController alloc] initWithRootViewController:[UIViewController new]];
    nav4.tabBarItemTitle = @"empty";
    nav4.tabBarItemSeletectedImageName =@"icon_tababr_mine_select";
    nav4.tabBarItemUnSeletectedImageName = @"icon_tababr_mine_normal";
    
    UITabBarController *tabbarController = [UITabBarController new];
    tabbarController.viewControllers = @[nav1, nav2,nav3,nav4];
    [tabbarController.tabBar setBackgroundImage:[UIColor whiteColor].image];
    tabbarController.selectedIndex = 0;
    tabbarController.delegate = self;
    self.window.rootViewController = tabbarController;
    _tempNav = nil;
}

@end
