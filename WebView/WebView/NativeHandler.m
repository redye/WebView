//
//  NativeHandler.m
//  WebView
//
//  Created by redye.hu on 2018/3/22.
//  Copyright © 2018年 redye.hu. All rights reserved.
//

#import "NativeHandler.h"
#import "YHWebView.h"
#import "YHWebViewHeader.h"

@implementation NativeHandler

- (void)nativeLog:(NSDictionary *)param callback:(CallbackBlock)block  {
    NSLog(@"nativeLog");
    if (block) {
        block(@"dfkashdflaksdjk");
    }
}

@end
