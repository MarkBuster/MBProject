//
//  XMPPMessageModule.m
//  MBProject
//
//  Created by yindongbo on 2017/5/25.
//  Copyright © 2017年 Dombo. All rights reserved.
//

// 公用
#define kMessageDictionaryKeyID         @"_id"
#define kMessageDictionaryKeyFrom       @"_from"
#define kMessageDictionaryKeyTo         @"_to"
#define kMessageDictionaryKeyBody       @"body"

// 单聊
#define kMessageDictionaryKeyType       @"_type"
#define kMessageDictionaryKeyContent    @"_content"
#define kMessageDictionaryKeyProperty   @"_property"
#define kMessageDictionaryKeyUrl        @"_url"
#define kMessageDictionaryKeyLatitude   @"_lat"
#define kMessageDictionaryKeyLongitude  @"_lng"
#define kMessageDictionaryKeyIsOwn      @"_isOwn"
#define kMessageDictionaryKeyExtra      @"_extra"
#define kMessageDictionaryKeyIsJoined   @"_isJoined"
#define kMessageDictionaryKeySize       @"_size"
#define kMessageDictionaryKeyHWRatio    @"_ratio"

// 群组的
#define kMessageDictionaryKeyFromJID    @"_fromJID"
#define kMessageDictionaryKeyToJID      @"_toJID"
#define kMessageDictionaryKeyTopic      @"_topic"
#define kMessageDictionaryKeyRoomID     @"_roomId"
#define kMessageDictionaryKeyRoomIcon   @"_roomIcon"
#define kMessageDictionaryKeyMemberName @"_memberName"
#define kMessageDictionaryKeyMemberIcon @"_memberIcon"

// 公共信息
#define kMessageDictionaryKeyDeviceID   @"_deviceId"
#define kMessageDictionaryKeySource     @"_v_source"
#define kMessageDictionaryKeyToken      @"_token"
#define kMessageDictionaryKeyPublicID   @"_publicId"
#define kMessageDictionaryKeyExtra      @"_extra"

// 离线消息
#define kMessageDictionaryKeyDelay      @"delay"
#define kMessageDictionaryKeyStamp      @"_stamp"

#define kXMLNSKey                       @"_xmlns"

#define DelayMessageEachGroupNumber     100


#import "XMPPMessageModule.h"
#import "NSXMLElement+XEP_0203.h"
#import <XMLDictionary.h>

@implementation XMPPMessageModule


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
        [self saveMessage:message xmppStream:sender withType:MBMessageStatusReceived];
        NSLog(@"消息接收");
    }
}

- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
    NSLog(@"OPEN FIRE SEND MESSAGE:\n%@",[message XMLString]);
    [self saveMessage:message xmppStream:sender withType:MBMessageStatusSending];
}

