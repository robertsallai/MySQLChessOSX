//
//  ChessBoardViewController.m
//  MySQLChessOSX
//
//  Created by Robert Sallai on 10/12/13.
//  Copyright (c) 2013 Robert Sallai. All rights reserved.
//

#import "ChessBoardViewController.h"
#import "ChessBoardView.h"
#import "AppDelegate.h"
#import "SocketConnection.h"

@interface ChessBoardViewController ()

@property (strong, nonatomic) SocketConnection  *connection;

@end

#define left 0
#define right 1

@implementation ChessBoardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
      self.connection = [SocketConnection getSingletonInstance];
      [self.connection.inputStream setDelegate:self];
      [self.connection.outputStream setDelegate:self];
    }
    return self;
}
- (IBAction)Back:(id)sender {

  AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
  
  [appDelegate changeViewControllerTo:@"GameBrowserViewController"
                            Direction:left];
}

@end