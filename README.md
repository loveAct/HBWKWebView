# HBWKWebView

[![CI Status](https://img.shields.io/travis/wanghaibo1991/HBWKWebView.svg?style=flat)](https://travis-ci.org/wanghaibo1991/HBWKWebView)
[![Version](https://img.shields.io/cocoapods/v/HBWKWebView.svg?style=flat)](https://cocoapods.org/pods/HBWKWebView)
[![License](https://img.shields.io/cocoapods/l/HBWKWebView.svg?style=flat)](https://cocoapods.org/pods/HBWKWebView)
[![Platform](https://img.shields.io/cocoapods/p/HBWKWebView.svg?style=flat)](https://cocoapods.org/pods/HBWKWebView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

继承 HBWKWebViewBaseBusiness

重写hb_registerHandlerName  H5解析方法和本地函数解析方法

利用函数式编程的思想将方法解析  和  H5回调处理暴露给调用者
达到高度自定义

```Objc

//解析H5 handle方法  得到key  去内存中取对应的SEL
model.analyseHandle = ^(id  _Nonnull data, HBWKAnalyseCallback  _Nonnull analyseCallback) {
}

//解析方法  生成key存到内存中  value为对应方法的SEL
model.analyseSel = ^(NSString * _Nonnull str, HBWKAnalyseSelCallback  _Nonnull analyseCallback) {
}
```

按照方法解析   通过宏  可以非常方便的进行交互
也便于后期维护
调用者使用基础HBWKWebViewBaseBusiness
可以用分类的方式进行添加函数
也可以使用基础类  针对不同形式进行自定义
配置示例
+(void)configCommonH5Interaction;

```Objc
//H5  交互的解析方法   goBack  为解析key
HBWKWebView_Type_dicCallback(goBack){
    NSLog(@"call goBack");
}

//dic:(NSDictionary*)dic Callback:(HBWebResponseCallback)Callback
HBWKWebView_Type_dicCallback(Share){
    NSLog(@"call Share %@",dic);
    Callback(@"ss");
}
```

HBNSURLProtocol是针对WKWebView多进程拦截

## Installation

HBWKWebView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'HBWKWebView'
```

## Author

wanghaibo, 413441478@qq.com

## License

HBWKWebView is available under the MIT license. See the LICENSE file for more info.
