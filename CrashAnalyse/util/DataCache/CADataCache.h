//
//  CADataCache.h
//  CrashAnalyse
//
//  Created by lijunjie on 5/16/15.
//  Copyright (c) 2015 lijunjie. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCADataCacheHandle [CADataCache share]

@interface CADataCache : NSObject

+ (instancetype)share;

- (void)saveCommandPath:(NSString *)commandPath;
- (NSString *)getCommandPath;

- (void)saveDsymPath:(NSString *)dsymPath;
- (NSString *)getDsymPath;

- (void)saveCrashPath:(NSString *)crashPath;
- (NSString *)getCrashPath;

- (void)saveAppPath:(NSString *)appPath;
- (NSString *)getAppPath;

- (void)saveOutPath:(NSString *)outPath;
- (NSString *)getOutPath;

@end
