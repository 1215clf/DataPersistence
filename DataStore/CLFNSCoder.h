//
//  CLFNSCoder.h
//  NewsInfo
//
//  Created by clf on 2018/5/18.
//  Copyright © 2018年 com.clf. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 必须要遵循NSCoding协议
 保存文件的扩展名可以自定义
 如果需要归档的类是某个自定义类的子类时，就需要在归档和解档之前实现父类的归档和解档方法。[super encodeWithCoder:aCoder]和[super initWithCoder:aDecoder]方法。
 */
@interface CLFNSCoder : NSObject<NSCoding>
@property (nonatomic,copy)NSArray *array;

/**name*/
@property(nonatomic ,copy)NSString *name;
/**age*/
@property(nonatomic ,assign)NSInteger age;
/**sex*/
@property(nonatomic ,assign)BOOL sex;


@end
