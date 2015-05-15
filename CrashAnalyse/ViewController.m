//
//  ViewController.m
//  CrashAnalyse
//
//  Created by lijunjie on 5/14/15.
//  Copyright (c) 2015 lijunjie. All rights reserved.
//

#import "ViewController.h"
#import "JJCALoggerUitilsMacrocDefine.h"

@implementation ViewController

- (IBAction)selectCommandFile:(id)sender {
    GJGCLogJunJie(@"文件选择");
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/ls"];
    
    NSArray *arguments;
    arguments = [NSArray arrayWithObjects: @"-l", @"-a", @"-t", nil];
    [task setArguments: arguments];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data;
    data = [file readDataToEndOfFile];
    
    NSString *string;
    string = [[NSString alloc] initWithData: data
                                   encoding: NSUTF8StringEncoding];
    NSLog (@"got\n%@", string);
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