#pragma mark - CustomMethod 
- (void)saveMessage:(XMPPMessage *)message xmppStream:(XMPPStream *)stream withType:(MBMessageStatus)type
{
    NSDictionary * messageDic = [NSDictionary dictionaryWithXMLString:message.XMLString];

    if ([message isErrorMessage]) {
        NSLog(@"消息出错");
        return;
    }
    
    // 验证消息的合法性
    if ([[[messageDic objectForKey:kXMLNode] objectForKey:kXMLNSKey] isEqualToString:kXMLNS]) {
        NSString *myJIDUser = xmppStream.myJID.user; // 登录者jid 节点
        NSString *bodyValue = [message body];   // body 的值
        NSXMLElement *xmlElement = [message elementForName:kXMLNode xmlns:kXMLNS]; // XML节点
        NSXMLElement *mXmlElement = [xmlElement elementForName:@"m"];// m 节点
        NSString *mType = [mXmlElement attributeStringValueForName:@"type"];// type属性值
        NSString *mId = [mXmlElement attributeStringValueForName:@"id"];// m节点 id 属性值
        
        if (type == MBMessageStatusSending) {
            // 发送消息
        }else {
            // 接受消息给回执（服务器给的回执不管）
            if ([bodyValue isEqualToString:MBReceivedBody]) {
                [self sendHuizhiMessage:message xmppStream:stream]; // 接受的回执消息ID
            }
            
            if ([bodyValue isEqualToString:MBReceivedBody])
            {
                [self messageHuiZhimid:mId mType:mType]; // 各类型消息回执处理
            }
            else if ([bodyValue isEqualToString:MBNotifyBody])
            {
                NSString *msg_deviceId = [xmlElement attributeStringValueForName:@"deviceId"];
                NSString *msg_content = [xmlElement attributeStringValueForName:@"content"];
                NSString *msg_barJidStr = [message from].user;
                
                if ([MBKickType isEqualToString:mType]) {
                    if (![msg_deviceId isEqualToString:[Tools uniqueDeviceIdentifier]]) {
                        [kMBNotificationCetner postNotificationName:LOGOUT_MESSAGE_INFO object:msg_content];
                    }
                }
                else if ([MBVerifyType isEqualToString:mType]) {
                    [kMBNotificationCetner postNotificationName:ReceiveFriendRequestNotification object:msg_content];
                }
                else if ([MBVerifyType isEqualToString:mType])
                {
                    [kMBNotificationCetner postNotificationName:DeleteFriendRequestNotification object:msg_barJidStr];
                }
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
                
                NSString *msg_type = [self mType2DBType:mType]; // 消息操作类型
                NSString *msg_msgType = [self mType2MsgType:mType]; // 消息内容类型（图片、音频、定位、文本、图片）
                
                if ([msg_type isEqualToString:ERROR]) {
                    NSDictionary *dic = @{@"type":msg_type,@"msg_content":msg_content};
                    [kMBNotificationCetner postNotificationName:GET_NEW_USERINFO object:DISMISS];
                    return;
                }
                
                if ([fromJID isEqualToString:msg_streamBarJidStr]) {
//                     本人收到自己发送的消息回执
                    if ([msg_type isEqualToString:UPDATE]||
                        [msg_type isEqualToString:INVITE]||
                        [msg_type isEqualToString:KICK]||
                        [msg_type isEqualToString:msg]) {
                        if ([msg_type isEqualToString:INVITE]) {
                            // (邀请类型)
//                             根据 msg_roomid 在数据库中查找 群组信息
//                            如果查不到则，将 fromJID & msg_roomid & toomtopic & roomIcon 存入数据库，新建群组信息
                        }else {
                            NSDictionary *dic = @{@"roomId":msg_roomid,@"roomtopic":roomtopic};
                            [kMBNotificationCetner postNotificationName:UPDATE_GROUP_ICON object:dic];
                        }
                        
                        // 群聊消息 插入数据库
                    } else if ([msg_type isEqualToString:DISMISS]) {
                        //[db delegateMessageFromRoomId:msg_roomid StreamBareJidStr:msg_streamBarJidStr];
                    } else if ([msg_type isEqualToString:QUIT]) {
                         //[db delegateMessageFromRoomId:msg_roomid StreamBareJidStr:msg_streamBarJidStr];
                    }
                    // 创建群组 传递 roomid、msgid、roomIcon、toomtopic
                }else {
//                    本人接收到他人发送的消息
                    if ([msg_type isEqualToString:INVITE]) {
//                    根据roomid 查找数据库，判断本地是否有群
//                        如果没有群则保存 fromJid & msg_roomid & roomtopic & roomIcon 在数据库中新建群
//                        发送 将roomid 发送通知 ，请求拉取群成员信息数据
                    }
                    else if ([msg_type isEqualToString:QUIT])
                    {
//                        别人退群  根据formJid 和 msg_roomid 将查到的群组进行 该人删除，更新群数据
                        return;
                    }
                    else if ([msg_type isEqualToString:DISMISS])
                    {
//                         群解散
//                        根据roomid & streamBarJidStr 删除消息列表
//                        根据roomId 删除群数据，解散群
//                        根据roomId 删除群成员信息
                    }
                    else if ([msg_type isEqualToString:KICK])
                    {
                        NSString *toJID = [xmlElement attributeStringValueForName:@"toJID"];
                        if ([toJID isEqualToString:msg_streamBarJidStr]) {
//                            根据 msg_roomid & msg_streamBarJidStr 删除列表消息
//                            根据roomid 删除 房间
//                            删除群聊消息
                            return;
                        }else {
//                            别人被踢
//                            更新群信息
                        }
                    }
                    else if ([msg_type isEqualToString:UPDATE])
                    {
//                        根据 roomid & roomtopic 更新群名称
                    }
                    
//                    如果群不存在则，插入群信息 fromJid & msg_roomid & roomtopic & roomIcon
                    
//                    将mXmlElement 解析赋值 插入数据库中 
                }
            }
            else if ([bodyValue isEqualToString:MBPublicBody])
            {
                //公众号 数据库添加数据
            }
            else if ([bodyValue isEqualToString:MBNormalBody])
            {
                NSString *msg_content = [xmlElement attributeStringValueForName:@"content"];
                NSString *msg_barJidStr = [message from].user;
                
                if ([MBVerifyType isEqualToString:mType]) {
                    [kMBNotificationCetner postNotificationName:ReceiveFriendRequestNotification object:msg_content];
                }
                else if ([MBVerifyType isEqualToString:mType])
                {
                    [kMBNotificationCetner postNotificationName:DeleteFriendRequestNotification object:msg_barJidStr];
                }
                else if ([MBVerifyType isEqualToString:mType])
                {
                    // 插入到单聊中
                    NSString *msg_msgid = [message attributeStringValueForName:@"id"];
                    NSString *msg_streamBarJidStr = [message to].user;
//                    获取新用户信息
                    NSString *msg_extra = [mXmlElement attributeStringValueForName:@"extra"];
                    [kMBNotificationCetner postNotificationName:GET_NEW_USERINFO object:msg_extra];// 根据extra 请求服务器获取用户信息
                    
                    NSString *msg_msgType = [self mType2DBType:mType];
                    NSDate *timestamp = [message delayedDeliveryDate];
                    
                    // 判断是不是离线消息
                    if (!timestamp) {
                        timestamp = [[NSDate alloc] init];
                    }
//                    数据库数据新建& 插入
                    
                }
                else if ([MBVerifyType isEqualToString:mType]) {
                    [kMBNotificationCetner postNotificationName:ReceiveFriendRequestNotification object:msg_content];
                }
                else if ([MBVerifyType isEqualToString:mType])
                {
                    [kMBNotificationCetner postNotificationName:DeleteFriendRequestNotification object:msg_barJidStr];
                }
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

- (void)messageHuiZhimid:(NSString *)mId mType:(NSString *)mType {
    // 接受的回执消息ID
    dispatch_async(dispatch_get_main_queue(), ^{
        [kMBNotificationCetner postNotificationName:MESSEAGE_SEND_OPENFIRE_SUCCESE object:mId];
    });
 
    //             =====================回执更新========================
    if ([mType isEqualToString:MBChatBody]) {
        // 单聊 根据回执ID更新数据库
    }else if ([mType isEqualToString:MBGroupBody]){
        // 群聊 根据回执ID更新数据库
    }else if ([mType isEqualToString:MBPublicBody]) {
        //公众号 根据回执ID更新数据库
    }
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

- (NSString *)mType2DBType:(NSString *)mType{
    if ([MBTextType isEqualToString:mType]||[MBAudioType isEqualToString:mType]||[MBImgType isEqualToString:mType]||[MBLocationType isEqualToString:mType]||[MBJSONType isEqualToString:mType]) {
        return msg;
    }else if([MBCreateType isEqualToString:mType]){
        return CREATE;
    }else if([MBInviteType isEqualToString:mType]){
        return INVITE;
    }else if([MBQuitType isEqualToString:mType]){
        return QUIT;
    }else if([MBKickType isEqualToString:mType]){
        return KICK;
    }else if([MBDismissType isEqualToString:mType]){
        return DISMISS;
    }else if([MBUpdateType isEqualToString:mType]){
        return UPDATE;
    }else if([MBNotifyType isEqualToString:mType]){
        return  NOTIFY;
    }else if([MBWebqiutType isEqualToString:mType]){
        return WEBQuit;
    }else if([MBAddTokenType isEqualToString:mType]){
        return ADDToken;
    }else if([MBDelTokenType  isEqualToString:mType]){
        return DelToken;
    }else if([MBCommandType isEqualToString:mType]){
        return COMMMAND;
    }else if([MBMenuType isEqualToString:mType]){
        return MENU;
    }else if([MBVerifyType isEqualToString:mType]){
        return VerifyUser;
    }else if([MBVerifiedType isEqualToString:mType]){
        return VERified;
    }else if([MBDelType isEqualToString:mType]){
        return  Delfriend;
    }else if([MBErrorType  isEqualToString:mType]){
        return  ERROR;
    }
    return nil;
}

- (NSString *)mType2MsgType:(NSString *)mType{
    if ([MBTextType isEqualToString:mType]) {
        return TEXT;
    }else if([MBAudioType isEqualToString:mType]){
        return  AUDIO;
    }else if([MBImgType isEqualToString:mType]){
        return IMG;
    }else if([MBLocationType isEqualToString:mType]){
        return LOCATION;
    }else if([MBJSONType isEqualToString:mType]){
        return JSONSTR;
    }
    return nil;
    
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
@end
