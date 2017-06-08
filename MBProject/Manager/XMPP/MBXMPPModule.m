//
//  MBXMPPModule.m
//  MBProject
//
//  Created by yindongbo on 2017/6/3.
//  Copyright © 2017年 Dombo. All rights reserved.
//

#import "MBXMPPModule.h"
#import "NSXMLElement+XEP_0203.h"
#import <XMLDictionary.h>

//// 公用
//#define kMessageDictionaryKeyID         @"_id"
//#define kMessageDictionaryKeyFrom       @"_from"
//#define kMessageDictionaryKeyTo         @"_to"
//#define kMessageDictionaryKeyBody       @"body"
//
//// 单聊
//#define kMessageDictionaryKeyType       @"_type"
//#define kMessageDictionaryKeyContent    @"_content"
//#define kMessageDictionaryKeyProperty   @"_property"
//#define kMessageDictionaryKeyUrl        @"_url"
//#define kMessageDictionaryKeyLatitude   @"_lat"
//#define kMessageDictionaryKeyLongitude  @"_lng"
//#define kMessageDictionaryKeyIsOwn      @"_isOwn"
//#define kMessageDictionaryKeyExtra      @"_extra"
//#define kMessageDictionaryKeyIsJoined   @"_isJoined"
//#define kMessageDictionaryKeySize       @"_size"
//#define kMessageDictionaryKeyHWRatio    @"_ratio"
//
//// 群组的
//#define kMessageDictionaryKeyFromJID    @"_fromJID"
//#define kMessageDictionaryKeyToJID      @"_toJID"
//#define kMessageDictionaryKeyTopic      @"_topic"
//#define kMessageDictionaryKeyRoomID     @"_roomId"
//#define kMessageDictionaryKeyRoomIcon   @"_roomIcon"
//#define kMessageDictionaryKeyMemberName @"_memberName"
//#define kMessageDictionaryKeyMemberIcon @"_memberIcon"
//
//// 公共信息
//#define kMessageDictionaryKeyDeviceID   @"_deviceId"
//#define kMessageDictionaryKeySource     @"_v_source"
//#define kMessageDictionaryKeyToken      @"_token"
//#define kMessageDictionaryKeyPublicID   @"_publicId"
//#define kMessageDictionaryKeyExtra      @"_extra"
//
//// 离线消息
//#define kMessageDictionaryKeyDelay      @"delay"
//#define kMessageDictionaryKeyStamp      @"_stamp"
//
#define kXMLNSKey                       @"_xmlns"
//
//#define DelayMessageEachGroupNumber     100

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
static NSString *const MBReceivedBody= @"0";
static NSString *const MBChatBody= @"1";
static NSString *const MBGroupBody= @"2";
static NSString *const MBNotifyBody= @"3";
static NSString *const MBTokenBody= @"4";
static NSString *const MBPublicBody= @"5";
static NSString *const MBBrodcastBody= @"6";
static NSString *const MBNormalBody= @"7";//通用的消息协议

