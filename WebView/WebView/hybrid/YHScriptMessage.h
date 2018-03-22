//
//  YHScriptMessage.h
//  WebView
//
//  Created by redye.hu on 2018/3/22.
//  Copyright © 2018年 redye.hu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHScriptMessage : NSObject

@property (nonatomic, strong) NSString *handler;

@property (nonatomic, strong) NSString *action;

@property (nonatomic, strong) NSString *callback;

@property (nonatomic, strong) NSDictionary *param;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
