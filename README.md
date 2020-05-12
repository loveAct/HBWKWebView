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

以分类的形式，解析方法key与H5交互
//H5  交互的解析方法   goBack  为解析key
HBWKWebView_Type_dicCallback(goBack){
    NSLog(@"call goBack");
}
//dic:(NSDictionary*)dic Callback:(HBWebResponseCallback)Callback
HBWKWebView_Type_dicCallback(Share){
    NSLog(@"call Share %@",dic);
    Callback(@"ss");
}

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
