//
//  JSBridge.h
//  WebView
//
//  Created by redye.hu on 2018/3/21.
//  Copyright © 2018年 redye.hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHWebView.h"

@protocol YHWebViewJSBridgeDelegate<NSObject>

@optional


@end

@interface YHWebViewJSBridge : NSObject<YHWebViewDelegate>

@property (nonatomic, weak) id<YHWebViewDelegate, YHWebViewJSBridgeDelegate> delegate;

@end