//
//
///**
// type 里的取值
// */
//NSString *const MBTextType= @"1";
//NSString *const MBAudioType= @"2";
//NSString *const MBImgType= @"3";
//NSString *const MBLocationType= @"4";
//NSString *const MBJSONType= @"5";
//NSString *const MBCreateType= @"6";
//NSString *const MBInviteType= @"7";
//NSString *const MBQuitType= @"8";
//NSString *const MBKickType= @"9";
//NSString *const MBDismissType= @"10";
//NSString *const MBUpdateType= @"11";
//NSString *const MBNotifyType= @"12";
//NSString *const MBWebqiutType= @"13";
//NSString *const MBAddTokenType= @"14"; //token 添加
//NSString *const MBDelTokenType= @"15";//token 删除
//NSString *const MBCommandType= @"16";
//NSString *const MBMenuType= @"17";
//NSString *const MBVerifyType= @"18";
//NSString *const MBVerifiedType= @"19";
//NSString *const MBDelType= @"20";
//NSString *const MBCricleDynamicType= @"21";
//NSString *const MBErrorType= @"50";
//
//
//static NSString *const  msg= @"msg";
//static NSString *const  CREATE = @"create";
//static NSString *const  INVITE = @"invite";
//static NSString *const  KICK= @"kick";
//static NSString *const  QUIT = @"quit";
//static NSString *const  DISMISS = @"dismiss";
//static NSString *const  COMMMAND = @"command";
//static NSString *const  UPDATE = @"update";
//static NSString *const  ERROR = @"error";
//static NSString *const  WEBQuit= @"webQuit";
//static NSString *const  iSOwn= @"true";
//static NSString *const  VerifyUser= @"verifyuser";
//static NSString *const  VERified=@"verified";
//static NSString *const  Delfriend= @"delfriend";
//static NSString *const  MENU = @"menu";
//static NSString *const  NOTIFY = @"notify";
//static NSString *const  ADDToken = @"add";
//static NSString *const  DelToken = @"delete";
//
//static NSString *const  TEXT = @"text";
//static NSString *const  IMG = @"img";
//static NSString *const  AUDIO = @"audio";
//static NSString *const  LOCATION = @"location";
//static NSString *const  JSONSTR = @"json";

@implementation MBXMPPModule

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSLog(@"OPEN FIRE RECEIVED MESSAGE:\n%@",[message XMLString]);
    if ([message errorMessage])
    {
        // 错误的消息不处理
        return;
    }
    if ([message wasDelayed])
    {
        // 处理离线消息
        //        [self handleDelayedMessage:message];
        NSLog(@"离线消息处理");
    }
    else
    {
        NSLog(@"消息接收");
        [self saveMessage:message xmppStream:sender withType:MBMessageStatusReceived];
    }
}
//
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
    NSLog(@"OPEN FIRE SEND MESSAGE:\n%@",[message XMLString]);
    [self saveMessage:message xmppStream:sender withType:MBMessageStatusSending];
}

#pragma mark - CustomMethod
- (void)saveMessage:(XMPPMessage *)message xmppStream:(XMPPStream *)stream withType:(MBMessageStatus)type {
    
    NSDictionary * messageDic = [NSDictionary dictionaryWithXMLString:message.XMLString];
    
    if ([message isErrorMessage]) {
        NSLog(@"消息出错");
        return;
    }
    if ([[[messageDic objectForKey:kXMLNode] objectForKey:kXMLNSKey] isEqualToString:kXMLNS]) {
        NSString *myJIDUser = xmppStream.myJID.user; // 登录者jid 节点
        NSString *bodyValue = [message body];   // body 的值
        NSXMLElement *xmlElement = [message elementForName:kXMLNode xmlns:kXMLNS]; // XML节点
        NSXMLElement *mXmlElement = [xmlElement elementForName:@"m"];// m 节点
        NSString *mType = [mXmlElement attributeStringValueForName:@"type"];// type属性值
        NSString *mId = [mXmlElement attributeStringValueForName:@"id"];// m节点 id 属性值
        
        if (type == MBMessageStatusSending) {
            // 发送消息
        }
        else
        {
            // 接受消息给回执（服务器给的回执不管）
            if ([bodyValue isEqualToString:MBReceivedBody]) {
                [self sendHuizhiMessage:message xmppStream:stream]; // 接受的回执消息ID
            }
            else if ([bodyValue isEqualToString:MBChatBody])
            {
                [self singleChatMessage:message mXMLMessage:mXmlElement]; // 单聊 数据库添加数据
            }
            else if ([bodyValue isEqualToString:MBGroupBody])
            {
                // 群聊 根数据库添加数据
                NSString *fromJID = [mXmlElement attributeStringValueForName:@"fromJID"];
                NSString *msg_msgid = [message attributeStringValueForName:@"id"];
                NSString *msg_streamBarJidStr = xmppStream.myJID.user;
                NSString *msg_roomid = [mXmlElement attributeStringValueForName:@"roomId"];
                NSString *roomicon = [mXmlElement attributeStringValueForName:@"roomIcon"];
                NSString *roomtopic = [mXmlElement attributeStringValueForName:@"topic"];
                NSString *msg_content = [mXmlElement attributeStringValueForName:@"content"];
                
//                NSString *msg_type = [self mType2DBType:mType]; // 消息操作类型
//                NSString *msg_msgType = [self mType2MsgType:mType]; // 消息内容类型（图片、音频、定位、文本、图片）
                
            }
        }
    }
}

