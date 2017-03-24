//
//  NavigationController.h
//  MasonryTest
//
//  Created by yindongbo on 17/3/24.
//  Copyright © 2017年 ydb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationController : UINavigationController<
UINavigationControllerDelegate,
UIGestureRecognizerDelegate
>

@property (nonatomic,copy) NSString * tabBarItemSeletectedImageName;
@property (nonatomic,copy) NSString * tabBarItemUnSeletectedImageName;
@property (nonatomic,copy) NSString * tabBarItemTitle;

@end
