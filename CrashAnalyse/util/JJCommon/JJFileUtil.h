//
//  JJFileUtil.h
//  JJCommon
//
//  Created by lijunjie on 4/30/15.
//  Copyright (c) 2015 lijunjie. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  对沙盒基本操作的具体实现，全部都是类方法
 */
@interface JJFileUtil : NSObject
{
    
}

/**
 *	@brief	获取应用程序的文档目录
 *
 *	@return	文档目录路径
 */
+ (NSString *)getDocmentPath;

/**
 *	@brief	获取应用程序库目录
 *
 *	@return	库目录路径
 */
+ (NSString *)getLibraryPath;

/**
 *	@brief	获取应用程序缓存目录
 *
 *	@return	缓存目录路径
 */
+ (NSString *)getTempPath;

/**
 *	@brief	应用程序home路径,即沙盒路径
 *
 *	@return home目录路径
 */
+ (NSString *)getHomePath;

/**
 *	@brief	获取文件在doc目录下的对应文件的全路径
 *
 *	@param 	fileName 	文件名
 *
 *	@return	路径名
 */
+ (NSString *)getDocPathWithFileName:(NSString *)fileName;

/**
 *	@brief	获取文件在tmp目录下的全路径
 *
 *	@param 	fileName 	文件名
 *
 *	@return	路径名
 */
+ (NSString *)getTmpPathWithFileName:(NSString *)fileName;

/**
 *	@brief	删除应用程序Document目录中的指定文件
 *
 *	@param 	fileName 	文件名
 *
 *	@return	YES 删除成功   NO  删除失败
 */
+ (BOOL)deleteFileInDocFolder:(NSString *)fileName;

/**
 *	@brief	删除文件
 *
 *	@param 	path 	文件路径
 *
 *
 */
+ (void)deleteFileWithPath:(NSString *)path;

/**
 *	@brief	删除指定文件夹下指定文件名的文件
 *
 *	@param 	folder 	文件夹
 *	@param 	fileName 	文件名
 *
 *	@return	YES 删除成功   NO  删除失败
 */
+ (BOOL)deleteFileInFolder:(NSString *)folder withFileName:(NSString *)fileName;

/**
 *	@brief	删除文件夹,文件夹以及下面的子文件夹和文件都将删除
 *
 *	@param 	folderPath 	文件夹路径
 *
 *	@return	YES 删除成功   NO  删除失败
 */
+ (BOOL)deleteFolder:(NSString *)folderPath;

/**
 *	@brief	获取目录下第一级的所有文件
 *
 *	@param 	folderPath 	文件夹路径
 *
 *	@return	文件数组
 */
+ (NSArray *)getAllFilesAtFolder:(NSString *)folderPath;

/**
 *	@brief	判断文件是否存在
 *
 *	@param 	filePath 	文件路径
 *
 *	@return	YES 存在  NO  不存在
 */
+ (BOOL)isFileExist:(NSString *)filePath;

/**
 *	@brief	将对想写如文件中
 *
 *	@param 	object 	要写入的对象
 *	@param 	filePath 	写入的路径
 *	@param 	atomically 	是否覆盖以前的文件
 */
+ (BOOL)saveToFile:(id)object filePath:(NSString *)filePath atomically:(BOOL)atomically;

/**
 *  @brief  根据数据类型调用相应的根据文件创建的对象
 *
 *  @param aClass    类型描述
 *  @param aFilePath 文件路径
 *
 *  @return 返回根据文件创建的具体对象
 */
+ (id)getObjectWithClassString:(Class)aClass aFilePath:(NSString *)aFilePath;

/**
 *	@brief	获取文件大小
 *
 *	@param 	filePath 	文件路径
 *
 *	@return	文件大小
 */
+ (int)getFileSize:(NSString *)filePath;

/**
 *	@brief	获取文件夹中所有文件大小
 *
 *	@param 	folderPath 	文件夹路径
 *
 *	@return	文件夹大小
 */
+ (int)getFolderSize:(NSString *)folderPath;

/**
 *	@brief	创建目录
 *
 *	@param 	path   文件路径，文件名为路径的最后一个字段
 *
 *
 */
+ (void)createPath:(NSString *)path;

/**
 *	@brief	创建文件
 *
 *	@param 	path   文件路径,目录必须存在
 *
 *
 */
+ (void)createFile:(NSString *)file;

/**
 *	@brief	创建文件和路径,文件内容为空
 *
 *	@param 	path   文件路径
 *
 *
 */
+ (void)createFilePath:(NSString *)filePath;

/**
 *	@brief	获得mainBundle的文件路径
 *
 *	@param 	fileName 	文件名
 *
 *	@return	返回路径
 */
+ (NSString *)getFilePathWithMainBundle:(NSString *)fileName;

/**
 *	@brief	复制文件
 *
 *	@param 	srcPath 	源路径
 *	@param 	toPath 	目标路径
 *
 *	@return	返回拷贝是否成功 YES成功 NO不成功
 */
+ (BOOL)copyFile:(NSString *)srcPath toPath:(NSString *)toPath;

@end