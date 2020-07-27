//
//  CAViewController.m
//  CrashAnalyse
//
//  Created by lijunjie on 2020/7/27.
//  Copyright © 2020 lijunjie. All rights reserved.
//

#import "CAViewController.h"
#import "CADataCache.h"
#import "JJFileUtil.h"
#import "NSString+JJStringUtil.h"

@interface CAViewController () {
    IBOutlet NSTextField *_commandPathTextField;
    IBOutlet NSTextField *_dsymPathTextField;
    IBOutlet NSTextField *_crashPathTextField;
    IBOutlet NSTextField *_appPathTextField;
    IBOutlet NSTextField *_outPathTextField;
    IBOutlet NSTextField *_infoTextField;
    IBOutlet NSTextField *_targetNameTextField;
    
    NSString *_targetName;
}

@property (nonatomic,strong) NSString *commandPath;
@property (nonatomic,strong) NSString *dsymPath;
@property (nonatomic,strong) NSString *crashPath;
@property (nonatomic,strong) NSString *appPath;
@property (nonatomic,strong) NSString *outPath;
@property (nonatomic,strong) NSString *dwarfdumpPath;

@end

@implementation CAViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _commandPath = [kCADataCacheHandle getCommandPath]?:@"";
    [_commandPathTextField setStringValue:_commandPath];
    _dsymPath = [kCADataCacheHandle getDsymPath]?:@"";
    [_dsymPathTextField setStringValue:_dsymPath];
    _crashPath = [kCADataCacheHandle getCrashPath]?:@"";
    [_crashPathTextField setStringValue:_crashPath];
    _appPath = [kCADataCacheHandle getAppPath]?:@"";
    [_appPathTextField setStringValue:_appPath];
    _outPath = [kCADataCacheHandle getOutPath]?:@"";
    [_outPathTextField setStringValue:_outPath];
    if (_appPath) {
        _targetName = [[[_appPath lastPathComponent] componentsSeparatedByString:@"."] firstObject]?:@"";
        [_targetNameTextField setStringValue:_targetName];
    }
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

#pragma mark - Action 事件
- (IBAction)selectCommandFile:(id)sender {
    CALogJunJie(@"文件命令选择！");
    _commandPath =  [self chooseFile];
    _commandPathTextField.stringValue = _commandPath?:@"";
    [kCADataCacheHandle saveCommandPath:_commandPath];
}

- (IBAction)selectDsymFile:(id)sender {
    CALogJunJie(@"选择dsym文件！");
    _dsymPath =  [self chooseFile];
    _dsymPathTextField.stringValue = _dsymPath?:@"";
    [kCADataCacheHandle saveDsymPath:_dsymPath];
}

- (IBAction)selectCrashFile:(id)sender {
    CALogJunJie(@"选择crash文件！");
    _crashPath =  [self chooseFile];
    _crashPathTextField.stringValue = _crashPath?:@"";
    [kCADataCacheHandle saveCrashPath:_crashPath];
}

- (IBAction)selectAppFile:(id)sender {
    CALogJunJie(@"选择app文件！");
    _appPath =  [self chooseFile];
    _appPathTextField.stringValue = _appPath?:@"";
    [kCADataCacheHandle saveAppPath:_appPath];
    if (_appPath) {
        _targetName = [[[_appPath lastPathComponent] componentsSeparatedByString:@"."] firstObject]?:@"";
        [_targetNameTextField setStringValue:_targetName];
    }
}

- (IBAction)selectOutPath:(id)sender {
    CALogJunJie(@"选择out文件路径！");
    _outPath =  [self chooseDirectorie];
    _outPathTextField.stringValue = _outPath?:@"";
    [kCADataCacheHandle saveOutPath:_outPath];
}

