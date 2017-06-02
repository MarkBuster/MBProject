//
//  XMPPManager.m
//  MBProject
//
//  Created by yindongbo on 2017/5/25.
//  Copyright © 2017年 Dombo. All rights reserved.
//

#import "MBXMPPManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import <XMPPPing.h>
#import <XMPPReconnect.h>
#import <XMPPStream.h>
#import <NSXMLElement+XEP_0203.h>

//#import "XMPPMessageModule.h"

@class XMPPMessageModule;
@interface MBXMPPManager()<
XMPPStreamDelegate
>{
    NSString *_password;//O_F 登录密码
    BOOL _isXmppConnected;//是否连接
    BOOL _allowSelfSignedCertificates;
    BOOL _allowSSLHostNameMismatch;
}

@property (nonatomic, strong) XMPPPing *xmppPing;
@property (nonatomic, strong) XMPPStream *xmppStream;
@property (nonatomic, strong) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong) XMPPMessageModule *xmppMessageModule;

@end

static MBXMPPManager *sharedManager = nil;
@implementation MBXMPPManager
+ (MBXMPPManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [MBXMPPManager new];
        [sharedManager setupStream];
    });
    return sharedManager;
}


- (void)setupStream {
    NSAssert(_xmppStream == nil, @"Method setupStream invoked multiple times");
    
    // 创建流
    _xmppStream = [[XMPPStream alloc] init];
#if !TARGET_IPHONE_SIMULATOR
    {
        //   设置后台也进行连接
        _xmppStream.enableBackgroundingOnSocket = YES;
    }
#endif
    // 创建XMPPStream重连
    _xmppReconnect = [[XMPPReconnect alloc] initWithDispatchQueue:dispatch_get_main_queue()];
    
    //创建XMPPStream 心跳
    _xmppPing = [[XMPPPing alloc] init];
    _xmppPing.respondsToQueries = YES;
    
    // 通讯录数据库容器
    // 消息数据库容器
//    _xmppMessageModule = [[XMPPMessageModule alloc] initWithDispatchQueue:dispatch_get_main_queue()];
//    [_xmppMessageModule activate:_xmppStream];
    // 消息处理
    
    // 激活xmpp 模块
    [_xmppReconnect activate:_xmppStream];
    [_xmppPing activate:_xmppStream];
//    [_xmppMessageModule activate:_xmppStream];
    
    
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [_xmppPing addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //xmppStream.autoStartTLS=YES;//使用安全验证登录
    [_xmppStream setHostName:kOpenFireDomain];
    [_xmppStream setHostPort:5222];// 一般用的都是5222
    
    _allowSelfSignedCertificates = YES;
    _allowSSLHostNameMismatch =YES;
}


- (void)teardownStream {
    [_xmppStream removeDelegate:self];
    [_xmppStream removeDelegate:self];
    [_xmppReconnect deactivate];
    [_xmppReconnect deactivate];
    [_xmppStream disconnect];
    
    _xmppStream = nil;
    _xmppReconnect = nil;
    _xmppPing = nil;
}

- (void)goOnline {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    [_xmppStream sendElement:presence];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"NO_RECEIVE_NotificationPush"]) {
        //        SendMessageOBJ *sendMessage=[[SendMessageOBJ alloc] init];
        //        sendMessage.tokenStr=[[NSUserDefaults standardUserDefaults] objectForKey:DevicePushTOKENID];
        //        sendMessage.emessageType=ADD;
        //        [[SendMessageManager sharedInstance] sendUploadTokenMessage:sendMessage];
    }
}

- (void)goOffline {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:presence];
}

- (BOOL)connect {
    // 判断是否已链接
    if (![_xmppStream isDisconnected]) {
        return YES;
    }
    
    NSString *user=@"1147694503493167";//[[NSUserDefaults standardUserDefaults] stringForKey:@"1147694503493167"]; // 登录者jid key值
    NSString *jidPas=@"W1hT9yewIgsF";//[[NSUserDefaults standardUserDefaults] stringForKey:@"W1hT9yewIgsF"]; // 登录者密码 key值
    
    if (user == nil || jidPas == nil) {
        return NO;
    }
    
    [_xmppStream setMyJID:[XMPPJID jidWithUser:user domain:kOpenFireDomain resource:kOpenFireResouce]];
    
    _password = jidPas;
    NSError *error = nil;
    if (![_xmppStream connectWithTimeout:30 error:&error]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:[error localizedFailureReason]
                                                           delegate:nil cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    return YES;
}

- (void)disconnect {
    [self goOffline];
    [_xmppStream disconnect];
}

#pragma mark - UIApplicationDelegate

- (void)applicationWillTerminate:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"The iPhone simulator does not process background network traffic. "
          @"Inbound traffic is queued until the keepAliveTimeout:handler: fires.");
