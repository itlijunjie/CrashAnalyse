//
//  JJFileUtil.m
//  JJCommon
//
//  Created by lijunjie on 4/30/15.
//  Copyright (c) 2015 lijunjie. All rights reserved.
//

#import "JJFileUtil.h"
#import <CommonCrypto/CommonDigest.h>

@interface JJFileUtil ()
{
    
}

@end

@implementation JJFileUtil

+ (NSString *)getDocmentPath
{
    NSArray *userPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [userPaths objectAtIndex:0];
}

+ (NSString *)getLibraryPath
{
    NSArray *userPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [userPaths objectAtIndex:0];
}

+ (NSString *)getTempPath
{
    return NSTemporaryDirectory();
}

+ (NSString *)getHomePath
{
    return NSHomeDirectory();
}

+ (NSString *)getDocPathWithFileName:(NSString *)fileName
{
    NSString *destFileFullPath = [JJFileUtil getDocmentPath];
    return [destFileFullPath stringByAppendingPathComponent:fileName];
}

+ (NSString *)getTmpPathWithFileName:(NSString *)fileName
{
    NSString *destFileFullPath = [JJFileUtil getTempPath];
    return [destFileFullPath stringByAppendingPathComponent:fileName];
}

+ (void)createPath:(NSString*)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path])
    {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+ (void)createFile:(NSString*)file
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:file])
    {
        [fileManager createFileAtPath:file contents:nil attributes:nil];
    }
}

+ (void)createFilePath:(NSString*)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath])
    {
        [JJFileUtil createPath:[filePath stringByDeletingLastPathComponent]];
        [JJFileUtil createFile:filePath];
    }
}

+ (BOOL)deleteFileInDocFolder:(NSString *)fileName
{
    return [JJFileUtil deleteFileInFolder:[JJFileUtil getDocmentPath] withFileName:fileName];
}

+ (void)deleteFileWithPath:(NSString *)path
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}

+ (BOOL)deleteFileInFolder:(NSString *)folder withFileName:(NSString *)fileName
{
    NSString *destFileFullPath = [folder stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:destFileFullPath])
    {
        return NO;
    }
    return [fileManager removeItemAtPath:destFileFullPath error:nil];
}

+ (BOOL)deleteFolder:(NSString *)folderPath
{
    return [JJFileUtil deleteFileInFolder:folderPath withFileName:@""];
}

+ (NSArray *)getAllFilesAtFolder:(NSString *)folderPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager contentsOfDirectoryAtPath:folderPath error:nil];
}

+ (BOOL)isFileExist:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return ([fileManager fileExistsAtPath:filePath]);
}

+ (BOOL)saveToFile:(id)object filePath:(NSString *)filePath atomically:(BOOL)atomically
{
    BOOL isOk = NO;
    [JJFileUtil createPath:[filePath stringByDeletingLastPathComponent]];
    isOk = [object writeToFile:filePath atomically:atomically];
    if (isOk)
    {
//        [[NSFileManager defaultManager] setAttributes:nil ofItemAtPath:filePath error:nil];
    }
    return isOk;
}

+ (id)getObjectWithClassString:(Class)aClass aFilePath:(NSString *)aFilePath
{
    __autoreleasing id object = [[NSClassFromString([aClass description]) alloc] initWithContentsOfFile:aFilePath];
    return object;
}

+ (int)getFileSize:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *dic = [fileManager attributesOfItemAtPath:filePath error:nil];
    NSNumber *fileSize = [dic objectForKey:NSFileSize];
    return [fileSize intValue];
}

+ (int)getFolderSize:(NSString *)folderPath
{
    int iFolderSize = 0;
    
    NSArray* fileArray = [JJFileUtil getAllFilesAtFolder:folderPath];
    
    for (NSString *file in fileArray)
    {
        NSString *fullPath = [folderPath stringByAppendingPathComponent:file];
        
        if([file.pathExtension length] > 0)
        {
            iFolderSize += [JJFileUtil getFileSize:fullPath];
        }
        else
        {
            iFolderSize += [JJFileUtil getFolderSize:fullPath];
        }
    }
    
    return iFolderSize;
}

+ (NSString *)getFilePathWithMainBundle:(NSString *)fileName;
{
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
}

+ (BOOL)copyFile:(NSString *)srcPath toPath:(NSString *)toPath
{
    BOOL isOk = YES;
    if (![[NSFileManager defaultManager] fileExistsAtPath:toPath])
    {
        NSError *error = nil;
        [JJFileUtil createPath:[toPath stringByDeletingLastPathComponent]];
        [[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:toPath error:&error];
//        [[NSFileManager defaultManager] setAttributes:nil ofItemAtPath:toPath error:&error];
        if (error)
        {
            isOk = NO;
        }
    }
    return isOk;
}

@end
