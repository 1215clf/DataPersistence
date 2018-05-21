//
//  CLFNSCoder.m
//  NewsInfo
//
//  Created by clf on 2018/5/18.
//  Copyright © 2018年 com.clf. All rights reserved.
//

#import "CLFNSCoder.h"
#define CoderKey @"CoderKey"

@implementation CLFNSCoder
#pragma mark -- Coding

/*
 CLFNSCoder继承于NSObject，NSObject自身并不采用该协议，
 通过遵循NSCoding中的方法，创建可归档的数据对象。
 */
//编码
-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.age forKey:@"age"];
    [aCoder encodeBool:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.array forKey:CoderKey];
}

//解码
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.age = [aDecoder decodeIntegerForKey:@"age"];
        self.sex = [aDecoder decodeBoolForKey:@"sex"];

        self.array = [aDecoder decodeObjectForKey:CoderKey];
    }
    return self;
}
@end
