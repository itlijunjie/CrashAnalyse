//
//  NSString+JJStringUtil.h
//  JJCommon
//
//  Created by lijunjie on 4/30/15.
//  Copyright (c) 2015 lijunjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JJStringUtil)
/**
 *  根据UUID创建一个NSString
 *
 *  @return 返回一个唯一的NSString
 */
+ (NSString *)stringWithUUID;

/**
 *  根据一个十六进制字符串创建一个NSString
 *
 *  @param src 十六进制字符串的指针
 *  @param len 字符串长度
 *
 *  @return 返回穿件好的NSString
 */
+ (NSString *)stringWithHexString:(u_char*)src length:(int)len;

/**
 *  根据一个C字符创建一个NSString
 *
 *  @param cValue C字符
 *
 *  @return C字符的NSString表示
 */
+ (NSString *)stringWithCharString:(u_char) cValue;

/**
 *  根据一个十六进制数的十进制表示创建一个十六进制的NSString表示
 *
 *  @param nValue 十六进制数的十进制表示
 *
 *  @return 返回十六进制数对应的NSString
 */
+ (NSString *)stringWithDecimalNum:(u_char) nValue;

/**
 *
 *  @return 返回一个boo值表示是否纯数字
 */
- (BOOL)isStringDigit;

/**
 *  判断一个字符串是否以emoji4表情结束（删除输入内容时使用）
 *
 *  @param string 要判断的字符串
 *
 *  @return yes 是，no 否
 */
- (BOOL)isStringEndWithEmoji:(NSString*)string;

/**
 *  判断一个字符串是否包含emoji4表情
 *
 *  @param string 要校验的字符串
 *
 *  @return 是否包含emoji4表情
 */
- (BOOL)isStringHaveEmoji:(NSString*)string;

/**
 *	@brief	对字符串进行特殊字符编码处理
 *
 *	@param 	inputStr 	输入字符
 *
 *	@return	编码后的字符
 */
+ (NSString *)encodeSpecialChar:(NSString*)inputStr;

/**
 *	@brief	对字符串进行特殊字符反编码处理
 *
 *	@param 	inputStr 	输入字符
 *
 *	@return	编码前的字符
 */
+ (NSString *)unencodeSpecialChar:(NSString*)inputStr;

/**
 *  过滤掉一些特殊 转义的字符
 *
 *  @param inputStr 输入字符串
 *
 *  @return 返回过滤有的字符串
 */
+ (NSString *)filtreSpecialChar:(NSString*)inputStr;

/**
 *	@brief	判断字符串是否为空
 *
 *	@return	YES/NO
 */
- (BOOL)isEmptyOrNull;

/**
 *	@brief	解析url
 *
 *	@return	字典
 */
+ (NSDictionary *)parseURL:(NSString*) oriString;

/**
 *  string trim
 *
 *  @return <#return value description#>
 */
- (NSString *)trim;

/**
 *  <#Description#>
 *
 *  @param beginStr <#beginStr description#>
 *  @param endStr   <#endStr description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)subStringBegin:(NSString *)beginStr end:(NSString *)endStr;

/**
 *  <#Description#>
 *
 *  @param endStr <#endStr description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)subStringTrimEnd:(NSString *)endStr;

/**
 *  使用系统的stringWithCString 自动返回空
 *
 *  @param cString
 *  @param enc
 *
 *  @return
 */
+ (instancetype)stringWithCStringWithOutNull:(const char *)cString encoding:(NSStringEncoding)enc;

/**
 *  <#Description#>
 *
 *  @param size <#size description#>
 *
 *  @return <#return value description#>
 */
+ (NSString*)getSizeString:(NSInteger)size;

@end
