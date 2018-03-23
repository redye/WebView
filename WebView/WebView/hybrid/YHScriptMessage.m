//
//  YHScriptMessage.m
//  WebView
//
//  Created by redye.hu on 2018/3/22.
//  Copyright © 2018年 redye.hu. All rights reserved.
//

#import "YHScriptMessage.h"

@interface YHScriptMessage()

@property (nonatomic, copy) JSResponseCallback callback;

@end

@implementation YHScriptMessage

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.action = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"action"]];
        self.handler = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"handler"]];
        self.callbackFun = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"callbackFun"]];
        self.callbackId = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"callbackId"]];
        self.param = [dictionary objectForKey:@"param"] ?: @{};
    }
    return self;
}

- (void)setCallback:(JSResponseCallback)callback {
    _callback = callback;
}

- (void)callback:(NSDictionary *)response {
    if (self.callback) {
        self.callback(response);
    }
}

@end
