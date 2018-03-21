//
//  JSBridge.h
//  WebView
//
//  Created by redye.hu on 2018/3/21.
//  Copyright © 2018年 redye.hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHWebView.h"

@protocol JSBridgeDelegate<NSObject>

@optional


@end

@interface JSBridge : NSObject

@property (nonatomic, weak) id<YHWebViewDelegate, JSBridgeDelegate> delegate;

@end
