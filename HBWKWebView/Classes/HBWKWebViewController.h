//
//  HBWebViewController.h
//  testWebView_Example
//
//  Created by 王海波 on 2020/4/26.
//  Copyright © 2020 wanghaibo1991. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBWKWebViewNaviBarView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HBWKWebViewNaviBarType) {
    HBWKWebViewNaviBarTypeDefault      = 0,      //默认导航栏
    HBWKWebViewNaviBarTypeHidden       = 1,      //隐藏航栏
    HBWKWebViewNaviBarTypeCustom       = 2,      //自定义导航栏
};

@interface HBWKWebViewController : UIViewController

//WKWebView
@property (nonatomic,readonly) WKWebView                 *webView;
//桥接
@property (nonatomic,readonly) WKWebViewJavascriptBridge *webViewBridge;

/**
 自定义导航栏，HBWKWebViewNaviBarView
 */
@property (nonatomic, strong) HBWKWebViewNaviBarView     *naviView;

//进度条
@property (nonatomic, strong) UIProgressView             *progressView;

/**
 请求参数
 */
@property (nonatomic, strong) NSDictionary               *params;

/**
 网络请求地址
 */
@property (nonatomic, strong) NSString                   *urlStr;

/**
 请求h5链接
 
 @param urlStr 链接地址
 */
-(void)loadRequestWithUrl:(NSString *)urlStr;

/**
 跳转H5
 
 @param urlStr 链接地址
 @param naviBarType 导航栏类型
 */
-(void)loadRequestWithUrl:(NSString *)urlStr naviBarType:(HBWKWebViewNaviBarType)naviBarType;

/**
 跳转H5
 
 @param urlStr 链接地址
 @param naviBarType 导航栏类型
 @param title title文案
 */
-(void)loadRequestWithUrl:(NSString *)urlStr naviBarType:(HBWKWebViewNaviBarType)naviBarType title:(NSString*)title;

/// 跳转H5
/// @param urlStr 链接地址
/// @param naviView 自定义导航栏
/// @param title title文案
-(void)loadRequestWithUrl:(NSString *)urlStr
                 naviView:(HBWKWebViewNaviBarView *)naviView
                    title:(NSString*)title;


@end


NS_ASSUME_NONNULL_END
