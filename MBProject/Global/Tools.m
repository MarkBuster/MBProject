//
//  Tools.m
//  MBProject
//
//  Created by yindongbo on 2017/5/25.
//  Copyright © 2017年 Dombo. All rights reserved.
//

#import "Tools.h"
//#import "GTMBase64.h"
//#include <sys/socket.h> // Per msqr
//#include <sys/sysctl.h>
//#include <net/if.h>
//#include <net/if_dl.h>


@implementation Tools

+(NSString *)getXMPPMessageIDFromUUID{
    return [[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

+(NSString *)decodeBase64:(NSString *)base64Str
{
    if (base64Str&&[base64Str isKindOfClass:[NSString class]]) {
        NSData *data;//[GTMBase64 decodeString:base64Str];
        if (!data) {
            return base64Str;
        }
        return ([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }
    return base64Str;
}

+(NSString *)encodeBase64:(NSString *)sourceStr
{
    if (!sourceStr) {
        return @"";
    }
    if (sourceStr&&[sourceStr isKindOfClass:[NSString class]]) {
        NSData *data= [sourceStr dataUsingEncoding:NSUTF8StringEncoding];//[GTMBase64 encodeData:[sourceStr dataUsingEncoding:NSUTF8StringEncoding]];
        if (!data) {
            return sourceStr;
        }
        return ([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }
    return sourceStr;/**/
}


/*
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments  error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString *) uniqueDeviceIdentifier{
    NSString *macaddress;
    
    // 如果系统高于6.0
    if (kiOS6Later) {
        macaddress = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }else{
        macaddress = [Tools macaddress:[UIDevice currentDevice]];
    }
    
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    
    NSString *stringToHash = [NSString stringWithFormat:@"%@%@",macaddress,bundleIdentifier];
    NSLog(@"macaddress=%@bundleIdentifier=%@",macaddress,bundleIdentifier);
    NSString *uniqueIdentifier = [stringToHash md5String];
    NSLog(@"uniqueIdentifier=%@",uniqueIdentifier);
    return uniqueIdentifier;
}

+ (NSString *)macaddress:(UIDevice *)device{
    
//    int                 mib[6];
//    size_t              len;
//    char                *buf;
//    unsigned char       *ptr;
//    struct if_msghdr    *ifm;
//    struct sockaddr_dl  *sdl;
//    
//    mib[0] = CTL_NET;
//    mib[1] = AF_ROUTE;
//    mib[2] = 0;
//    mib[3] = AF_LINK;
//    mib[4] = NET_RT_IFLIST;
//    
//    if ((mib[5] = if_nametoindex("en0")) == 0) {
//        printf("Error: if_nametoindex error\n");
//        return NULL;
//    }
//    
//    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
//        printf("Error: sysctl, take 1\n");
//        return NULL;
//    }
//    
//    if ((buf = malloc(len)) == NULL) {
//        printf("Could not allocate memory. error!\n");
//        return NULL;
//    }
//    
//    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
//        printf("Error: sysctl, take 2");
//        free(buf);
//        return NULL;
//    }
//    
//    ifm = (struct if_msghdr *)buf;
//    sdl = (struct sockaddr_dl *)(ifm + 1);
//    ptr = (unsigned char *)LLADDR(sdl);
//    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
//                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
//    free(buf);
    
//    return outstring;
    return @"";
}
@end
