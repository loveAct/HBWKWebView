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

+(instancetype)sharedManager;

-(void)initializeManagerWithvc:(id<HBWKWebViewProtocol>)vc webView:(WKWebView*)webView params:(NSDictionary*)params bridge:(WKWebViewJavascriptBridge*)bridge;

//注册使用类   和  使用方法  处理方法
-(void)registModels:(HBWKWebViewModel *)model cls:(Class)cls;

@end

NS_ASSUME_NONNULL_END
