//
//  MapViewController.m
//  MBProject
//
//  Created by yindongbo on 17/3/24.
//  Copyright © 2017年 Dombo. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"MapVC";
    
    
    for (NSInteger i = 0; i <9; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 200 - (i*10), 200- (i*10))];
        view.backgroundColor = [MBToolsManager randomColor];
        [self.view addSubview:view];
    }
    
    NSLog(@"dig view %@",[MBToolsManager digView:self.view]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
