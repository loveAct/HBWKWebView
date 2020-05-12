//
//  HBWebViewController.m
//  testWebView_Example
//
//  Created by 王海波 on 2020/4/26.
//  Copyright © 2020 wanghaibo1991. All rights reserved.
//

#import "HBWKWebViewController.h"
#import <Masonry/Masonry.h>

#define kNavigationBarHeight 64

@interface HBWKWebViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic,strong)WKWebView *webView;

//桥接
@property(nonatomic,strong) WKWebViewJavascriptBridge *webViewBridge;

/**
 导航栏type
 */
@property(nonatomic,assign) HBWKWebViewNaviBarType naviBarType;

/// title
@property (nonatomic, strong) NSString *titleStr;


//加完token 参数  完整请求的url
@property (nonatomic, strong) NSString *requestURL;

@end

@implementation HBWKWebViewController
#pragma mark - cycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self viewWillAppearOrDisappear:YES];
    /*
     （拍照过程消耗了大量内存，导致内存紧张，WebContent Process 被系统挂起），但上面的回调函数并没有被调用。在WKWebView白屏的时候，另一种现象是 webView.titile 会被置空, 因此，可以在 viewWillAppear 的时候检测 webView.title 是否为空来 reload 页面。
     */
    if (self.webView.title) {
        [self.webView reload];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self viewWillAppearOrDisappear:NO];
}

-(void)dealloc{
    if (_webView) {
        [_webView removeFromSuperview];
        if ([[UIDevice currentDevice] systemVersion].floatValue < 10.0) {
            _webView.navigationDelegate = nil;
        }
        [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
        [_webView removeObserver:self forKeyPath:@"title"];
        _webView = nil;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self addObserver];
    
    _webViewBridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
    [_webViewBridge setWebViewDelegate:self];//下面代理的执行
}

#pragma mark - public
/**
 跳转H5
 
 @param urlStr 链接地址
 */
-(void)loadRequestWithUrl:(NSString *)urlStr{
    if (![urlStr isKindOfClass:[NSString class]]||urlStr.length==0) {return;}
    self.urlStr = urlStr?:@"";
}

/**
 跳转H5
 
 @param urlStr 链接地址
 @param naviBarType 导航栏类型
 */
-(void)loadRequestWithUrl:(NSString *)urlStr naviBarType:(HBWKWebViewNaviBarType)naviBarType{
    if (![urlStr isKindOfClass:[NSString class]]) {return;}
    self.urlStr = urlStr?:@"";
    self.naviBarType = naviBarType;
}

/**
 跳转H5
 
 @param urlStr 链接地址
 @param naviBarType 导航栏类型
 @param title title文案
 */
-(void)loadRequestWithUrl:(NSString *)urlStr naviBarType:(HBWKWebViewNaviBarType)naviBarType title:(NSString*)title{
    if (![urlStr isKindOfClass:[NSString class]]) {return;}
    self.urlStr = urlStr?:@"";
    [self setNaviBarTitle:title];
}
/// 跳转H5
/// @param urlStr 链接地址
/// @param naviView 自定义导航栏
/// @param title title文案
-(void)loadRequestWithUrl:(NSString *)urlStr
                 naviView:(HBWKWebViewNaviBarView *)naviView
                    title:(NSString*)title{
    if (![urlStr isKindOfClass:[NSString class]]) {return;}
    self.urlStr = urlStr?:@"";
    [self setNaviBarTitle:title];

}

#pragma mark - addObserver

/**
 监听webview参数
 */
-(void)addObserver{
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}

#pragma mark -- WKNavigationDelegate

///异常处理  白屏问题
// @abstract Invoked when the web view's web content process is terminated.
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    [webView reload];
}


#pragma mark - private-method

/**
 判断加入token、platform、channelProgram
 */
-(void)addTokenPlatformChannelProgram{
}

//视图出现 视图消失
-(void)viewWillAppearOrDisappear:(BOOL)isAppear{
    switch (self.naviBarType) {
        case HBWKWebViewNaviBarTypeDefault:
        {
            self.navigationController.navigationBar.hidden = !isAppear;
        }
            break;
        case HBWKWebViewNaviBarTypeHidden:
        case HBWKWebViewNaviBarTypeCustom:
            self.navigationController.navigationBar.hidden = isAppear;
            break;
        default:
            break;
    }
//禁止手势侧滑
//    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = !isAppear;
//    }
}


/**
 设置title
 
 @param title str
 */
-(void)setNaviBarTitle:(NSString *)title{
    if (![title isKindOfClass:[NSString class]]) {return;}
    switch (self.naviBarType) {
        case HBWKWebViewNaviBarTypeDefault:
        {
            self.title = title;
        }
            break;
        case HBWKWebViewNaviBarTypeHidden:
//            self.webView.title = title;
            break;
        case HBWKWebViewNaviBarTypeCustom:
            self.naviView.titleLbl.text = title;
            break;
        default:
            break;
    }
}

/**
 返回按钮处理
 */
