//
//  ChessBoardView.m
//  MySQLChessOSX
//
//  Created by Robert Sallai on 10/12/13.
//  Copyright (c) 2013 Robert Sallai. All rights reserved.
//

#import "ChessBoardView.h"

@implementation ChessBoardView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
  const int GRIDSIZE = 8;
  int cellWidth = 50;
  int cellHeight = 50;

  for (int x=0; x < GRIDSIZE; x++)
  {
    for (int y=0; y < GRIDSIZE; y++)
    {
      
      float ix = x*cellWidth;
      float iy = y*cellHeight;
      
      NSColor *color = (x % 2 == y % 2) ? [NSColor whiteColor] : [NSColor blackColor];
      [color set];
      
      NSRect r = NSMakeRect(ix, iy, cellWidth, cellHeight);
      
      NSBezierPath *path = [NSBezierPath bezierPath];
      [path appendBezierPathWithRect:r];
      
      [path fill];
      [path stroke];
    }
  }
}

@end
