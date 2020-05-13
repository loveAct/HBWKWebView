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

/// 初始化 H5交互 bridge
/// @param vc 控制器
/// @param webView webView
/// @param params 请求参数
/// @param bridge bridge
-(void)initializeManagerWithvc:(id<HBWKWebViewProtocol>)vc
                       webView:(WKWebView*)webView
                        params:(NSDictionary*)params
                        bridge:(WKWebViewJavascriptBridge*)bridge;

/// 向manager注册  处理类和方法  在initializeManagerWithvc之前调就可以
/// @param model 配置信息
-(void)registModels:(HBWKWebViewModel *)model;

@end

NS_ASSUME_NONNULL_END
