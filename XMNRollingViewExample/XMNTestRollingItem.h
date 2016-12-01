//
//  XMNTestRollingItem.h
//  XMNRollingViewExample
//
//  Created by XMFraker on 16/12/1.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMNRolling.h"

/** 测试数据类型 */
typedef NS_ENUM(NSUInteger, XMNRollingTestMode) {
    /** 测试本地图片数据 */
    XMNRollingTestModeLocal = 0,
    /** 测试远程图片数据 */
    XMNRollingTestModeRemote,
    /** 测试单张图片数据 */
    XMNRollingTestModeSingle,
    /** 测试混合图片数据 */
    XMNRollingTestModeMixed,
};

@interface XMNTestRollingItem : NSObject <XMNRollingItem>

@property (copy, nonatomic)   NSString *title;
@property (copy, nonatomic)   NSString *imagePath;

#pragma mark - Class Method

+ (XMNTestRollingItem *)itemWithImagePath:(NSString *)imagePath;

+ (NSArray <XMNTestRollingItem *> *)testMixedItems;
+ (NSArray <XMNTestRollingItem *> *)testSingleItems:(BOOL)isRemote;
+ (NSArray <XMNTestRollingItem *> *)testLocalItems;
+ (NSArray <XMNTestRollingItem *> *)testRemoteItems;

@end
