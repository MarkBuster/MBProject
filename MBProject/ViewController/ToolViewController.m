//
//  ToolViewController.m
//  MBProject
//
//  Created by yindongbo on 17/3/24.
//  Copyright © 2017年 Dombo. All rights reserved.
//

#import "ToolViewController.h"
#import "AViewController.h"
@interface ToolViewController ()

@end

@implementation ToolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ToolVC";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake( 100, 100, 100, 100);
    [self.view addSubview:btn];
    [btn setBackgroundColor:[UIColor brownColor]];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)click {
    AViewController *Avc = [[AViewController alloc] init];
    [self.navigationController pushViewController:Avc animated:YES];
}
 

@end
