//
//  XMPPManager.h
//  MBProject
//
//  Created by yindongbo on 2017/5/25.
//  Copyright © 2017年 Dombo. All rights reserved.
//

//com.Dombo.MBProject


#import <Foundation/Foundation.h>

@interface MBXMPPManager : NSObject<
UIApplicationDelegate
>

+ (MBXMPPManager *)sharedManager;

#pragma mark -------连接相关-----------
- (BOOL)connect;
- (void)disconnect;

#pragma mark -------配置XML流-----------
- (void)setupStream;
- (void)teardownStream;


#pragma mark ----------登录退出------------
- (void)goOnline;
- (void)goOffline;

@end