#endif
    
    if ([application respondsToSelector:@selector(setKeepAliveTimeout:handler:)]) {
        [application setKeepAliveTimeout:600 handler:^{
            NSLog(@"KeepAliveHandler");
            // Do other keep alive stuff here.
        }];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

#pragma mark - XMPPStreamDelegate
- (void)xmppStreamWillConnect:(XMPPStream *)sender{
    NSLog(@"xmppStreamWillConnect:(XMPPStream *)sender");
    
    NSDictionary *dict = @{@"MyMessage":@"连接中",@"DidConnect":@YES};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RECEIVE_DELAYED_MESSAGE" object:dict];//用户收取离线消息时触发的通知
}

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket {
    NSLog(@"xmppStream:(XMPPStream *)sender socketDidConnect:");
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings {
    NSLog(@"xmppStream:(XMPPStream *)sender willSecureWithSettings:");
    
    if (_allowSelfSignedCertificates) {
        [settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
    }
    
    if (_allowSSLHostNameMismatch) {
        [settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
    }
    else {
        NSString *expectedCertName = nil;
        
        NSString *serverDomain = _xmppStream.hostName;
        NSString *virtualDomain = [_xmppStream.myJID domain];
        
        if ([serverDomain isEqualToString:@"talk.google.com"]) {
            if ([virtualDomain isEqualToString:@"gmail.com"]) {
                expectedCertName = virtualDomain;
            }
            else {
                expectedCertName = serverDomain;
            }
        }
        else if (serverDomain == nil) {
            expectedCertName = virtualDomain;
        }
        else  {
            expectedCertName = serverDomain;
        }
        
        if (expectedCertName)  {
            [settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
        }
    }
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender{}

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    _isXmppConnected = YES;
    NSError *error = nil;
    
    if (![_xmppStream authenticateWithPassword:_password error:&error]) {
        NSLog(@"Error authenticating: %@", error);
    }
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    NSLog(@"%s",__FUNCTION__);
    [self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error {
    NSLog(@"%s",__FUNCTION__);
    [self disconnect];
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
    return YES;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    NSLog(@"%s",__FUNCTION__);
    if ([message isChatMessageWithBody]) {
        if ([message wasDelayed]) {
            
        }else {
            NSString *bodyValue = [message body]; // body 值
            NSXMLElement *mainElement = [message elementForName:kXMLNode xmlns:kXMLNS]; // nxin节点
            NSXMLElement *mElement = [mainElement elementForName:@"m"]; // m节点
            
            NSString *chatTag = @"1";
            BOOL isOwn = [[mElement attributeStringValueForName:@"isOwn"] isEqualToString:@"ture"];
            if (!isOwn && [bodyValue isEqualToString:chatTag]) {
                if (![[NSUserDefaults standardUserDefaults] boolForKey:@"NOPlaySystemSound"]) {
                    AudioServicesPlaySystemSound([[[NSUserDefaults standardUserDefaults] objectForKey:@"IndividualBellsFileName"] unsignedIntValue]);
                }
                if (![[NSUserDefaults standardUserDefaults] boolForKey:@"NOPlayVibrating"]) {
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                }
            }
        }
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    NSLog(@"xmppStream:(XMPPStream *)sender didReceivePresence=%@",presence);
    NSDictionary *_dict=[NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"MyMessage", @"MyMessage"),@"MyMessage",[NSNumber numberWithBool:YES],@"DidConnect", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RECEIVE_DELAYED_MESSAGE" object:_dict];
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
    NSLog(@"xmppStream:(XMPPStream *)sender didReceiveError");
    DDXMLNode *errorNode=(DDXMLNode *)error;
    for(DDXMLNode *node in [errorNode children])
    {
        //若错误节点有【冲突】
        if([[node name] isEqualToString:@"conflict"])
        {
            //            UserLogoutBusiness *userLogoutBusiness=[UserLogoutBusiness sharedInstance];
            //            [userLogoutBusiness logoutAction];
            //发送删除推送的token  //释放资源 //断开of连接
            
            //弹出登陆冲突,点击确定后退出
            //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"LogoutNoti", nil) message:NSLocalizedString(@"AccountHasLogin", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil, nil];
            //            alert.tag=LOGOUT;
            //            alert.delegate = OAConnectAppDelegate;
            //            [alert show];
        }
    }
}

#pragma mark XMPPPing Delegate
- (void)xmppPing:(XMPPPing *)sender didReceivePong:(XMPPIQ *)pong withRTT:(NSTimeInterval)rtt{
    NSLog(@"didReceivePong:(XMPPIQ *)pong=%@",[pong XMLString]);
    NSDictionary *_dict=[NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"MyMessage", @"MyMessage"),@"MyMessage",[NSNumber numberWithBool:YES],@"DidConnect", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RECEIVE_DELAYED_MESSAGE" object:_dict];
}

- (void)xmppPing:(XMPPPing *)sender didNotReceivePong:(NSString *)pingID dueToTimeout:(NSTimeInterval)timeout{
    NSLog(@"didNotReceivePong:(NSString *)pingID=%@",pingID);
    NSDictionary *_dict=[NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"DisConnected", nil),@"MyMessage",[NSNumber numberWithBool:NO],@"DidConnect", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RECEIVE_DELAYED_MESSAGE" object:_dict];
}
@end
