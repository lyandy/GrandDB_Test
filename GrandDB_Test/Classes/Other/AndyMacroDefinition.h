//
//  AndyMacroDefinition.h
//  GrandDB_Test
//
//  Created by 李扬 on 2017/2/13.
//  Copyright © 2017年 andyshare. All rights reserved.
//

#ifndef AndyMacroDefinition_h
#define AndyMacroDefinition_h

// 自定义Log
#ifdef DEBUG
#define AndyLog(format, ...) printf("\n[%s] [%s] %s [第%d行] %s\n", __TIME__, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String])
#else
#define AndyLog(format, ...)
#endif

#define AndyNotificationCenter [NSNotificationCenter defaultCenter]

#endif /* AndyMacroDefinition_h */
