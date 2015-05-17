//
//  ViewController.m
//  CrashAnalyse
//
//  Created by lijunjie on 5/14/15.
//  Copyright (c) 2015 lijunjie. All rights reserved.
//

#import "ViewController.h"
#import "CADataCache.h"
#import <JJFileUtil.h>

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

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [_commandPathTextField setStringValue:[kCADataCacheHandle getCommandPath]?:@""];
    [_dsymPathTextField setStringValue:[kCADataCacheHandle getDsymPath]?:@""];
    [_crashPathTextField setStringValue:[kCADataCacheHandle getCrashPath]?:@""];
    [_appPathTextField setStringValue:[kCADataCacheHandle getAppPath]?:@""];
    [_outPathTextField setStringValue:[kCADataCacheHandle getOutPath]?:@""];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

#pragma mark - Action 事件
- (IBAction)selectCommandFile:(id)sender {
    GJGCLogJunJie(@"文件命令选择！");
    _commandPath =  [self chooseFile];
    _commandPathTextField.stringValue = _commandPath?:@"";
    [kCADataCacheHandle saveCommandPath:_commandPath];
}

- (IBAction)selectDsymFile:(id)sender {
    GJGCLogJunJie(@"选择dsym文件！");
    _dsymPath =  [self chooseFile];
    _dsymPathTextField.stringValue = _dsymPath?:@"";
    [kCADataCacheHandle saveDsymPath:_dsymPath];
}

- (IBAction)selectCrashFile:(id)sender {
    GJGCLogJunJie(@"选择crash文件！");
    _crashPath =  [self chooseFile];
    _crashPathTextField.stringValue = _crashPath?:@"";
    [kCADataCacheHandle saveCrashPath:_crashPath];
}

- (IBAction)selectAppFile:(id)sender {
    GJGCLogJunJie(@"选择app文件！");
    _appPath =  [self chooseFile];
    _appPathTextField.stringValue = _appPath?:@"";
    [kCADataCacheHandle saveAppPath:_appPath];
}

- (IBAction)selectOutPath:(id)sender {
    GJGCLogJunJie(@"选择out文件路径！");
    _outPath =  [self chooseDirectorie];
    _outPathTextField.stringValue = _outPath?:@"";
    [kCADataCacheHandle saveOutPath:_outPath];
}

- (IBAction)analyzeClick:(id)sender {
    GJGCLogJunJie(@"分析！");
    
    GJGCLogJunJie(@"%@",[self exeCommand:@"/usr/bin/dwarfdump" arguments:@[@"-u",@"/Users/ljj/Desktop/Crash/CrashAnalyse.app/CrashAnalyse"]]);
    GJGCLogJunJie(@"%@",[self exeCommand:@"/usr/bin/dwarfdump" arguments:@[@"-u",@"/Users/ljj/Desktop/Crash/CrashAnalyse.app.dsym"]]);
    
    
    BOOL isEXE = NO;//是否具备执行的条件 commamdPath存在就说明具备执行条件
    BOOL isAnalyse = NO;//是否具备分析的条件  只要app文件、dsym文件和日志文件存在切UUID一样就说名具备正确分析的条件
    
//    1.校验参数
    if ([JJFileUtil isFileExist:_commandPath]) {
        isEXE = YES;
        if ([JJFileUtil isFileExist:_dsymPath] && [JJFileUtil isFileExist:_appPath] && [JJFileUtil isFileExist:_crashPath]) {
            isAnalyse = YES;
        }
    }
    
    BOOL isUUID = NO;
//    2.校验UUID
    if (isEXE && isAnalyse) {
//        if (<#condition#>) {
//            isUUID = YES;
//        }
    } else {
        
    }

    BOOL isSuccess = NO;
//    3.执行日志分析输出到文件
    if (isUUID) {
//        if (<#condition#>) {
//            isSuccess = YES;
//        }
    }
//    4.更新UI显示分析成功
    if (isSuccess) {
        
    }
}

#pragma mark - Private
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
@end
