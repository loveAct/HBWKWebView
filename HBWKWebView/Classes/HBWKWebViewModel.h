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

//截取方法前缀
@property (nonatomic, copy) NSString *prefixStr;
//截取方法后缀
@property (nonatomic, copy) NSString *suffixStr;
//交互类名称
@property (nonatomic, copy) NSString *className;
//注册方法
@property (nonatomic, copy) NSArray *handleNames;
//解析H5 Data
@property (nonatomic, copy) HBWKAnalyseHandle analyseHandle;

@property (nonatomic, copy) HBWKAnalyseCallback analyseCall;

@property (nonatomic, copy) HBWKAnalyseSel analyseSel;

//方法sel
@property (nonatomic, copy) NSDictionary *selDic;


@end

NS_ASSUME_NONNULL_END
