//
//  YHScriptMessage.h
//  WebView
//
//  Created by redye.hu on 2018/3/22.
//  Copyright © 2018年 redye.hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHWebViewHeader.h"

@interface YHScriptMessage : NSObject

@property (nonatomic, strong) NSString *handler;

@property (nonatomic, strong) NSString *action;

@property (nonatomic, strong) NSDictionary *params;

@property (nonatomic, strong) NSString *callbackFunction;

@property (nonatomic, strong) NSString *callbackId;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (void)setCallback:(JSResponseCallback)callback;

- (void)callback:(NSDictionary *)response;

@end
