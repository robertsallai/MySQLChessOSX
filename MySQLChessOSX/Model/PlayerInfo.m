//
//  PlayerInfo.m
//  MySQLChessOSX
//
//  Created by Robert Sallai on 10/13/13.
//  Copyright (c) 2013 Robert Sallai. All rights reserved.
//
// Singleton for Storing player information with GCD dispatch

#import "PlayerInfo.h"

@implementation PlayerInfo


+ (PlayerInfo *) getSingletonInstance
{
  
  static PlayerInfo *sharedPlayerInfo = nil;
  static dispatch_once_t onceToken;
  
  dispatch_once(&onceToken, ^{ sharedPlayerInfo = [[self alloc] init]; });
  return sharedPlayerInfo;
  
}

@end
