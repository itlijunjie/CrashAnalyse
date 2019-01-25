//
//  CULocalizableManager.h
//  CrashAnalyse
//
//  Created by lijunjie on 1/25/19.
//  Copyright (c) 2019 lijunjie. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CULocalizedString(key) [[CULocalizableManager share].bundle localizedStringForKey:(key) value:@"" table:@"CULocalizable"]

@interface CULocalizableManager : NSObject
{
    
}

@property(nonatomic, strong)NSBundle *bundle;

+ (instancetype)share;

@end
