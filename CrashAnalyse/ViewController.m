//
//  ViewController.m
//  CrashAnalyse
//
//  Created by lijunjie on 5/14/15.
//  Copyright (c) 2015 lijunjie. All rights reserved.
//

#import "ViewController.h"
#import "CADataCache.h"

@interface ViewController ()
{
    IBOutlet NSTextField *_commandPathTextField;
    IBOutlet NSTextField *_dsymPathTextField;
    IBOutlet NSTextField *_crashPathTextField;
    IBOutlet NSTextField *_appPathTextField;
    IBOutlet NSTextField *_outPathTextField;
    
    NSString *_commandPath;
    NSString *_dsymPath;
    NSString *_crashPath;
    NSString *_appPath;
    NSString *_outPath;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_commandPathTextField setStringValue:[kCADataCacheHandle getCommandPath]?:@""];
    [_dsymPathTextField setStringValue:[kCADataCacheHandle getDsymPath]?:@""];
    [_crashPathTextField setStringValue:[kCADataCacheHandle getCrashPath]?:@""];
    [_appPathTextField setStringValue:[kCADataCacheHandle getAppPath]?:@""];
    [_outPathTextField setStringValue:[kCADataCacheHandle getOutPath]?:@""];
}

- (IBAction)selectCommandFile:(id)sender {
    GJGCLogJunJie(@"文件命令选择！");
    _commandPath =  [self chooseFile];
    _commandPathTextField.stringValue = _commandPath?:@"";
    [kCADataCacheHandle saveCommandPath:_commandPath];
}

- (IBAction)selectDsymFile:(id)sender {
    GJGCLogJunJie(@"选择dsym文件！");
    _dsymPath =  [self chooseFile];
    _dsymPathTextField.stringValue = _dsymPath;
}

- (IBAction)selectCrashFile:(id)sender {
    GJGCLogJunJie(@"选择crash文件！");
    _crashPath =  [self chooseFile];
    _crashPathTextField.stringValue = _crashPath;
}

- (IBAction)selectAppFile:(id)sender {
    GJGCLogJunJie(@"选择app文件！");
    _appPath =  [self chooseFile];
    _appPathTextField.stringValue = _appPath;
}

- (IBAction)selectOutPath:(id)sender {
    GJGCLogJunJie(@"选择out文件路径！");
    _outPath =  [self chooseDirectorie];
    _outPathTextField.stringValue = _outPath;
}

- (IBAction)analyzeClick:(id)sender {
    GJGCLogJunJie(@"分析！");
    
    GJGCLogJunJie(@"%@",[self exeCommand:@"/usr/bin/dwarfdump" arguments:@[@"-u",@"/Users/ljj/Desktop/Crash/CrashAnalyse.app/CrashAnalyse"]]);
    GJGCLogJunJie(@"%@",[self exeCommand:@"/usr/bin/dwarfdump" arguments:@[@"-u",@"/Users/ljj/Desktop/Crash/CrashAnalyse.app.dsym"]]);
    
    

}

- (NSString *)chooseFile
{
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    [openDlg setCanChooseFiles:YES];
    
    [openDlg setCanChooseDirectories:NO];
    
//    [openDlg setDirectoryURL:nil];
    
//    [openDlg setNameFieldStringValue:nil];
    NSURL *url = nil;
    if ([openDlg runModal] == NSModalResponseOK) {
        // Get an array containing the full filenames of all
        // files and directories selected.
        NSArray* files = [openDlg URLs];
        
        // Loop through all the files and process them.
        for(NSUInteger i = 0; i < [files count];) {
            url = [files objectAtIndex:i];
            break;
        }
    }
    GJGCLogJunJie(@"%@",url);
    return [url path];
}

- (NSString *)chooseDirectorie
{
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    [openDlg setCanChooseFiles:NO];
    
    [openDlg setCanChooseDirectories:YES];
    
//    [openDlg setDirectoryURL:nil];
    
//    [openDlg setNameFieldStringValue:nil];
    
    NSURL *url = nil;
    if ([openDlg runModal] == NSModalResponseOK) {
        NSArray* files = [openDlg URLs];
        for(NSUInteger i = 0; i < [files count];) {
            url = [files objectAtIndex:i];
            break;
        }
    }
    GJGCLogJunJie(@"%@",url);
    return [url path];
}

- (NSString *)exeCommand:(NSString *)commandPath arguments:(NSArray *)arguments
{
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:commandPath];
    [task setArguments:arguments];
    
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    
    NSFileHandle *file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data = [file readDataToEndOfFile];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

@end
