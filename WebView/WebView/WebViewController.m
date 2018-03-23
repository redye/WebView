//
//  WebViewController.m
//  WebView
//
//  Created by redye.hu on 2018/3/21.
//  Copyright © 2018年 redye.hu. All rights reserved.
//

#import "WebViewController.h"
#import "YHWebView.h"
#import "YHJSBridge.h"
#import "YHJSBridge+Common.h"

@interface WebViewController ()<YHWebViewDelegate, YHJSBridgeDelegate>

@property (nonatomic, strong) YHJSBridge *bridge;
@property (nonatomic, strong) YHWebView *webView;
@end

@implementation WebViewController

- (void)dealloc {
    NSLog(@"释放 webViewController");
    [self.webView removeFromSuperview];
    [self.bridge removeLifeCycleListenerCommon];
    self.webView = nil;
    self.bridge = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // bridge 与  webView 绑定
    YHWebView *webView = [[YHWebView alloc] initWithFrame:self.view.bounds];
    WKPreferences *preference = [[WKPreferences alloc] init];
    webView.configuration.preferences = preference;
    preference.minimumFontSize = 16;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"example" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];
    self.webView = webView;
    
    YHJSBridge *bridge = [[YHJSBridge alloc] init];
    bridge.delegate = self;
    self.bridge = bridge;
    [self.bridge registerHandler:@"nativeHandler" action:@"nativeLog" handle:^(YHScriptMessage *message) {
        NSLog(@"log ==> %@", message.param);
    }];
    [self.bridge registerCommonHandler];
    [self.bridge bindBridgeWithWebView:webView];
    [self.bridge addLifeCycleListenerCommon];
}

#pragma mark - YHWebViewDelegate, JSBridgeDelegate
- (void)webViewDidFinishLoad:(YHWebView *)webView {
    __weak typeof(self) _self = self;
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        NSLog(@"title====>%@", response);
        if ([response isKindOfClass:[NSString class]]) {
            _self.title = response;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
