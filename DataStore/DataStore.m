//
//  DataStore.m
//  NewsInfo
//
//  Created by clf on 2018/5/18.
//  Copyright © 2018年 com.clf. All rights reserved.
//

#import "DataStore.h"
#import "CLFNSCoder.h"
#import "CLFKeychain.h"

@implementation DataStore

#pragma mark - plist文件存储
/**
 写入数据
 */
-(void)writeToPlist:(NSDictionary *)dict plistName:(NSString *)plistName{
    //存取路径
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    //路径中文件名
    NSString *filePath = [path stringByAppendingPathComponent:plistName];
    //序列化,把数据存入指定目录的plist文件
    [dict writeToFile:filePath atomically:YES];//atomically 表示是否需要先写入一个辅助文件，再把辅助文件拷贝到目标文件地址。这是更安全的写入文件方法，一般都写 YES
}



/**
 根据plist文件名读取数据
 */
-(NSDictionary *)readFromPlistWithPlistName:(NSString *)plistName{
    //存取路径
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    //路径中文件名
    NSString *filePath = [path stringByAppendingPathComponent:plistName];
    NSDictionary *resultDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return resultDict;
}


#pragma mark - NSUserDefaults

-(void)writeToUserDefaultsWith:(id)object key:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:object forKey:key];
    //立即同步设置
    [userDefaults synchronize];
}

-(id)readFromUserDefaultsWithKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    id result = [userDefaults objectForKey:key];
    
    return result;
}



#pragma mark - NSKeyedArchiver:归档和解档

-(void)archiver
{
    //保存地址
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    //文件名
    NSString *filePath = [path stringByAppendingPathComponent:@"clf.data"];
    CLFNSCoder *save = [[CLFNSCoder alloc] init];
    //设置数据
    save.name = @"clf";
    save.age = 18;
    save.sex = 1;
    save.array = [NSArray arrayWithObjects:@"1",@"one",@"2",@"two", nil];
    
    [NSKeyedArchiver archiveRootObject:save toFile:filePath];
}

-(void)unarchiver
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = [path stringByAppendingPathComponent:@"clf.data"];
    CLFNSCoder *save = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (save) {
        NSLog(@"\n%@\n%ld\n%d\n%@",save.name,save.age,save.sex,save.array);
    }
}

#pragma mark - Keychain

-(void)saveDataToKeyChain
{
    [CLFKeychain saveDataToKeyChain:@"clf" withKey:@"name"];
    [CLFKeychain saveDataToKeyChain:@"123456" withKey:@"pwd"];
}

-(void)loadDataFromKeyChain
{
    NSString *name = [CLFKeychain loadDataFromKeyChainWithKey:@"name"];
    NSString *pwd = [CLFKeychain loadDataFromKeyChainWithKey:@"pwd"];
    NSLog(@"name = %@,pwd= %@",name,pwd);
}



@end
