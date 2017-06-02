//
//  MBXMPPMessageModule.h
//  MBProject
//
//  Created by yindongbo on 2017/5/27.
//  Copyright © 2017年 Dombo. All rights reserved.
//

#import <XMPPFramework/XMPPFramework.h>

typedef enum : NSUInteger {
    MBMessageStatusSending,
    MBMessageStatusSendSuccess,
    MBMessageStatusSendFail,
    MBMessageStatusReceived,
    MBMessageStatusReceivedRead
} MBMessageStatus;

/**
 body 里的取值
 */
NSString *const MBReceivedBody= @"0";
NSString *const MBChatBody= @"1";
NSString *const MBGroupBody= @"2";
NSString *const MBNotifyBody= @"3";
NSString *const MBTokenBody= @"4";
NSString *const MBPublicBody= @"5";
NSString *const MBBrodcastBody= @"6";
NSString *const MBNormalBody= @"7";//通用的消息协议


/**
 type 里的取值
 */
NSString *const MBTextType= @"1";
NSString *const MBAudioType= @"2";
NSString *const MBImgType= @"3";
NSString *const MBLocationType= @"4";
NSString *const MBJSONType= @"5";
NSString *const MBCreateType= @"6";
NSString *const MBInviteType= @"7";
NSString *const MBQuitType= @"8";
NSString *const MBKickType= @"9";
NSString *const MBDismissType= @"10";
NSString *const MBUpdateType= @"11";
NSString *const MBNotifyType= @"12";
NSString *const MBWebqiutType= @"13";
NSString *const MBAddTokenType= @"14"; //token 添加
NSString *const MBDelTokenType= @"15";//token 删除
NSString *const MBCommandType= @"16";
NSString *const MBMenuType= @"17";
NSString *const MBVerifyType= @"18";
NSString *const MBVerifiedType= @"19";
NSString *const MBDelType= @"20";
NSString *const MBCricleDynamicType= @"21";
NSString *const MBErrorType= @"50";


static NSString *const  msg= @"msg";
static NSString *const  CREATE = @"create";
static NSString *const  INVITE = @"invite";
static NSString *const  KICK= @"kick";
static NSString *const  QUIT = @"quit";
static NSString *const  DISMISS = @"dismiss";
static NSString *const  COMMMAND = @"command";
static NSString *const  UPDATE = @"update";
static NSString *const  ERROR = @"error";
static NSString *const  WEBQuit= @"webQuit";
static NSString *const  iSOwn= @"true";
static NSString *const  VerifyUser= @"verifyuser";
static NSString *const  VERified=@"verified";
static NSString *const  Delfriend= @"delfriend";
static NSString *const  MENU = @"menu";
static NSString *const  NOTIFY = @"notify";
static NSString *const  ADDToken = @"add";
static NSString *const  DelToken = @"delete";

static NSString *const  TEXT = @"text";
static NSString *const  IMG = @"img";
static NSString *const  AUDIO = @"audio";
static NSString *const  LOCATION = @"location";
static NSString *const  JSONSTR = @"json";


@interface MBXMPPMessageModule : XMPPModule

@end
