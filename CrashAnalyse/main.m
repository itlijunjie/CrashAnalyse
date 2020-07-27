//
//  main.m
//  CrashAnalyse
//
//  Created by lijunjie on 5/14/15.
//  Copyright (c) 2015 lijunjie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CAAppDelegate.h"

int main(int argc, const char * argv[]) {
//    return NSApplicationMain(argc, argv);
    @autoreleasepool {
      NSApplication * application = [NSApplication sharedApplication];
      NSMenu *mainMenu = [[NSMenu alloc] initWithTitle:@"CrashAnalyse"];
      [NSApp setMainMenu:mainMenu];
      CAAppDelegate * appDelegate = [[CAAppDelegate alloc] init];
      [application setDelegate:appDelegate];
      if (argc > 1) {
        NSMutableArray *argvArray = [[NSMutableArray alloc] init];
        for (int i = 1; i < argc; i++) {
          [argvArray addObject:[[NSString alloc] initWithUTF8String:argv[i]]];
        }
        [appDelegate setArgv:argvArray];
      } else {
        [appDelegate setArgv:[[NSArray alloc] init]];
      }

      [application run];
      return EXIT_SUCCESS;
    }
}