#pragma mark - CustomMethod
-(void)sendHuizhiMessage:(XMPPMessage *)message xmppStream:(XMPPStream *)stream{
    NSString *msg_msgid = [message attributeStringValueForName:@"id"];
    NSString *msgT_barJidStr = [message to].bare;
    XMPPMessage *xmppMessage = [[XMPPMessage alloc] init];
    
    [xmppMessage addAttributeWithName:@"id" stringValue:[Tools getXMPPMessageIDFromUUID]];
    [xmppMessage addBody:MBReceivedBody];
    [xmppMessage addAttributeWithName:@"to" stringValue:msgT_barJidStr];
    [xmppMessage addAttributeWithName:@"form" stringValue:msgT_barJidStr];
    [xmppMessage addAttributeWithName:@"type" stringValue:@"chat"];
    
    NSXMLElement *node = [NSXMLElement elementWithName:kXMLNode xmlns:kXMLNS];
    NSXMLElement *m =  [NSXMLElement elementWithName:@"m"];
    [m addAttributeWithName:@"id" stringValue:msg_msgid];
    [m addAttributeWithName:@"type" stringValue:[message body]];
    [node addChild:m];
    [xmppMessage addChild:node];
    [stream sendElement:xmppMessage];
}

#pragma mark - messageChat
- (void)singleChatMessage:(XMPPMessage *)message mXMLMessage:(NSXMLElement*)mXmlElement{
    NSString *msg_msgid = [message attributeStringValueForName:@"id"];
    
    //获得用户user
    NSString *msg_barJidStr =[message from].user;
    NSString *msg_streamBarJidStr =[message to].user;
    NSString *isJoin=[mXmlElement attributeStringValueForName:@"isJoined"];
    
    if ([isJoin isEqualToString:@"0"]) {
        // 陌生人
        NSString *msg_extra = [mXmlElement attributeStringValueForName:@"extra"];
        [self updateContactInfo:msg_barJidStr UserInfoDic:msg_extra];
    }else {
        // 好友 通过jid 查询用户是否在通讯录中 ()
        [self friendInfoUpdate:msg_barJidStr];
    }
    
    NSDate *timestamp = [message delayedDeliveryDate];
    
    if (!timestamp) { // 判断是否为离线消息
        timestamp = [[NSDate alloc] init];
    }
    
    // 数据插入数据库中
}

-(void)updateContactInfo:(NSString *)contactJID UserInfoDic:(NSString *)userInfoDic {
    NSError *error = nil;
    NSDictionary *jsonDic = [Tools dictionaryWithJsonString:userInfoDic];
    if ([jsonDic isKindOfClass:[NSDictionary class]]) {
        NSArray *keyArray = [jsonDic allKeys];
        NSDictionary *userInfoDic;
        if ([keyArray containsObject:@"oaUserInfo"]) {
            userInfoDic = [jsonDic objectForKey:@"oaUserInfo"];
            NSString *contacts_jid = contactJID;
            NSString *contacts_headICO = [[userInfoDic objectForKey:@"headerIcon"] description];
            NSString *contacts_archiveId = [[userInfoDic objectForKey:@"archiveId"] description];
            NSString *contacts_nickName = [[userInfoDic objectForKey:@"nickName"] description];
            NSString *contacts_isJoined = [[userInfoDic objectForKey:@"isJoined"] description];
            // 数据库根据 jid 更新 联系人信息
            //            [DB updata:model];
        }
    }
}

- (void)friendInfoUpdate:(NSString *)jid {
    //                    if msg_barJidStr 不在数据库中{
    // 将jid 发送给服务器，进行用户数据资料请求，请求回来更新用户信息, 都做用户数据库更新操作
    [kMBNotificationCetner postNotificationName:GET_NEW_USERINFO object:jid];
    //                }
}
@end
