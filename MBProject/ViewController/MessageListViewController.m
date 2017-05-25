//
//  MessageListViewController.m
//  MBProject
//
//  Created by yindongbo on 2017/5/25.
//  Copyright © 2017年 Dombo. All rights reserved.
//

#import "MessageListViewController.h"

@interface MessageListViewController ()<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MessageListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"MessageListViewController";
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LazyInit
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = ({
            UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
            footerView;
        });
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"%ld",indexPath.row);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
}
@end
