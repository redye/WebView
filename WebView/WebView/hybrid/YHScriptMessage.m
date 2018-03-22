//
//  YHScriptMessage.m
//  WebView
//
//  Created by redye.hu on 2018/3/22.
//  Copyright © 2018年 redye.hu. All rights reserved.
//

#import "YHScriptMessage.h"

@implementation YHScriptMessage

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.action = [dictionary objectForKey:@"action"];
        self.handler = [dictionary objectForKey:@"handler"];
        self.param = [dictionary objectForKey:@"param"];
        self.callback = [dictionary objectForKey:@"callback"];
    }
    return self;
}

@end
