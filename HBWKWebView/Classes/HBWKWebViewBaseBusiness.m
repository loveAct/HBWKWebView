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

//配置  H5回调 参数  和本地方法如何与H5对应

+(void)configCommonH5Interaction{
    //方法分析前缀
    NSString *prefixStr = @"HBWKWebView";

    HBWKWebViewModel * model=[[HBWKWebViewModel alloc]init];
    
    model.handleNames = @[@"h5ToNative"];
    model.className = @"HBWKWebViewBaseBusiness";
   /**  返回的JSON样式
    @{
        @"type":@"goBack"
    }
    */
//解析H5 handle方法  得到key  去内存中取对应的SEL
    model.analyseHandle = ^(id  _Nonnull data, HBWKAnalyseCallback  _Nonnull analyseCallback) {
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
        analyseCallback(typeName);
    };
    
    //解析方法  生成key存到内存中  value为对应方法的SEL
    model.analyseSel = ^(NSString * _Nonnull str, HBWKAnalyseSelCallback  _Nonnull analyseCallback) {
        NSArray *array = [str componentsSeparatedByString:@"_"];
        //字符串按照【分隔成数组
        if (array
            &&array.count>1
            &&(prefixStr&&prefixStr.length>0)
            &&([prefixStr isEqualToString:array.firstObject])
            &&(array[1])) {
            analyseCallback(array[1],str);
        }
    };
    
    [[HBWKWebViewManager sharedManager] registModels:model];
}

@end
