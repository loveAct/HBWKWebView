//
//  HBWKWebViewProtocol.h
//  HBLib
//
//  Created by 王海波 on 2020/4/28.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import <WebViewJavascriptBridge/WKWebViewJavascriptBridge.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HBWKWebViewProtocol <NSObject>

//WKWebView
@property (nonatomic,readonly) WKWebView                 *webView;
//桥接
@property (nonatomic,readonly) WKWebViewJavascriptBridge *webViewBridge;
/**
 请求参数
 */
@property (nonatomic, strong) NSDictionary               *params;


@end

NS_ASSUME_NONNULL_END
