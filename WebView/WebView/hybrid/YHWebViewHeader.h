//
//  YHWebViewHeader.h
//  WebView
//
//  Created by redye.hu on 2018/3/22.
//  Copyright © 2018年 redye.hu. All rights reserved.
//

#ifndef YHWebViewHeader_h
#define YHWebViewHeader_h


typedef void(^JSResponseCallback)(NSDictionary *response);

@class YHScriptMessage;
typedef void(^HandleBlock)(YHScriptMessage *message);


#endif /* YHWebViewHeader_h */
