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
#define GJGC_LOG_ASYNC_ON


#ifdef GJGC_LOG_ASYNC_ON

#define GJGC_LOG_ASYNC YES

#else

#define GJGC_LOG_ASYNC NO

#endif


/**
 *  GJGC日志总开关
 */
#define GJGCLogOn

#ifdef GJGCLogOn

/**
 *  注释这行取消ljj日志输出,取消注释打开,标示符号 $JJ$
 */
#define GJGCLOG_JUN_JIE_TAG

/**
 *  开启同步日志输出
 */
#define GJGCLOG_SYNC_LOG_TAG

#endif



#ifdef GJGCLOG_JUN_JIE_TAG

    #define GJGCLogJunJie_Enter   //log中加上回车

    #ifdef GJGCLogJunJie_Enter

        #define GJGCLogJunJie(frmt, ...) LOG_OBJC_MAYBE(GJGC_LOG_ASYNC, LOG_LEVEL_DEF, LOG_FLAG_VERBOSE, 0, @"$JJ$ => \n\n"frmt@"\n",## __VA_ARGS__)

    #else

        #define GJGCLogJunJie(frmt, ...) LOG_OBJC_MAYBE(GJGC_LOG_ASYNC, LOG_LEVEL_DEF, LOG_FLAG_VERBOSE, 0, @"$JJ$ => "frmt,## __VA_ARGS__)

    #endif

#else

    #define GJGCLogJunJie(frmt, ...)

#endif



#ifdef GJGCLOG_SYNC_LOG_TAG

#define GJGCLOG_SYNC_LOG(frmt, ...) SYNC_LOG_OBJC_MAYBE(LOG_LEVEL_DEF, LOG_FLAG_VERBOSE, 0, @"$SYNC_LOG$ => "frmt,## __VA_ARGS__)

#else

#define GJGCLOG_SYNC_LOG(frmt, ...)

#endif



#endif
