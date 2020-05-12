//
//  HBWKWebViewBaseBusiness+Common.m
//  HBWKWebView_Example
//
//  Created by 王海波 on 2020/5/12.
//  Copyright © 2020 wanghaibo1991. All rights reserved.
//

#import "HBWKWebViewBaseBusiness+Common.h"


@implementation HBWKWebViewBaseBusiness (Common)
//H5  交互的解析方法   goBack  为解析key
HBWKWebView_Type_dicCallback(goBack){
    NSLog(@"call goBack");
}
//dic:(NSDictionary*)dic Callback:(HBWebResponseCallback)Callback
HBWKWebView_Type_dicCallback(Share){
    NSLog(@"call Share %@",dic);
    Callback(@"ss");
}

@end
