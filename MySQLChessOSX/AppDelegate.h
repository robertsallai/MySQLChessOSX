//
//  AppDelegate.h
//  MySQLChessOSX
//
//  Created by Robert Sallai on 9/19/13.
//  Copyright (c) 2013 Robert Sallai. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSStreamDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (weak, nonatomic) IBOutlet NSView *currentView;
@property (strong, nonatomic) NSViewController *currentViewController;

- (void) changeViewControllerTo:(NSString *)nibName
                      Direction:(NSUInteger)direction;

@end
