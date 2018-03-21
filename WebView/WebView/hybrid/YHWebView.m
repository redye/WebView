//
//  YHWebView.m
//  WebView
//
//  Created by redye.hu on 2018/3/21.
//  Copyright © 2018年 redye.hu. All rights reserved.
//

#import "YHWebView.h"

static NSString *YHWebViewUserAgentAppScheme;
static NSArray<NSString *> *YHWebViewScriptMessageNames;


@interface YHWebView()<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>

@property (nonatomic, weak) id<YHWebViewDelegate> delegate;

@end

@implementation YHWebView

- (void)dealloc {
    NSArray *messageNames = [YHWebView scriptMessageNames];
    [messageNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.configuration.userContentController removeScriptMessageHandlerForName:obj];
    }];
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<YHWebViewDelegate>)delegate {
    [self setWebViewUserAgent];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *contentController = [[WKUserContentController alloc] init];
    
    NSArray *messageNames = [YHWebView scriptMessageNames];
    [messageNames enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [contentController addScriptMessageHandler:self name:obj];
    }];
    configuration.userContentController = contentController;
    self = [super initWithFrame:frame configuration:configuration];
    if (self) {
        _delegate = delegate;
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

+ (void)setScriptMessageNames:(NSArray<NSString *> *)messageNames {
    YHWebViewScriptMessageNames = messageNames;
}

+ (NSArray<NSString *> *)scriptMessageNames {
    return YHWebViewScriptMessageNames ?: @[@"Native"];
}

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    NSLog(@"alert");
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
}

@end
