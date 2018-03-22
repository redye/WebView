//
//  YHWebViewJSBridge+Addition.m
//  WebView
//
//  Created by redye.hu on 2018/3/22.
//  Copyright © 2018年 redye.hu. All rights reserved.
//

#import "YHWebViewJSBridge+Addition.h"

@implementation YHWebViewJSBridge (Addition)

- (Class)classWithName:(NSString *)name {
    Class clazz = nil;
    if (name) {
        NSString *className = [name copy];
        NSString *subString = [[className substringToIndex:1] uppercaseString];
        NSString *subString2 = [className substringFromIndex:1];
        className = [NSString stringWithFormat:@"%@%@", subString, subString2];
        clazz = NSClassFromString(className);
    }
    return clazz;
}

@end
