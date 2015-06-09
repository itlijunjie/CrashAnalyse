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
#define kCACacheDsymPathKey @"kCACacheDsymPathKey"
#define kCACacheCrashPathKey @"kCACacheCrashPathKey"
#define kCACacheAppPathKey @"kCACacheAppPathKey"
#define kCACacheOutPathKey @"kCACacheOutPathKey"

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

- (void)saveDsymPath:(NSString *)dsymPath
{
    [_cacheData setObject:dsymPath forKey:kCACacheDsymPathKey];
    [self saveData];
}

- (NSString *)getDsymPath
{
    return [_cacheData objectForKey:kCACacheDsymPathKey];
}

- (void)saveCrashPath:(NSString *)crashPath
{
    [_cacheData setObject:crashPath forKey:kCACacheCrashPathKey];
    [self saveData];
}

- (NSString *)getCrashPath
{
    return [_cacheData objectForKey:kCACacheCrashPathKey];
}

- (void)saveAppPath:(NSString *)appPath
{
    [_cacheData setObject:appPath forKey:kCACacheAppPathKey];
    [self saveData];
}

- (NSString *)getAppPath
{
    return [_cacheData objectForKey:kCACacheAppPathKey];
}

- (void)saveOutPath:(NSString *)outPath
{
    [_cacheData setObject:outPath forKey:kCACacheOutPathKey];
    [self saveData];
}

- (NSString *)getOutPath
{
    return [_cacheData objectForKey:kCACacheOutPathKey];
}

#pragma mark - Private
- (NSString *)getCachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *cachePath = [documentsDirectory stringByAppendingPathComponent:kCACacheFileName];
    CALogJunJie(@"NSCachesDirectory----%@",cachePath);
    return cachePath;
}

- (void)saveData
{
    CALogJunJie(@"保存缓存路径！");
    [_cacheData writeToFile:[self getCachePath] atomically:YES];
}

@end
