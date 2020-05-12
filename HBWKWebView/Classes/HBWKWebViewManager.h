//
//  HBWKWebViewManager.h
//  HBWKWebView
//
//  Created by 王海波 on 2020/4/26.
//

#import <Foundation/Foundation.h>
#import "HBWKWebViewProtocol.h"
#import "HBWKWebViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HBWKWebViewManager : NSObject

-(void)initializeManagerWithvc:(id<HBWKWebViewProtocol>)vc webView:(WKWebView*)webView params:(NSDictionary*)params bridge:(WKWebViewJavascriptBridge*)bridge;

-(void)registModels:(HBWKWebViewModel *)model;

@end

NS_ASSUME_NONNULL_END
