//
//  CADataCache.m
//  CrashAnalyse
//
//  Created by lijunjie on 5/16/15.
//  Copyright (c) 2015 lijunjie. All rights reserved.
//

#import "CADataCache.h"

#define kCACacheFileName @"pathcache.plist"
#define kCACacheCommandPathKey @"kCACacheCommandPathKey"

@interface CADataCache ()
{
    NSMutableDictionary *_cacheData;
}

@end

@implementation CADataCache

- (void)dealloc
{
    
}

+ (instancetype)share
{
    static CADataCache *dataCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataCache = [[CADataCache alloc] init];
    });
    return dataCache;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cacheData = [NSMutableDictionary dictionaryWithContentsOfFile:[self getCachePath]];
        if (!_cacheData) {
            _cacheData = [[NSMutableDictionary alloc] init];
        }
    }
    return self;
}

- (void)saveCommandPath:(NSString *)commandPath
{
    [_cacheData setObject:commandPath forKey:kCACacheCommandPathKey];
    [self saveData];
}

- (NSString *)getCommandPath
{
    return [_cacheData objectForKey:kCACacheCommandPathKey];
}

- (void)saveDsymPath
{
    
}

- (NSString *)getDsymPath
{
    return nil;
}

- (void)saveCrashPath
{
    
}

- (NSString *)getCrashPath
{
    return nil;
}

- (void)saveAppPath
{
    
}

- (NSString *)getAppPath
{
    return nil;
}

- (void)saveOutPath
{
    
}

- (NSString *)getOutPath
{
    return nil;
}

#pragma mark - Private
- (NSString *)getCachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *cachePath = [documentsDirectory stringByAppendingPathComponent:kCACacheFileName];
    GJGCLogJunJie(@"NSCachesDirectory----%@",cachePath);
    return cachePath;
}

- (void)saveData
{
    GJGCLogJunJie(@"保存缓存路径！");
    [_cacheData writeToFile:[self getCachePath] atomically:YES];
}

@end
