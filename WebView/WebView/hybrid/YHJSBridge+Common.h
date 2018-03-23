//
//  YHJSBridge+Common.h
//  WebView
//
//  Created by redye.hu on 2018/3/23.
//  Copyright © 2018年 redye.hu. All rights reserved.
//

#import "YHJSBridge.h"

@interface YHJSBridge (Common)

- (void)registerCommonHandler;

- (void)addLifeCycleListenerCommon;

- (void)removeLifeCycleListenerCommon;

@end
