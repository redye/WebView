//
//  JSBridge.h
//  WebView
//
//  Created by redye.hu on 2018/3/21.
//  Copyright © 2018年 redye.hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHWebView.h"
#import "YHWebViewHeader.h"



@protocol YHJSBridgeDelegate<NSObject>

@optional


@end

@interface YHJSBridge : NSObject<YHWebViewDelegate>

@property (nonatomic, weak) id<YHWebViewDelegate, YHJSBridgeDelegate> delegate;

- (void)bindBridgeWithWebView:(YHWebView *)webView;

- (void)registerHandler:(NSString *)handlerName
                 action:(NSString *)actionName
                 handle:(HandleBlock)handleBlock;

- (void)removeHandler:(NSString *)handlerName;

- (void)sendEventWithName:(NSString *)eventName params:(NSDictionary *)params;

@end
