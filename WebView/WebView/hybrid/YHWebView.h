//
//  YHWebView.h
//  WebView
//
//  Created by redye.hu on 2018/3/21.
//  Copyright © 2018年 redye.hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@class YHWebView;
@protocol YHWebViewDelegate<NSObject>

@optional
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

@end

@interface YHWebView : WKWebView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<YHWebViewDelegate>)delegate;

+ (void)setAppScheme:(NSString *)appScheme;

+ (void)setScriptMessageNames:(NSArray<NSString *> *)messageNames;

@end
