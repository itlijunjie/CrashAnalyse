//
//  JJCALogFormatter.m
//  CrashAnalyse
//
//  Created by lijunjie on 5/15/15.
//  Copyright (c) 2015 lijunjie. All rights reserved.
//

#import "JJCALogFormatter.h"

@implementation JJCALogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    return [NSString stringWithFormat:@"%@ | %@ @ %lu | %@",
            [logMessage fileName], logMessage.function, (unsigned long)logMessage.line, logMessage.message];
}

@end
