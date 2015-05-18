//
//  CALoggerUitilsMacrocDefine.h
//  CrashAnalyse
//
//  Created by lijunjie on 5/15/15.
//  Copyright (c) 2015 lijunjie. All rights reserved.
//

#ifndef CrashAnalyse_CALoggerUitilsMacrocDefine_h
#define CrashAnalyse_CALoggerUitilsMacrocDefine_h

//异步打印日志开关
#define CA_LOG_ASYNC_ON


#ifdef CA_LOG_ASYNC_ON

#define CA_LOG_ASYNC YES

#else

#define CA_LOG_ASYNC NO

#endif


/**
 *  CA日志总开关
 */
#define CALogOn

#ifdef CALogOn

/**
 *  注释这行取消ljj日志输出,取消注释打开,标示符号 $JJ$
 */
#define CALOG_JUN_JIE_TAG

/**
 *  开启同步日志输出
 */
#define CALOG_SYNC_LOG_TAG

#endif



#ifdef CALOG_JUN_JIE_TAG

    #define CALogJunJie_Enter   //log中加上回车

    #ifdef CALogJunJie_Enter

        #define CALogJunJie(frmt, ...) LOG_OBJC_MAYBE(CA_LOG_ASYNC, LOG_LEVEL_DEF, LOG_FLAG_VERBOSE, 0, @"$JJ$ => \n\n"frmt@"\n",## __VA_ARGS__)

    #else

        #define CALogJunJie(frmt, ...) LOG_OBJC_MAYBE(CA_LOG_ASYNC, LOG_LEVEL_DEF, LOG_FLAG_VERBOSE, 0, @"$JJ$ => "frmt,## __VA_ARGS__)

    #endif

#else

    #define CALogJunJie(frmt, ...)

#endif



#ifdef CALOG_SYNC_LOG_TAG

#define CALOG_SYNC_LOG(frmt, ...) SYNC_LOG_OBJC_MAYBE(LOG_LEVEL_DEF, LOG_FLAG_VERBOSE, 0, @"$SYNC_LOG$ => "frmt,## __VA_ARGS__)

#else

#define CALOG_SYNC_LOG(frmt, ...)

#endif



#endif
