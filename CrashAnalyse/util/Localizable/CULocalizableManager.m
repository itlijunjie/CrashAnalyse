//
//  CULocalizableManager.m
//  CrashAnalyse
//
//  Created by lijunjie on 1/25/19.
//  Copyright (c) 2019 lijunjie. All rights reserved.
//

#import "CULocalizableManager.h"

@implementation CULocalizableManager

+ (instancetype)share
{
    static CULocalizableManager *localizableManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localizableManager = [[CULocalizableManager alloc] init];
        [localizableManager setLocalLangage:@"Base"];
    });
    return localizableManager;
}

- (void)setLocalLangage:(NSString *)localLanguage
{
    NSString *local = @"zh-Hans";
    if(localLanguage)
    {
        local = localLanguage;
    }
    NSString * bundlePath = [[NSBundle mainBundle] pathForResource:@"CUResources" ofType:@"bundle"];
    
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString *languagePath = [resourceBundle pathForResource:local ofType:@"lproj"];
    _bundle = [NSBundle bundleWithPath:languagePath];
}

@end
