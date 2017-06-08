//
//  MBToolMacro.h
//  MBProject
//
//  Created by yindongbo on 2017/5/25.
//  Copyright © 2017年 Dombo. All rights reserved.
//
// 工具宏
//
#ifndef MBToolMacro_h
#define MBToolMacro_h

#ifdef DEBUG
#define DebugLOG(...) NSLog(__VA_ARGS__);
#else
#define DebugLOG(...);
#endif

#if defined (DEBUG) && DEBUG == 1
#else
#define NSLog(...) {};
#endif



// ==============Color====================
#define kNavigationBarLeftAndRightColor [UIColor colorWithRed:255/255.0f green:75/255.0f blue:1/255.0f alpha:1.0f]
#define kNavigationBarTitleColor [UIColor blackColor]
#define kNavigationBarLeftAndRightColor [UIColor colorWithRed:255/255.0f green:75/255.0f blue:1/255.0f alpha:1.0f]
#define kORANGE_LINE_COLOR [UIColor colorWithRed:255/255.0f green:75/255.0f blue:1/255.0f alpha:1.0f]//编辑框底部线条颜色、底部tabar文字颜色

// ==============Font=====================
#define kViewControllerTitleTextFont [UIFont systemFontOfSize:20.0f]
#define kThirdLevelFont [UIFont systemFontOfSize:15]

#define kMBUserDefaults [NSUserDefaults standardUserDefaults]
#define kMBNotificationCetner [NSNotificationCenter defaultCenter]

#endif /* MBToolMacro_h */
