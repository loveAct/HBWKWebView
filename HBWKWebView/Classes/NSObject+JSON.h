//
//  NSObject+JSON.h
//  HBCategory
//
//  Created by 王海波 on 2019/7/16.
//  Copyright © 2019 王海波. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (JSON)

/// json->NSDictionary
/// @param json json
+ (NSDictionary *)hb_dictionaryWithJSON:(id)json;
//字典转json->Str
+(NSString *)hb_convertToJsonStr:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
