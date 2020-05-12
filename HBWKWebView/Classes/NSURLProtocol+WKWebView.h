//
//  NSURLProtocol+WKWebView.h
//  HBWKWebView
//
//  Created by 王海波 on 2020/4/26.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLProtocol (WKWebView)
+ (void)hb_registerScheme:(NSString*)scheme;

+ (void)hb_unregisterScheme:(NSString*)scheme;

@end

NS_ASSUME_NONNULL_END
