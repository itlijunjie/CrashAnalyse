//
//  NSString+JJStringUtil.m
//  JJCommon
//
//  Created by lijunjie on 4/30/15.
//  Copyright (c) 2015 lijunjie. All rights reserved.
//

#import "NSString+JJStringUtil.h"

@implementation NSString (JJStringUtil)
+ (NSString *)stringWithUUID;
{
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return uuidString;
}

+ (NSString *)stringWithHexString:(u_char*)src length:(int)len;
{
    if (len == 0)
    {
        return @"";
    }
    const char* szNum = "0123456789ABCDEF";
    char* lpDest = (char*)malloc(len*2+1);
    // Parse the chars
    int i=0;
    for (; i<len; i++)
    {
        //char oneChar = src[i];
        //buf = [buf stringByAppendingString:[self char2String:oneChar]];
        lpDest[i*2] = szNum[(src[i] &0xf0) >> 4];
        lpDest[i*2+1] = szNum[(src[i] &0x0f)];
    }
    lpDest[i*2+2] = 0;
    NSString* buf =  [NSString stringWithCString:lpDest encoding:NSASCIIStringEncoding];
    free(lpDest);
    return buf;
}

+ (NSString *)stringWithCharString:(u_char) cValue;
{
    NSString* buf=@"";
    uint nDiv = cValue/16;
    uint nMod = cValue%16;
    buf = [buf  stringByAppendingString:[self stringWithDecimalNum:nDiv]];
    buf = [buf  stringByAppendingString:[self stringWithDecimalNum:nMod]];
    return buf;
}

+ (NSString *)stringWithDecimalNum:(u_char) nValue;
{
    NSString* tmp = @"";
    switch(nValue)
    {
        case 0:tmp = @"0";break;
        case 1:tmp = @"1";break;
        case 2:tmp = @"2";break;
        case 3:tmp = @"3";break;
        case 4:tmp = @"4";break;
        case 5:tmp = @"5";break;
        case 6:tmp = @"6";break;
        case 7:tmp = @"7";break;
        case 8:tmp = @"8";break;
        case 9:tmp = @"9";break;
        case 10:tmp = @"A";break;
        case 11:tmp = @"B";break;
        case 12:tmp = @"C";break;
        case 13:tmp = @"D";break;
        case 14:tmp = @"E";break;
        case 15:tmp = @"F";break;
        default:tmp = @"X";
            break;
    }
    return tmp;
}

/**
 *
 *  @return 返回一个boo值表示是否纯数字
 */
- (BOOL)isStringDigit
{
    NSString *tempString = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    
    if ([tempString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]].length >0)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

/**
 *  判断两个字符是否为emoji4的控制位
 *
 *  @param c1 第一个字符
 *  @param c2 第二个字符
 *
 *  @return 是否为emoji4控制字符
 */
- (BOOL)isEmojiCharacter:(const unichar)c1 character2:(const unichar)c2
{
    BOOL returnValue = NO;
    
    if (0xd800 <= c1 && c1 <= 0xdbff) {
        const int uc = ((c1 - 0xd800) * 0x400) + (c2 - 0xdc00) + 0x10000;
        
        if (0x1d000 <= uc && uc <= 0x1f77f) {
            returnValue = YES;
        }
    }
    else{
        if (c2 == 0x20e3) {
            returnValue = YES;
        }
    }
    
    return returnValue;
}

/**
 *  判断一个字符串是否包含emoji4表情
 *
 *  @param string 要校验的字符串
 *
 *  @return 是否包含emoji4表情
 */
- (BOOL)isStringHaveEmoji:(NSString*)string
{
    //emoji4每个表情4个字节，判断控制位是否是emoji4的表情控制位
    for (int i = 0; i < string.length - 1; i++) {
        const unichar c1 = [string characterAtIndex:i];
        const unichar c2 = [string characterAtIndex:i+1];
        
        if ([self isEmojiCharacter:c1 character2:c2]) {
            return YES;
        }
    }
    
    return NO;
}

/**
 *  判断一个字符串是否以emoji4表情结束（删除输入内容时使用）
 *
 *  @param string 要判断的字符串
 *
 *  @return yes 是，no 否
 */
- (BOOL)isStringEndWithEmoji:(NSString*)string
{
    //截取最后4个字节，判断是否是emoji4表情
    NSString *subString = [string substringWithRange:NSMakeRange([string length] - 2, 2)];
    
    return [self isStringHaveEmoji:subString];
}

/**
 *	@brief	对字符串进行特殊字符编码处理
 *
 *	@param 	inputStr 	输入字符
 *
 *	@return	编码后的字符
 */
