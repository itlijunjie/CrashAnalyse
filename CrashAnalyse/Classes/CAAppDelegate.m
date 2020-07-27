//
//  CAAppDelegate.m
//  CrashAnalyse
//
//  Created by lijunjie on 2020/7/27.
//  Copyright © 2020 lijunjie. All rights reserved.
//

#import "CAAppDelegate.h"
#import "CAViewController.h"

@implementation CAAppDelegate

- (id)init {
  if(self = [super init]) {
      NSRect contentSize = NSMakeRect(200, 500, 550, 650); // initial size of main NSWindow
      NSWindow *window = [[NSWindow alloc] initWithContentRect: contentSize
                                                     styleMask: NSWindowStyleMaskTitled |
                                                                NSWindowStyleMaskResizable |
//                                                                NSWindowStyleMaskFullSizeContentView |
                                                                NSWindowStyleMaskMiniaturizable |
                                                                NSWindowStyleMaskClosable
                                                       backing:NSBackingStoreBuffered
                                                         defer:NO];
      window.title = @"CrashAnalyse";
      self.window = window;
      NSWindowController *windowController = [[NSWindowController alloc] initWithWindow:self.window];
      [self.window setTitleVisibility:NSWindowTitleVisible];
      [[self window] setTitlebarAppearsTransparent:YES];
      [[self window] setAppearance:[NSAppearance appearanceNamed:NSAppearanceNameAqua]];
      
      [windowController setShouldCascadeWindows:NO];
      [windowController setWindowFrameAutosaveName:@"CrashAnalyse"];
      [windowController showWindow:self.window];
      [self setUpApplicationMenu];
  }
  return self;
}


- (void)applicationDidFinishLaunching:(__unused NSNotification *)aNotification {
    CAViewController *vc = [[CAViewController alloc] initWithNibName:@"CAViewController" bundle:nil];
    // try NSVisualEffectMaterialDark or NSVisualEffectMaterialMediumLight
    [self.window setContentViewController:vc];
}

- (void)setUpApplicationMenu {
  NSMenuItem *containerItem = [[NSMenuItem alloc] init];
  NSMenu *rootMenu = [[NSMenu alloc] initWithTitle:@""];
  [containerItem setSubmenu:rootMenu];
  [rootMenu addItemWithTitle:@"Quit CrashAnalyse" action:@selector(terminate:) keyEquivalent:@"q"];
  [[NSApp mainMenu] addItem:containerItem];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
  return NO;
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag {
    if (flag) {
        return NO;
    } else {
        [self.window makeKeyAndOrderFront:self];
        return YES;
    }
}

@end
