//
//  CLFKeychain.m
//  NewsInfo
//
//  Created by clf on 2018/5/18.
//  Copyright © 2018年 com.clf. All rights reserved.
//

#import "CLFKeychain.h"

@implementation CLFKeychain

//+(CLFKeychain *)standardKeychain
//{
//    static dispatch_once_t onceToken;
//    static CLFKeychain *keychain;
//    dispatch_once(&onceToken, ^{
//        keychain = [[self alloc]init];
//        
//    });
//    return keychain;
//}

+(void)saveDataToKeyChain:(id)savaData withKey:(NSString *)key
{
    [self save:key data:savaData];
}


+(id)loadDataFromKeyChainWithKey:(NSString *)key
{
    return [self load:key];
}

+(void)deleteDataFromKeyChainWithKey:(NSString *)key
{
    [self delete:key];
}


+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge_transfer id)kSecClassGenericPassword,(__bridge_transfer id)kSecClass,
            service, (__bridge_transfer id)kSecAttrService,
            service, (__bridge_transfer id)kSecAttrAccount,
            (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,(__bridge_transfer id)kSecAttrAccessible,
            nil];
}

/**
 存储数据的方法
 OSStatus SecItemAdd(CFDictionaryRef attributes, CFTypeRef * __nullable CF_RETURNS_RETAINED result)
 
 @attributes : 是要添加的数据。
 @ result : 这是存储数据后，返回一个指向该数据的引用，如果不是使用该引用时可以传入 NULL 。
 
 */
+ (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    CFDictionaryRef aRef = (__bridge_retained CFDictionaryRef)keychainQuery;
    SecItemDelete(aRef/*(__bridge_retained CFDictionaryRef)keychainQuery*/);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge_transfer id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd(aRef/*(__bridge_retained CFDictionaryRef)keychainQuery*/, NULL);
}

/**
 
 OSStatus SecItemUpdate(CFDictionaryRef query, CFDictionaryRef attributesToUpdate)
 __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_2_0);
 
 @query : 要更新数据的查询条件。
 @attributesToUpdate : 要更新的数据。
 
 */
+(BOOL)keyChainUpdata:(id)data withIdentifier:(NSString*)service {
    //Get search dictionary
    NSMutableDictionary * keychainQuery = [self getKeychainQuery:service];
    // create update dictionary
    NSMutableDictionary * updataMutableDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    // store data
    [updataMutableDictionary setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge_transfer id)kSecValueData];
    //
    OSStatus  updataStatus = SecItemUpdate((CFDictionaryRef)keychainQuery, (CFDictionaryRef)updataMutableDictionary);
    // free
    keychainQuery = nil;
    updataMutableDictionary = nil;
    
    if (updataStatus == errSecSuccess) {
        return  YES ;
    }
    return NO;
}

/**
 根据条件查询数据
 OSStatus SecItemCopyMatching(CFDictionaryRef query, CFTypeRef * __nullable CF_RETURNS_RETAINED result)
 
 @query : 要查询数据的条件。
 @result: 根据条件查询得到数据的引用。
 
 */

+ (id)load:(NSString *)service {
    
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
        } @catch (NSException *exception) {
            NSLog(@"Unarchive of %@ failed: %@", service, exception);
        } @finally {
        }
    }
    return ret;
}

/**
 删除数据
 OSStatus SecItemDelete(CFDictionaryRef query)
 __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_2_0);
 
 @query : 删除的数据的查询条件。
 */
+ (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
}

@end
