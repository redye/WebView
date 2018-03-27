//
//  YHWebView.h
//  WebView
//
//  Created by redye.hu on 2018/3/21.
//  Copyright © 2018年 redye.hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "YHScriptMessage.h"

typedef NS_ENUM(NSInteger, SyncCookieMode) {
    SyncCookieModeNone = 0,
    SyncCookieModeMust
};

@class YHWebView;
@protocol YHWebViewDelegate<NSObject>

@optional
/**
 该请求是否加载

 @param webView 实例
 @param request 请求
 @return 是否加载
 */
- (BOOL)webView:(YHWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request;
/**
 开始加载

 @param webView 实例
 */
- (void)webViewDidStartLoad:(YHWebView *)webView;
/**
 结束加载

 @param webView 实例
 */
- (void)webViewDidFinishLoad:(YHWebView *)webView;

/**
 加载失败

 @param webView 实例
 @param error  失败描述
 */
- (void)webView:(YHWebView *)webView didFailLoadWithError:(NSError *)error;

/**
 接收到 JS 的调用

 @param webView 实例
 @param message JS消息
 */
- (void)webView:(YHWebView *)webView didReceiveScriptMessage:(YHScriptMessage *)message;

@end

@interface YHWebView : WKWebView

@property (nonatomic, weak) id<YHWebViewDelegate> webViewDelegate;

@property (nonatomic, assign) SyncCookieMode syncCookieMode;

- (instancetype)initWithFrame:(CGRect)frame syncCookieMode:(SyncCookieMode)mode;

/**
 设置 app scheme

 @param appScheme app scheme
 */
+ (void)setAppScheme:(NSString *)appScheme;

/**
 设置 JS 调用 OC 时使用的 messageName
 window.webkit.messageHandlers.xxx.postMessage(msgBody)

 @param messageName messageName
 */
+ (void)setScriptMessageName:(NSString *)messageName;

/**
 OC 主动调用 JS

 @param javaScriptString JS 代码
 */
- (void)evaluateJavaScript:(NSString *)javaScriptString;

@end
