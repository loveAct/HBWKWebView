//
//  HBWKWebViewManager.m
//  HBWKWebView
//
//  Created by 王海波 on 2020/4/26.
//

#import "HBWKWebViewManager.h"
#import <objc/runtime.h>
#import "HBWKWebViewBaseBusiness.h"

static char WKWebViewBusiness;


@interface HBWKWebViewManager ()

@property (nonatomic, strong) NSMutableArray *registModels;

@end

@implementation HBWKWebViewManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)initializeManagerWithvc:(id<HBWKWebViewProtocol>)vc webView:(WKWebView*)webView params:(NSDictionary*)params bridge:(WKWebViewJavascriptBridge*)bridge{

    HBWKWebViewBaseBusiness *bus = objc_getAssociatedObject(vc, &WKWebViewBusiness);
    if (bus) {return;}
    bus = [[HBWKWebViewBaseBusiness alloc] init];
    objc_setAssociatedObject(self, &WKWebViewBusiness, bus, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    bus.webView=webView;
    bus.webViewBridge = bridge;
    for (HBWKWebViewModel *model in self.registModels) {
        [self registWebViewWithBridge:bridge model:model vc:vc];
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
    HBWKWebViewBaseBusiness *bus = objc_getAssociatedObject(vc, &WKWebViewBusiness);
    NSInvocation *invo = [NSInvocation invocationWithMethodSignature:[NSMethodSignature methodSignatureForSelector:NSSelectorFromString(sel)]];
//    [invo setTarget:bus];
//    invo setArgument:<#(nonnull void *)#> atIndex:<#(NSInteger)#>
}


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
