//
//  WebViewController.m
//  WebView
//
//  Created by redye.hu on 2018/3/21.
//  Copyright © 2018年 redye.hu. All rights reserved.
//

#import "WebViewController.h"
#import "YHWebView.h"
#import "YHWebViewJSBridge.h"

@interface WebViewController ()<YHWebViewDelegate, YHWebViewJSBridgeDelegate>

@property (nonatomic, strong) YHWebViewJSBridge *bridge;
@property (nonatomic, strong) YHWebView *webView;
@end

@implementation WebViewController

- (void)dealloc {
    NSLog(@"释放 webViewController");
    [self.webView removeFromSuperview];
    self.webView = nil;
    self.bridge = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    YHWebViewJSBridge *bridge = [[YHWebViewJSBridge alloc] init];
    bridge.delegate = self;
    _bridge = bridge;
    
    YHWebView *webView = [[YHWebView alloc] initWithFrame:self.view.bounds delegate:_bridge];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"example" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];
    _webView = webView;
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
