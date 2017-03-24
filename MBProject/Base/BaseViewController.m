//
//  BaseViewController.m
//  MasonryTest
//
//  Created by yindongbo on 17/3/24.
//  Copyright © 2017年 ydb. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end




@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kiOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self createNavigationBarUI];
    self.view.backgroundColor =[UIColor whiteColor];
}


- (void)createNavigationBarUI {
    _navigationLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _navigationLeftBtn.frame = CGRectMake(0, 0, 40, 30);//点击区域比较合适
    // [_navigationLeftBtn setImageEdgeInsets: UIEdgeInsetsMake(0.0, -10, 0.0, 25)];
    [_navigationLeftBtn setTitleColor:kNavigationBarLeftAndRightColor forState:UIControlStateNormal];
    [_navigationLeftBtn addTarget:self action:@selector(navigationLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    NSDictionary *dict =@{UITextAttributeTextColor:kNavigationBarTitleColor,
                          UITextAttributeFont:kViewControllerTitleTextFont};
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    _navigationRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _navigationRightBtn.frame = CGRectMake(0, 0, 60, 44);
    _navigationRightBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    _navigationRightBtn.titleLabel.font =kThirdLevelFont;
    [_navigationRightBtn setTitleColor:kNavigationBarLeftAndRightColor forState:UIControlStateNormal];
    [_navigationRightBtn addTarget:self action:@selector(navigationRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - Method
- (void)setTitle:(NSString *)title {
    self.navigationItem.title = title;
}

- (void)showAlertViewWithContent:(NSString *)alertString {
    if ([alertString length]>0) {
    }
}


- (void)showActivityAlertViewWithContent:(NSString *)alertString {
    if ([alertString length]>0) {
    }
}

- (void)hideAlertView {
}


- (void)addNavigationLeftBtnWithImageName:(NSString *)imageName {
    [_navigationLeftBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    //给leftBarButtonItems 加上一个透明的Item 占位，目的是让leftBarButtonItem 可点击区域正常（_navigationLeftBtn 统一）
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithCustomView:_navigationLeftBtn],item1,nil];
}

- (void)addNavigationLeftBtnWithName:(NSString *)name {
    if([name length]>0) {
        _navigationLeftBtn.frame = CGRectMake(0, 0, 60, 44);
        [_navigationLeftBtn setTitle:name forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_navigationLeftBtn];
    }
}

- (void)addNavigationRightBtnWithImageName:(NSString *)imageName {
    if([imageName length]>0) {
        [_navigationRightBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_navigationRightBtn];
    }
}

- (void)addNavigationRightBtnWithImagesName:(NSArray *)imageNameArray {
    if(imageNameArray.count > 0) {
        NSMutableArray * rightBarButtonArray = [[NSMutableArray alloc] init];
        NSInteger i = 0;
        for (NSString * imageName in imageNameArray) {
            UIButton * navigationRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            navigationRightBtn.tag = i;
            [navigationRightBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            [navigationRightBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
            navigationRightBtn.frame = CGRectMake(0, 0, 44, 44);
            navigationRightBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
            navigationRightBtn.titleLabel.font =kThirdLevelFont;
            [navigationRightBtn setTitleColor:kNavigationBarLeftAndRightColor forState:UIControlStateNormal];
            
            [navigationRightBtn addTarget:self action:@selector(navigationLeftBtnClickBtn:) forControlEvents:UIControlEventTouchUpInside];
            i++;
            [rightBarButtonArray addObject:[[UIBarButtonItem alloc] initWithCustomView:navigationRightBtn]];
        }
        self.navigationItem.rightBarButtonItems = rightBarButtonArray;
    }
}

- (void)addNavigationRightBtnWithName:(NSString *)name {
    if([name length]>0) {
        [_navigationRightBtn setTitle:name forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_navigationRightBtn];
    }
}

//子类根据需要来重写方法默认是返回操作
- (void)navigationLeftBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationLeftBtnClickBtn:(UIButton *)sender {
    [self navigationLeftBtnClick:sender.tag];
}

#pragma mark - Rewrite
//子类根据需要来重写方法
- (void)navigationRightBtnClick {
}

//子类需要重写方法来响应相应的逻辑
- (void)navigationLeftBtnClick:(NSInteger)index {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