+ (NSString *)encodeSpecialChar:(NSString*)inputStr
{
    if (!inputStr || [inputStr length] == 0)
    {
        return @"";
    }
    
    NSString* str = [NSString stringWithString:inputStr];;
    str = [str stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    str = [str stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    str = [str stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    str = [str stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];
    str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
    return str;
}

/**
 *	@brief	对字符串进行特殊字符反编码处理
 *
 *	@param 	inputStr 	输入字符
 *
 *	@return	编码前的字符
 */
+ (NSString *)unencodeSpecialChar:(NSString*)inputStr
{
    if (!inputStr || [inputStr length] == 0)
    {
        return @"";
    }
    
    NSString* str = [NSString stringWithString:inputStr];
    str = [str stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    str = [str stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    str = [str stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    str = [str stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    str = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    str = [str stringByReplacingOccurrencesOfString:@"&copy;" withString:@"©"];
    str = [str stringByReplacingOccurrencesOfString:@"&reg" withString:@"®"];
    str = [str stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    str = [str stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    str = [str stringByReplacingOccurrencesOfString:@"&#xa;" withString:@"\n"];
    str = [str stringByReplacingOccurrencesOfString:@"&#xd;" withString:@"\r"];
    return str;
}

+ (NSString *)filtreSpecialChar:(NSString*)inputStr
{
    if (!inputStr || [inputStr length] == 0)
    {
        return @"";
    }
    
    NSString *str = [NSString stringWithString:inputStr];
    str = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    return str;
}

#pragma mark -
/*{CMC|http://221.179.173.107:80/ncfp/blockdownload?id=d0d9f9207861ae779b9388bfcf3fdcd2;CUC|http://221.179.173.107:80/ncfp/blockdownload?id=d0d9f9207861ae779b9388bfcf3fdcd2;CTC|http://221.179.173.107:80/ncfp/blockdownload?id=d0d9f9207861ae779b9388bfcf3fdcd2}*/
/*{cmc|http://221.179.173.107:80/ncfp/blockdownload?id=33ec3e67025faf8354c900aede94847c;cuc|http://221.179.173.107:80/ncfp/blockdownload?id=33ec3e67025faf8354c900aede94847c;ctc|http://221.179.173.107:80/ncfp/blockdownload?id=33ec3e67025faf8354c900aede94847c}&thumb=thumb-weak*/
+(NSDictionary*) parseURL:(NSString*) oriString
{
    NSString *newStr = nil;
    if ( [oriString hasPrefix:@"{"]) {
        newStr = [oriString substringFromIndex:1];
    }
    if ([newStr hasSuffix:@"}"]) {
        newStr = [newStr substringToIndex:newStr.length-1];
    }
    else if([newStr hasSuffix:@"}&thumb=thumb-weak"])
    {
        if (newStr.length>18)
        {
            newStr = [newStr substringToIndex:newStr.length-18];
        }
    }
    
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSArray *array = [newStr componentsSeparatedByString:@";"];
    for (NSString *urlStr in array) {
        NSArray *tempArr = [urlStr componentsSeparatedByString:@"|"];
        if ([tempArr count]>1)
        {
            NSString* key = [tempArr objectAtIndex:0];
            [mDic setObject:[tempArr objectAtIndex:1] forKey:[key lowercaseString]];
        }
    }
    return mDic;
}

+ (NSString*)getSizeString:(NSInteger)size
{
    float ret = size / 1024.0 / 1024.0;
    if (ret > 1)
    {
        return [NSString stringWithFormat:@"%0.1f%@", ret, @"M"];
    }
    else
    {
        return [NSString stringWithFormat:@"%ld%@", size / 1024, @"KB"];
    }
}

- (NSString *)trim
{
    NSString *str = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return str;
}

- (BOOL)isEmptyOrNull
{
    NSString* trimStr = [self trim];
    if ([trimStr length] == 0) {
        return YES;
    }
    
    return NO;
}

- (NSString *)subStringBegin:(NSString *)beginStr end:(NSString *)endStr
{
    NSRange range1 = [self rangeOfString:beginStr options:NSCaseInsensitiveSearch];
    NSRange range2 = [self rangeOfString:endStr options:NSCaseInsensitiveSearch];
    
    if (range1.location == NSNotFound || range2.location == NSNotFound)
    {
        return nil;
    }
    
    NSRange range3 = {range1.location + range1.length, range2.location - range1.location - range1.length };
    NSString *key = [self substringWithRange: range3];
    
    return [key trim];
}

- (NSString *)subStringTrimEnd:(NSString *)endStr
{
    NSRange range = [self rangeOfString:endStr options:NSCaseInsensitiveSearch];
    if (range.location == NSNotFound)
    {
        return nil;
    }
    
    NSRange rangeKey = {0, range.location};
    NSString *key = [self substringWithRange:rangeKey];
    
    return [key trim];
}

+ (instancetype)stringWithCStringWithOutNull:(const char *)cString encoding:(NSStringEncoding)enc
{
    if (cString == NULL)
    {
        return @"";
    }
    else
    {
        NSString *string = [NSString stringWithCString:cString encoding:enc];
        
        if (string == nil) {
            return @"";
        }
        else{
            return string;
        }
    }
}
@end
