//
//  HBWKWebViewModel.h
//  HBLib
//
//  Created by 王海波 on 2020/4/28.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

typedef void (^HBWKAnalyseCallback)(id key);
typedef void (^HBWKAnalyseHandle)(id data, HBWKAnalyseCallback analyseCallback);

typedef void (^HBWKAnalyseSelCallback)(id key,id value);
typedef void (^HBWKAnalyseSel)(NSString* str, HBWKAnalyseSelCallback analyseCallback);


@interface HBWKWebViewModel : NSObject

//交互 类名称  可以  以分类的形式进行扩展方法  也可以一个模型一个处理类
@property (nonatomic, copy) NSString *className;
//注册方法
@property (nonatomic, copy) NSArray *handleNames;
//解析H5 handle方法  得到key  去内存中取对应的SEL
@property (nonatomic, copy) HBWKAnalyseHandle analyseHandle;
//解析方法  生成key存到内存中  value为对应方法的SEL
@property (nonatomic, copy) HBWKAnalyseSel analyseSel;

//存储方法   key 和 value   sel
@property (nonatomic, copy) NSDictionary *selDic;


@end

NS_ASSUME_NONNULL_END
