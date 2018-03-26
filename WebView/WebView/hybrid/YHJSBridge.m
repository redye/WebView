//
//  JSBridge.m
//  WebView
//
//  Created by redye.hu on 2018/3/21.
//  Copyright © 2018年 redye.hu. All rights reserved.
//

#import "YHJSBridge.h"
#import "YHWebViewHeader.h"

@interface YHJSBridge()

@property (nonatomic, strong) NSMutableDictionary *handlerMap;
@property (nonatomic, strong) YHWebView *webView;

@end

@implementation YHJSBridge

- (void)bindBridgeWithWebView:(YHWebView *)webView {
    self.webView = webView;
    self.webView.webViewDelegate = self;
}

- (NSMutableDictionary *)handlerMap {
    if (!_handlerMap) {
        _handlerMap = [NSMutableDictionary dictionary];
    }
    return _handlerMap;
}

- (void)registerHandler:(NSString *)handlerName
                 action:(NSString *)actionName
                 handle:(HandleBlock)handleBlock {
    if (handlerName && actionName && handleBlock) {
        NSMutableDictionary *handlerDic = [self.handlerMap objectForKey:handlerName];
        if (!handlerDic) {
            handlerDic = [NSMutableDictionary dictionary];
        }
        [handlerDic setObject:handleBlock forKey:actionName];
        [self.handlerMap setObject:handlerDic forKey:handlerName];
    }
}

- (void)removeHandler:(NSString *)handlerName {
    [self.handlerMap removeObjectForKey:handlerName];
}

#pragma mark - YHWebViewDelegate
- (void)webViewDidFinishLoad:(YHWebView *)webView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.delegate webViewDidFinishLoad:webView];
    }
}

- (void)webView:(YHWebView *)webView didReceiveScriptMessage:(YHScriptMessage *)message {
    if (message.handler && message.action) {
        if (message.callbackId && message.callbackFunction &&
            message.callbackId.length > 0 && message.callbackFunction.length > 0) {
            
            __weak typeof(self) weakSelf = self;
            __weak typeof(message) weakMessage = message;
            [message setCallback:^(NSDictionary *response) {
                [weakSelf injectMessageWithFunction:weakMessage.callbackFunction
                                          actionId:weakMessage.callbackId
                                            params:response];
            }];
        }
        NSDictionary *handlerDic = [self.handlerMap objectForKey:message.handler];
        HandleBlock handleBlcok = handlerDic ? [handlerDic objectForKey:message.action] : nil;
        if (handleBlcok) {
            handleBlcok(message);
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(webView:didReceiveScriptMessage:)]) {
        [self.delegate webView:webView didReceiveScriptMessage:message];
    }
}

- (void)injectMessageWithFunction:(NSString *)msg
                        actionId:(NSString *)actionId
                          params:(NSDictionary *)params {
    params = params ?: @{};
    NSString *paramsString = [self _serializeMessageData:params];
    NSString *paramsJSString = [self _transcodingJavascriptMessage:paramsString];
    NSString* javascriptCommand = [NSString stringWithFormat:@"%@('%@', '%@');", msg, actionId, paramsJSString];
    if ([[NSThread currentThread] isMainThread]) {
        [self.webView evaluateJavaScript:javascriptCommand];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.webView evaluateJavaScript:javascriptCommand];
        });
    }
}

/// 字典JSON化
- (NSString *)_serializeMessageData:(id)message {
    if (message) {
        return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:message options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    }
    return nil;
}
/// JSON Javascript编码处理
- (NSString *)_transcodingJavascriptMessage:(NSString *)message {
    //NSLog(@"dispatchMessage = %@",message);
    message = [message stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    message = [message stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    message = [message stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
    message = [message stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    message = [message stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    message = [message stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    message = [message stringByReplacingOccurrencesOfString:@"\u2028" withString:@"\\u2028"];
    message = [message stringByReplacingOccurrencesOfString:@"\u2029" withString:@"\\u2029"];
    
    return message;
}

- (void)sendEventWithName:(NSString *)eventName params:(NSDictionary *)params {
    NSString *jsFunction = @"window.eventDispatcher";
    [self injectMessageWithFunction:jsFunction actionId:eventName params:params];
}

@end
