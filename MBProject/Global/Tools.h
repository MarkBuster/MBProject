//
//  Tools.h
//  MBProject
//
//  Created by yindongbo on 2017/5/25.
//  Copyright © 2017年 Dombo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject

+(NSString *)getXMPPMessageIDFromUUID;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (NSString *) uniqueDeviceIdentifier;
@end