- (IBAction)analyzeClick:(id)sender {
    CALogJunJie(@"分析！");
    [kCADataCacheHandle saveCommandPath:_commandPath];
    [kCADataCacheHandle saveDsymPath:_dsymPath];
    [kCADataCacheHandle saveCrashPath:_crashPath];
    [kCADataCacheHandle saveAppPath:_appPath];
    [kCADataCacheHandle saveOutPath:_outPath];
    
    BOOL isSuccess = NO;//是否成功执行
    
    NSString *info = @"";
    
    BOOL isEXE = NO;//是否具备执行的条件 commamdPath存在就说明具备执行条件
    
    BOOL isAnalyse = NO;//是否具备分析的条件  只要app文件、dsym文件和日志文件存在切UUID一样就说名具备正确分析的条件
    
//    1.校验参数
    if ([JJFileUtil isFileExist:_commandPath]) {
        isEXE = YES;
        if ([JJFileUtil isFileExist:_dsymPath] && [JJFileUtil isFileExist:_appPath] && [JJFileUtil isFileExist:_crashPath]) {
            isAnalyse = YES;
        } else {
            info = @"请检查dsym、app、crash文件是否存在！";
        }
    } else {
        info = @"找不到命令分析文件！";
    }
    
    __block BOOL isUUID = NO;
//    2.校验UUID
    if (isEXE && isAnalyse) {
        
        _dwarfdumpPath = [[self exeCommand:@"/usr/bin/whereis" environment:nil arguments:@[@"dwarfdump"]] trim];
        
        if (_dwarfdumpPath && _dwarfdumpPath.length > 0) {
            NSString *appRes = [self exeCommand:_dwarfdumpPath environment:nil arguments:@[@"-u",[NSString stringWithFormat:@"%@/%@",_appPath,_targetName]]];
            NSMutableDictionary *appResDic = [[NSMutableDictionary alloc] init];
            [appRes enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
                NSArray *arr = [line componentsSeparatedByString:@" "];
                if ([arr count] > 3) {
                    [appResDic setObject:arr forKey:arr[2]];
                }
            }];
            NSString *dsymRes = [self exeCommand:_dwarfdumpPath environment:nil arguments:@[@"-u",_dsymPath]];
            NSMutableDictionary *dsymResDic = [[NSMutableDictionary alloc] init];
            [dsymRes enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
                NSArray *arr = [line componentsSeparatedByString:@" "];
                if ([arr count] > 3) {
                    [dsymResDic setObject:arr forKey:arr[2]];
                }
            }];
            [appResDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSArray *arr = dsymResDic[key];
                if (arr && [arr count] > 0) {
                    if ([arr[1] isEqualToString:obj[1]]) {
                        NSString *uuid = [arr[1] stringByReplacingOccurrencesOfString:@"-" withString:@""];
                        NSError *error = nil;
                        NSString *crashStr = [NSString stringWithContentsOfFile:_crashPath encoding:NSUTF8StringEncoding error:&error];
                        if (!error) {
                            __block BOOL isRight = NO;
                            [crashStr enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
                                if ([line rangeOfString:uuid options:NSCaseInsensitiveSearch].location != NSNotFound) {
                                    isRight = YES;
                                    *stop = YES;
                                }
                            }];
                            if (isRight) {
                                isUUID = YES;
                                *stop = YES;
                            }
                        }
                    }
                }
            }];
            
            if (isUUID) {
                NSString *res = [self exeCommand:_commandPath environment:@{@"DEVELOPER_DIR":@"/Applications/Xcode.app/Contents/Developer"} arguments:@[[NSString stringWithFormat:@"%@",_crashPath]]];
                CALogJunJie(@"%@",res);
                NSString *savePath = [NSString stringWithFormat:@"%@/%@.log",_outPath,[_crashPath lastPathComponent]];
                [res writeToFile:savePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
                isSuccess = YES;
                info = [NSString stringWithFormat:@"Done:%@",savePath];
            }
        } else {
            info = @"找不到dwarfdump命令，无法比较UUID";
        }
    }
    [_infoTextField setStringValue:info?:@""];
}

#pragma mark - Private
- (NSString *)chooseFile {
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
    CALogJunJie(@"%@",url);
    return [url path];
}

- (NSString *)chooseDirectorie {
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
    CALogJunJie(@"%@",url);
    return [url path];
}

- (NSString *)exeCommand:(NSString *)commandPath environment:(NSDictionary *)environment arguments:(NSArray *)arguments {
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:commandPath];
    if (environment) {
        [task setEnvironment:environment];
    }
    
    if (arguments) {
        [task setArguments:arguments];
    }
    
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    
    NSFileHandle *file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data = [file readDataToEndOfFile];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
