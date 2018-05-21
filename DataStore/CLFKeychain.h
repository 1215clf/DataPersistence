//
//  CLFKeychain.h
//  NewsInfo
//
//  Created by clf on 2018/5/18.
//  Copyright © 2018年 com.clf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLFKeychain : NSObject




+(void)saveDataToKeyChain:(id)savaData withKey:(NSString *)key;


+(void)deleteDataFromKeyChainWithKey:(NSString *)key;


+(id)loadDataFromKeyChainWithKey:(NSString *)key;

@end
