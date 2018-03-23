//
//  YHWebView.m
//  WebView
//
//  Created by redye.hu on 2018/3/21.
//  Copyright © 2018年 redye.hu. All rights reserved.
//

#import "YHWebView.h"

static NSString *YHWebViewUserAgentAppScheme;
static NSString *YHWebViewScriptMessageName;

@interface YHScriptMessageHandler: NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) id<WKScriptMessageHandler> delegate;

@end

@implementation YHScriptMessageHandler

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if (self.delegate && [self.delegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
        [self.delegate userContentController:userContentController didReceiveScriptMessage:message];
    }
}

@end

@interface YHWebView()<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>


@end

@implementation YHWebView

- (void)dealloc {
    NSLog(@"WebView dealloc");
    [self.configuration.userContentController removeScriptMessageHandlerForName:[YHWebView scriptMessageName]];
}

- (instancetype)initWithFrame:(CGRect)frame {
    [self setWebViewUserAgent];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *contentController = [[WKUserContentController alloc] init];
    
    // 这里这样使用 handler ，是为了消除循环应用
    YHScriptMessageHandler *handler = [[YHScriptMessageHandler alloc] init];
    handler.delegate = self;
//    [contentController addScriptMessageHandler:self name:[YHWebView scriptMessageNames]];
    [contentController addScriptMessageHandler:handler name:[YHWebView scriptMessageName]];
    configuration.userContentController = contentController;
    self = [super initWithFrame:frame configuration:configuration];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.UIDelegate = self;
    self.navigationDelegate = self;
    self.allowsBackForwardNavigationGestures = YES;
}

- (void)setWebViewUserAgent {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *oldAgent = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        
        NSString *projectName = [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey];
        NSString *appVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey];
        NSString *agentAppScheme = [YHWebView appScheme];
        NSString *userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@/%@; Scale/%0.2f)", projectName, appVersion, [[UIDevice currentDevice] model], agentAppScheme, [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
        
        NSString *newAgent = [NSString stringWithFormat:@"%@ %@;", oldAgent, userAgent];
        
        NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
        [[NSUserDefaults standardUserDefaults] synchronize];
    });
}

+ (void)setAppScheme:(NSString *)appScheme {
    YHWebViewUserAgentAppScheme = appScheme;
}

+ (NSString *)appScheme {
    return YHWebViewUserAgentAppScheme ?: @"WEB";
}

+ (void)setScriptMessageName:(NSString *)messageName {
    YHWebViewScriptMessageName = messageName;
}

+ (NSString *)scriptMessageName {
    return YHWebViewScriptMessageName ?: @"native";
}

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    NSLog(@"alert");
    completionHandler();
}

#pragma mark - WKNavigationDelegate
///请求之前，决定是否要跳转:用户点击网页上的链接，需要打开新页面时，将先调用这个方法。
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"1");
    BOOL isAllow = YES;
    if (self.webViewDelegate && [self.webViewDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:)]) {
        isAllow = [self.webViewDelegate webView:self shouldStartLoadWithRequest:navigationAction.request];
    }
    decisionHandler(isAllow ? WKNavigationActionPolicyAllow: WKNavigationActionPolicyCancel);
}

///接收到相应数据后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSLog(@"2");
    decisionHandler(WKNavigationResponsePolicyAllow);
}

///页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"3");
    if (self.webViewDelegate && [self.webViewDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.webViewDelegate webViewDidStartLoad:self];
    }
}

///主机地址被重定向时调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    // 重定向
    NSLog(@"4");
}

///页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"5");
    if (self.webViewDelegate && [self.webViewDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.webViewDelegate webView:self didFailLoadWithError:error];
    }
}

///当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"6");
}

///页面加载完毕时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"7");
    if (self.webViewDelegate && [self.webViewDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.webViewDelegate webViewDidFinishLoad:self];
    }
}

///跳转失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"8");
}

///如果需要证书验证，与使用AFN进行HTTPS证书验证是一样的
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    NSLog(@"9");
    completionHandler(0, nil);
}

#pragma mark - WKScriptMessageHandler
///JS 调用 OC 的时候回调到该方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if (self.webViewDelegate && [self.webViewDelegate respondsToSelector:@selector(webView:didReceiveScriptMessage:)]) {
        id messageBody = message.body;
        if ([messageBody isKindOfClass:[NSDictionary class]]) {
            YHScriptMessage *scriptMessage = [[YHScriptMessage alloc] initWithDictionary:messageBody];
            if (scriptMessage) {
                [self.webViewDelegate webView:self didReceiveScriptMessage:scriptMessage];
            }
        }
    }
}

#pragma mark - methods
- (void)evaluateJavaScript:(NSString *)javaScriptString {
    [self evaluateJavaScript:javaScriptString completionHandler:nil];
}

@end
