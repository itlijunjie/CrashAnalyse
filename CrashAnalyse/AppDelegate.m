//
//  AppDelegate.m
//  CrashAnalyse
//
//  Created by lijunjie on 5/14/15.
//  Copyright (c) 2015 lijunjie. All rights reserved.
//

#import "AppDelegate.h"
#import "JJCALogFormatter.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self initLogger];
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)initLogger
{
    JJCALogFormatter *formatter = [[JJCALogFormatter alloc] init];
    
    [[DDASLLogger sharedInstance] setLogFormatter:formatter];
    [[DDTTYLogger sharedInstance] setLogFormatter:formatter];
    
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    
    [DDLog addLogger:fileLogger];
}

@end
