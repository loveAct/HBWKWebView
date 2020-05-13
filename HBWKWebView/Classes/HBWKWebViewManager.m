//
//  HBWKWebViewManager.m
//  HBWKWebView
//
//  Created by 王海波 on 2020/4/26.
//

#import "HBWKWebViewManager.h"
#import <objc/runtime.h>
#import "HBWKWebViewBaseBusiness.h"

static char WKWebViewBusinesses;


@interface HBWKWebViewManager ()

@property (nonatomic, strong) NSMutableArray *registModels;

/// 交互方法  存的类名
@property (nonatomic, strong) NSString* clsName;

@end

@implementation HBWKWebViewManager
+(instancetype)sharedManager{
    static HBWKWebViewManager*manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //不能再使用alloc方法
        //因为已经重写了allocWithZone方法，所以这里要调用父类的分配空间的方法
        manager = [[super allocWithZone:NULL] init];
    });
    return manager;
}
// 防止外部调用alloc 或者 new
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [HBWKWebViewManager sharedManager];
}
// 防止外部调用copy
- (id)copyWithZone:(nullable NSZone *)zone {
    return [HBWKWebViewManager sharedManager];
}


/// 初始化 H5交互 bridge
/// @param vc 控制器
/// @param webView webView
/// @param params 请求参数
/// @param bridge bridge
-(void)initializeManagerWithvc:(id<HBWKWebViewProtocol>)vc webView:(WKWebView*)webView params:(NSDictionary*)params bridge:(WKWebViewJavascriptBridge*)bridge{
    
    [self createBusWithVc:vc webView:webView params:params bridge:bridge];
}

/// 创建处理类  注册handlers
/// @param vc      控制器对象
/// @param webView webView
/// @param params 请求参数
/// @param bridge bridge
-(void)createBusWithVc:(id<HBWKWebViewProtocol>)vc
               webView:(WKWebView*)webView
                params:(NSDictionary*)params
                bridge:(WKWebViewJavascriptBridge*)bridge{
    NSMutableArray *busMarr = [NSMutableArray array];
    for (HBWKWebViewModel *model in self.registModels) {
        if (!model.className||model.className==0) {continue;}
        Class cls = NSClassFromString(model.className);
        if (!cls) {continue;}
        HBWKWebViewBaseBusiness *bus = [[cls alloc] init];
        
        bus.webView=webView;
        bus.params = params;
        bus.webViewBridge = bridge;

        [self registWebViewWithBridge:bridge model:model vc:vc];
    }
    objc_setAssociatedObject(self, &WKWebViewBusinesses, busMarr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/// 向JSBridge  注册handler
/// @param bridge bridge对象
/// @param model 包含处理
/// @param vc 控制器对象
-(void)registWebViewWithBridge:(WKWebViewJavascriptBridge*)bridge
                         model:(HBWKWebViewModel*)model
                            vc:(id<HBWKWebViewProtocol>)vc{
    for (NSString *str in model.handleNames) {
        [bridge registerHandler:str handler:^(id data, WVJBResponseCallback responseCallback) {
            WVJBResponseCallback call = ^(NSString*  _Nonnull responseData) {
                
               NSString* sel = [model.selDic objectForKey:responseData];
                [self callEventWithSel:sel vc:vc data:data responseCallback:responseCallback];
            };
            
            model.analyseHandle(data,call);
        }];
    }
}


/// 调交互方法
/// @param sel 方法名
/// @param vc webview控制器
/// @param data 数据
/// @param responseCallback 回调
-(void)callEventWithSel:(NSString*)sel
                     vc:(id<HBWKWebViewProtocol>)vc
                   data:(id)data
       responseCallback:(WVJBResponseCallback) responseCallback{
    HBWKWebViewBaseBusiness *bus = objc_getAssociatedObject(vc, &WKWebViewBusinesses);
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[NSMethodSignature methodSignatureForSelector:NSSelectorFromString(sel)]];
    invocation.target = bus;
    //invocation中的方法必须和签名中的方法一致。
    invocation.selector = NSSelectorFromString(sel);
    [invocation setArgument:&data atIndex:2];
    [invocation setArgument:&responseCallback atIndex:3];
    [invocation invoke];
}



/// 向manager注册  处理类和方法  在initializeManagerWithvc之前调就可以
/// @param model 配置信息
-(void)registModels:(HBWKWebViewModel *)model{
    if ([self.registModels containsObject:model]) {return;}
    for (HBWKWebViewModel *rm in self.registModels) {
        if (rm.handleNames == model.handleNames) {
            return;
        }
    }
    NSDictionary *dic = [self getRegisteredNameAndHandlerWithModel:model];
    model.selDic = dic;
    [self.registModels addObject:dic];
}

//将sel转换成key 和 value 存到字典中
-(NSDictionary *)getRegisteredNameAndHandlerWithModel:(HBWKWebViewModel *)model{
    unsigned int num , i;
    Class cls = NSClassFromString(model.className);
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    Method *methodList = class_copyMethodList(cls, &num);
    for (i = 0; i<num; i++) {
        Method *method = &methodList[i];
        NSString *str = NSStringFromSelector(method_getName(*method));
        model.analyseSel(str, ^(id  _Nonnull key, id  _Nonnull value) {
            [mdic setValue:value forKey:key];
        });
    }
    return mdic.copy;
}

@end
