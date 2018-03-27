//
//  YHJSBridge+Router.m
//  WebView
//
//  Created by redye.hu on 2018/3/23.
//  Copyright © 2018年 redye.hu. All rights reserved.
//

#import "YHJSBridge+Router.h"

@implementation YHJSBridge (Router)

- (void)registerRouterHandler {
    
    [self registerHandler:@"Router" action:@"openLink" handle:^(YHScriptMessage *message) {
        NSString *urlString = [message.params objectForKey:@"url"];
        // MGJRouter: openUrl
        NSLog(@"url => %@", urlString);
        NSURL *url = [NSURL URLWithString:urlString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
}

@end
