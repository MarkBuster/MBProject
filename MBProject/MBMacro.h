//
//  MBMacro.h
//  MBProject
//
//  Created by yindongbo on 17/3/24.
//  Copyright © 2017年 Dombo. All rights reserved.
//
// 业务相关宏
//
#ifndef MBMacro_h
#define MBMacro_h

// =================== NSUserDefaults ============================
#define kUserName   @"userName"
#define kUserPsw    @"userPsw"
#define kToken      @"token"



#define kXMLNS    @"www.nxin.com"
#define kXMLNode    @"nxin"
// =================== OpenFire ============================
#define kOpenFireDomain @"im.t.nxin.com"
#define kOpenFireResouce    @"DBN_IOS"

#define kAppDelegate_PushToMainVC   @"kAppDelegate_PushToMainVC"


// =================== NotificationCenter ===================
#define MESSEAGE_SEND_OPENFIRE_SUCCESE  @"MESSEAGE_SEND_OPENFIRE_SUCCESE"

//错误群操作
#define ERROR_GROUP_MSG @"ERROR_GROUP_MSG"

//获取陌生人的详细信息
#define GET_NEW_USERINFO @"GET_NEW_USERINFO"

//获取群头像
#define UPDATE_GROUP_ICON  @"UPDATE_GROUP_ICON"

//接收好友请求通知
#define ReceiveFriendRequestNotification @"receiveFriendRequestNotification"

//删除好友通知
#define DeleteFriendRequestNotification @"deleteFriendRequestNotification"

//账号在另一设备登录，本设备收到退出通知
#define LOGOUT_MESSAGE_INFO @"LOGOUT_MESSAGE_INFO"

//收到账号在web客户端退出的通知
#define WEB_QUIT_MESSAGE_INFO  @"WEB_QUIT_MESSAGE_INFO"

#endif /* MBMacro_h */
