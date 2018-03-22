//
//  JSBridge.m
//  WebView
//
//  Created by redye.hu on 2018/3/21.
//  Copyright © 2018年 redye.hu. All rights reserved.
//

#import "YHWebViewJSBridge.h"
#import "YHWebViewJSBridge+Addition.h"
#import "YHWebViewHeader.h"

@implementation YHWebViewJSBridge

#pragma mark - YHWebViewDelegate
- (void)webViewDidFinishLoad:(YHWebView *)webView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.delegate webViewDidFinishLoad:webView];
    }
}

- (void)webView:(YHWebView *)webView didReceiveScriptMessage:(YHScriptMessage *)message {
    Class handler = [self classWithName:message.handler];
    SEL action = NSSelectorFromString([NSString stringWithFormat:@"%@:callback:", message.action]);
    if (handler && action) {
        id instance = [[handler alloc] init];
        if ([instance respondsToSelector:action]) {
           CallbackBlock  block = ^(id response){
                NSLog(@"回调");
                if (message.callback) {
                    [webView callback:message.callback response:response];
                }
            };
            ((void (*)(id, SEL, NSDictionary *, CallbackBlock))[instance methodForSelector:action])(instance, action, message.param, block);
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(webView:didReceiveScriptMessage:)]) {
        [self.delegate webView:webView didReceiveScriptMessage:message];
    }
}

@end
