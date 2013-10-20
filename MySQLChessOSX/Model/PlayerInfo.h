//
//  PlayerInfo.h
//  MySQLChessOSX
//
//  Created by Robert Sallai on 10/13/13.
//  Copyright (c) 2013 Robert Sallai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerInfo : NSObject

@property (strong, nonatomic) NSString *playername;
@property (nonatomic) NSUInteger matchID;


+ (PlayerInfo *) getSingletonInstance;

@end
