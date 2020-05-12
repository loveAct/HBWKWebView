//
//  HBWKWebViewBaseBusiness.h
//  HBWKWebView
//
//  Created by 王海波 on 2020/4/26.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import <WebViewJavascriptBridge/WKWebViewJavascriptBridge.h>
#import "HBWKWebViewNaviBarView.h"

NS_ASSUME_NONNULL_BEGIN

//命名规则   方法     typeName
//-(void)ZMWKWebView_<#type#>_dic:(NSDictionary*)dic Callback:(ZMWebResponseCallback)Callback

#define HBWKWebView_Type_dicCallback(type)\
-(void)HBWKWebView_##type##_dic:(NSDictionary*)dic Callback:(HBWebResponseCallback)Callback

@interface HBWKWebViewBaseBusiness : NSObject

//WKWebView
@property (nonatomic,weak) WKWebView                 *webView;
//桥接
@property (nonatomic,weak) WKWebViewJavascriptBridge *webViewBridge;

@end

NS_ASSUME_NONNULL_END