- (void)goBack_Swizzle{
    if (self.webView.canGoBack) {
        [self.webView goBack];
        //有时候会白屏，reload一下
        [self.webView reload];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -  网络请求
- (void)loadRealRequest{
    if (!_requestURL) {
        return;
    }
   WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
   configuration.userContentController = [WKUserContentController new];
   
   WKPreferences *preferences = [WKPreferences new];
   preferences.javaScriptCanOpenWindowsAutomatically = YES;
   preferences.minimumFontSize = 30.0;
   configuration.preferences = preferences;
   
   _webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
   _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   
   if ([_webView respondsToSelector:@selector(setNavigationDelegate:)]) {
       [_webView setNavigationDelegate:self];
   }
   
   if ([_webView respondsToSelector:@selector(setDelegate:)]) {
       [_webView setUIDelegate:self];
   }
   NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
   NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
}

//- (void)setCookieWithRequest:(NSMutableURLRequest *)request {
//    NSMutableString *cookieStr = [[NSMutableString alloc] init];
//    NSArray *cookiesList =  [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:request.URL.absoluteString]];
//    for (NSHTTPCookie *cookie in cookiesList) {
//        [cookieStr appendFormat:@"%@=%@;",cookie.name,cookie.value];
//    }
//    NSString *sessionidCookieValue = [NSString stringWithFormat:@"sessionid=%@;",[User sharedInstance].sessionId];
//    [cookieStr appendString:sessionidCookieValue];
//
//    NSString  *cookieString = [NSString stringWithFormat:@"document.cookie='%@';document.cookie ='token = %@'",cookieStr,[User sharedInstance].accessToken];
//
//    WKUserScript * cookieScript = [[WKUserScript alloc] initWithSource:cookieString injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
//
//    [self.webView.configuration.userContentController addUserScript:cookieScript];
//
//    [request setValue:cookieString forHTTPHeaderField:@"Cookie"];
//}

/**
 隐藏导航栏
 */
-(void)hidenCustomNaviBarView{
    if (self.naviBarType == HBWKWebViewNaviBarTypeHidden) {
        self.naviView.hidden = YES;
        self.progressView.hidden = YES;
    }
}
/**
 显示导航栏
 */
-(void)showCustomNaviBarView{
    if (self.naviBarType == HBWKWebViewNaviBarTypeHidden) {
        self.naviView.hidden = NO;
        self.progressView.hidden = NO;
    }
}

#pragma mark -  KVO
// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            [self.progressView setProgress:0.8 animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.progressView setProgress:0 animated:NO];
            });
        }else {
            newprogress = newprogress*0.8;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }else if (object == self.webView && [keyPath isEqualToString:@"title"]){
        if (self.naviBarType != HBWKWebViewNaviBarTypeHidden) {
            [self setNaviBarTitle:self.webView.title];
        }
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [self hidenCustomNaviBarView];
    
    // 禁止放大缩小
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
    NSLog(@"didFinishNavigation");
}

// 页面加载失败时调用

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    [self loadUrlFailed];
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
}

//加载H5失败
-(void)loadUrlFailed{
    [self.progressView setProgress:0 animated:NO];
    [self showCustomNaviBarView];
}

#pragma mark - setupUI
-(void)setupUI{
    switch (self.naviBarType) {
        case HBWKWebViewNaviBarTypeDefault:
        {
            [self setupUIDefault];
        }
            break;
        case HBWKWebViewNaviBarTypeHidden:
        {
            [self setupUIHiden];
        }
            break;
        case HBWKWebViewNaviBarTypeCustom:
        {
            [self setupUICustom];
        }
            break;
        default:
            break;
    }
}

-(void)setupUIDefault{
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@0.5);
    }];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
}

-(void)setupUIHiden{
   
    [self.view addSubview:self.webView];
    [self.view addSubview:self.naviView];
    [self.view addSubview:self.progressView];
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self.view);
        make.height.equalTo(@(kNavigationBarHeight));
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.naviView.mas_bottom);
        make.height.equalTo(@0.5);
    }];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
}

-(void)setupUICustom{
     self.navigationController.navigationBarHidden = YES;
    [self.view addSubview:self.naviView];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self.view);
        make.height.equalTo(@(kNavigationBarHeight));
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.naviView.mas_bottom);
        make.height.equalTo(@0.5);
    }];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(self.naviView.mas_bottom);
    }];
}

#pragma mark - setter getter
-(void)setUrlStr:(NSString *)urlStr{
    
    _urlStr = urlStr;
}
- (WKWebView *)webView{
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        _webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:config];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.autoresizingMask= UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.scrollView.bounces = NO;
    }
    return _webView;
}
-(UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]init];
        _progressView.tintColor = [UIColor redColor];
    }return _progressView;
}
-(HBWKWebViewNaviBarView *)naviView{
    if (!_naviView) {
        _naviView = [[HBWKWebViewNaviBarView alloc]init];
        [_naviView.backBtn addTarget:self action:@selector(goBack_Swizzle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _naviView;
}


@end
