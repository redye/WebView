//
//  WebViewController.m
//  WebView
//
//  Created by redye.hu on 2018/3/21.
//  Copyright © 2018年 redye.hu. All rights reserved.
//

#import "WebViewController.h"
#import "YHWebView.h"
#import "JSBridge.h"

@interface WebViewController ()<YHWebViewDelegate, JSBridgeDelegate>

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JSBridge *bridge = [[JSBridge alloc] init];
    bridge.delegate = self;
    
    YHWebView *webView = [[YHWebView alloc] initWithFrame:self.view.bounds delegate:bridge];
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];
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
