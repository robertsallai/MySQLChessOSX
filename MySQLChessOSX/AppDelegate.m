//
//  AppDelegate.m
//  MySQLChessOSX
//
//  Created by Robert Sallai on 9/19/13.
//  Copyright (c) 2013 Robert Sallai. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "GameBrowserViewController.h"
#import "ChessBoardViewController.h"

#import <QuartzCore/CAAnimation.h>

@interface AppDelegate()

@end

@implementation AppDelegate

#define left 0
#define right 1
#define top 2
#define bottom 3

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  // Insert code here to initialize your application
  [self changeViewControllerTo:@"LoginViewController"
                     Direction:top];
}

# pragma mark ViewController methods

- (void) changeViewControllerTo:(NSString *)nibName
                      Direction:(NSUInteger)direction
{
  
  CATransition *transition = [CATransition animation];
  [transition setType:kCATransitionPush];
  [transition setDuration:0.25];
  switch (direction) {
    case left:
        [transition setSubtype:kCATransitionFromLeft];
      break;
      
    case right:
      [transition setSubtype:kCATransitionFromRight];
      break;
      
    case top:
      [transition setSubtype:kCATransitionFromTop];
      [transition setDuration:0.75];
      break;
      
    case bottom:
      [transition setSubtype:kCATransitionFromBottom];
      break;
      
    default:
      break;
  }
  
  [self.currentView setAnimations:[NSDictionary dictionaryWithObject:transition forKey:@"subviews"]];
  [self.currentView setWantsLayer:YES];
  
  [[[self.currentViewController view] animator] removeFromSuperview];
  [[self.currentViewController view] removeFromSuperview];
  if ([nibName isEqualToString:@"LoginViewController"])
  {
    self.currentViewController = [[LoginViewController alloc] initWithNibName:nibName bundle:nil];
  }
  else if([nibName isEqualToString:@"GameBrowserViewController"])
  {
    self.currentViewController = [[GameBrowserViewController alloc] initWithNibName:nibName bundle:nil];
  }
  else if ([nibName isEqualToString:@"ChessBoardViewController"]){
    self.currentViewController = [[ChessBoardViewController alloc] initWithNibName:nibName bundle:nil];
  }
  
  [[self.currentViewController view] setFrame:[self.currentView bounds]];
  [[self.currentView animator] addSubview:[self.currentViewController view]];

}

@end
