//
//  YHJSBridge+Common.m
//  WebView
//
//  Created by redye.hu on 2018/3/23.
//  Copyright © 2018年 redye.hu. All rights reserved.
//

#import "YHJSBridge+Common.h"

@implementation YHJSBridge (Common)

- (void)registerCommonHandler {
    __weak typeof(self) weakSelf = self;
    [self registerHandler:@"common" action:@"copyContent" handle:^(YHScriptMessage *message) {
        NSLog(@"复制到剪切板");
        NSString *content = [message.param objectForKey:@"content"];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = content;
    }];
    
    [self registerHandler:@"common" action:@"nativeLog" handle:^(YHScriptMessage *message) {
        NSLog(@"nativeLog => %@", message.param);
        [message callback:@{@"result": @"nativeLog回调"}];
    }];
    
    [self registerHandler:@"common" action:@"getLocation" handle:^(YHScriptMessage *message) {
        NSDictionary *response = [weakSelf getLocation];
        [message callback:response];
    }];
    
    [self registerHandler:@"common" action:@"takeCamera" handle:^(YHScriptMessage *message) {
        NSDictionary *response = [weakSelf takeCamera];
        [message callback:response];
    }];
}

- (NSDictionary *)getLocation {
    NSLog(@"定位");
    return @{@"location": @"地位"};
}

- (NSDictionary *)takeCamera {
    NSLog(@"拍照");
    return @{@"data": @"照片"};
}

- (void)addLifeCycleListenerCommon {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

- (void)removeLifeCycleListenerCommon {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationEnterForeground {
    [self sendEventWithName:@"applicationEnterForeground" params:nil];
}

- (void)applicationEnterBackground {
    [self sendEventWithName:@"applicationEnterBackground" params:nil];
}

@end
