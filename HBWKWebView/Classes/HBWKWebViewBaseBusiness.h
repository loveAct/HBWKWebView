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

typedef void (^HBWebResponseCallback)(id responseData);
typedef void (^HBHandler)(id data, HBWebResponseCallback responseCallback);


//命名规则   方法     typeName
//-(void)HBWKWebView_type_dic:(NSDictionary*)dic Callback:(HBWebResponseCallback)Callback

#define HBWKWebView_Type_dicCallback(type)\
-(void)HBWKWebView_##type##_dic:(NSDictionary*)dic Callback:(HBWebResponseCallback)Callback

@interface HBWKWebViewBaseBusiness : NSObject

//WKWebView
@property (nonatomic,weak) WKWebView                 *webView;
//桥接
@property (nonatomic,weak) WKWebViewJavascriptBridge *webViewBridge;

+(void)hb_registerHandlerName;
@end

NS_ASSUME_NONNULL_END
