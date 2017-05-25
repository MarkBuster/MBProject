//
//  NavigationController.m
//  MasonryTest
//
//  Created by yindongbo on 17/3/24.
//  Copyright © 2017年 ydb. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
        self.delegate = self;
    }
    UIImage *image = nil;
    if (kiOS7Later) {
        image =[UIColor whiteColor].image;
    } else {
        image =[UIColor whiteColor].image;
        
    }
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

- (void)setTabBarItemTitle:(NSString *)tabBarItemTitle
{
    _tabBarItemTitle = tabBarItemTitle;
    [self.tabBarItem setTitle:_tabBarItemTitle];
    [self.tabBarItem setTitleTextAttributes:@{UITextAttributeTextColor:kORANGE_LINE_COLOR} forState:UIControlStateSelected];
}

- (void)setTabBarItemSeletectedImageName:(NSString *)tabBarItemSeletectedImageName
{
    _tabBarItemSeletectedImageName = tabBarItemSeletectedImageName;
    [self configTabBarImage];
}

- (void)setTabBarItemUnSeletectedImageName:(NSString *)tabBarItemUnSeletectedImageName
{
    _tabBarItemUnSeletectedImageName = tabBarItemUnSeletectedImageName;
    [self configTabBarImage];
}

- (void)configTabBarImage
{
    if (kiOS7Later) {
        self.tabBarItem.selectedImage=[[UIImage imageNamed:_tabBarItemSeletectedImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.image=[[UIImage imageNamed:_tabBarItemUnSeletectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }else {
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:_tabBarItemSeletectedImageName] withFinishedUnselectedImage:[UIImage imageNamed:_tabBarItemUnSeletectedImageName]];
    }
}

#pragma mark - UINavigationControllerDelegate
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if([self.viewControllers objectAtIndex:0]==viewController){
            self.interactivePopGestureRecognizer.enabled = NO;
        }else {
            self.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








//MainViewController *mainVC =[[MainViewController alloc] init];
//NavigationController *nav1 =[[NavigationController alloc] initWithRootViewController:mainVC];
//NavigationController *nav2 =[[NavigationController alloc] initWithRootViewController:[UIViewController new]];
//NavigationController *nav3 =[[NavigationController alloc] initWithRootViewController:[UIViewController new]];
//NavigationController *nav4 =[[NavigationController alloc] initWithRootViewController:[UIViewController new]];
//
//nav1.tabBarItemSeletectedImageName = @"chatSelect";
//nav1.tabBarItemUnSeletectedImageName = @"chat";
//nav1.tabBarItemTitle = NSLocalizedString(@"Chat", nil);
//
//nav2.tabBarItemSeletectedImageName = @"contactsSelect";
//nav2.tabBarItemUnSeletectedImageName = @"contacts";
//nav2.tabBarItemTitle = NSLocalizedString(@"Circle", @"Circle");
//
//nav3.tabBarItemSeletectedImageName = @"publicAccountSelect";
//nav3.tabBarItemUnSeletectedImageName = @"publicAccount";
//nav3.tabBarItemTitle = NSLocalizedString(@"Server", nil);
//
//nav4.tabBarItemSeletectedImageName = @"mineSelect";
//nav4.tabBarItemUnSeletectedImageName = @"mine";
//nav4.tabBarItemTitle = NSLocalizedString(@"Mine", nil);
//
//UITabBarController *tabarController=[[UITabBarController alloc] init];
//tabarController.viewControllers = @[nav1,nav2,nav3,nav4];
//[tabarController.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar"]];
//tabarController.selectedIndex = 0;
//tabarController.delegate = self;
//self.window.rootViewController = tabarController;
@end
