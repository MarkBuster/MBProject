//
//  BaseViewController.h
//  MasonryTest
//
//  Created by yindongbo on 17/3/24.
//  Copyright © 2017年 ydb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
{
    UIButton *_navigationLeftBtn;
    UIButton * _navigationRightBtn;
}


#pragma mark - 控制方法

/*!
 @abstract 显示提示语
 @function showAlertViewWithContent:(NSString *)alertString
 @param alertString 提示语内容
 */
- (void)showAlertViewWithContent:(NSString *)alertString;

/*!
 @abstract 显示过程提示
 @function showActivityAlertViewWithContent:(NSString *)alertString;
 @param alertString 提示语内容
 */
- (void)showActivityAlertViewWithContent:(NSString *)alertString;

/*!
 @abstract 隐藏提示
 @function hideAlertView
 */
- (void)hideAlertView;


/*!
 @abstract 添加导航栏左按钮
 @function addNavigationLeftBtnWithImageName:(NSString *)imageName
 @param imageName 左按钮图片的名字，如果为空则默认为返回图片
 */
- (void)addNavigationLeftBtnWithImageName:(NSString *)imageName;

- (void)addNavigationLeftBtnWithName:(NSString *)name;

/*!
 @abstract 添加导航栏右按钮
 @function addNavigationRightBtnWithImageName:(NSString *)imageName
 @param imageName 右按钮图片的名字，如果为空则默认为没有添加右按钮
 */
- (void)addNavigationRightBtnWithImageName:(NSString *)imageName;

/*!
 @abstract 添加多个导航栏右按钮
 @function addNavigationRightBtnWithImagesName:(NSArray *)imageNameArray;
 @param imageNameArray 右按钮图片的名字，如果为空则默认为没有添加右按钮
 */
- (void)addNavigationRightBtnWithImagesName:(NSArray *)imageNameArray;

/*!
 @abstract 添加导航栏右按钮
 @function addNavigationRightBtnWithName:(NSString *)name
 @param name 右按钮显示名字，如果为空则默认为没有添加右按钮
 */
- (void)addNavigationRightBtnWithName:(NSString *)name;

/*!
 @abstract 左按钮点击事件
 @function navigationLeftBtnClick
 */
- (void)navigationLeftBtnClick;

/*!
 @abstract 右按钮点击事件
 @function navigationRightBtnClick
 */
- (void)navigationRightBtnClick;


/*!
 @abstract 左多个按钮
 @function navigationLeftBtnClick
 */
- (void)navigationLeftBtnClick:(NSInteger)index;
@end
