//
//  CAAppDelegate.h
//  CrashAnalyse
//
//  Created by lijunjie on 2020/7/27.
//  Copyright © 2020 lijunjie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAAppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, strong) NSWindow *window;
@property (strong, nonatomic) NSArray<NSString *> *argv;

@end

NS_ASSUME_NONNULL_END
