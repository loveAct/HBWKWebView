//
//  HBWKWebViewBaseBusiness.m
//  HBWKWebView
//
//  Created by 王海波 on 2020/4/26.
//

#import "HBWKWebViewBaseBusiness.h"
#import "HBWKWebViewModel.h"
#import "NSObject+JSON.h"
#import "HBWKWebViewManager.h"

@implementation HBWKWebViewBaseBusiness
//处理  H5回调 参数  和本地方法如何与H5对应
+(void)hb_registerHandlerName{

    HBWKWebViewModel * model=[[HBWKWebViewModel alloc]init];
    
    model.handleNames = @[@"h5ToNative"];
    model.prefixStr = @"HBWKWebView";
    model.className = @"HBWKWebViewBaseBusiness";
//H5回调方法解析
    model.analyseHandle = ^(id  _Nonnull data, WVJBResponseCallback  _Nonnull responseCallback) {
        //需要进行json解析
        NSDictionary *param = [NSObject hb_dictionaryWithJSON:data];
        
        NSString *typeName = @"";
        if ([param objectForKey:@"type"]) {//事件类型
            typeName = [param objectForKey:@"type"];
        }else if ([param objectForKey:@"event"]){//埋点事件
            typeName = [param objectForKey:@"event"];
        }else if ([param objectForKey:@"action"]){
            typeName = [param objectForKey:@"action"];
        }
        
        responseCallback(typeName);
    };
    //方法  解析
    model.analyseSel = ^(NSString * _Nonnull str, HBWKAnalyseSelCallback  _Nonnull analyseCallback) {
        NSArray *array = [str componentsSeparatedByString:@"_"]; //字符串按照【分隔成数组
        if (array&&array.count>1&&
            (model.prefixStr&&model.prefixStr.length>0)
            &&(array.firstObject==model.prefixStr)
            &&(array[1])) {
            analyseCallback(array[1],str);
        }
    };
    
    [[HBWKWebViewManager sharedManager] registModels:model cls:[HBWKWebViewBaseBusiness class]];
}

@end
