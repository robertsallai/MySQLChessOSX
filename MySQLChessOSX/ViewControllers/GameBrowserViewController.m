//
//  GameBrowserViewController.m
//  MySQLChessOSX
//
//  Created by Robert Sallai on 10/10/13.
//  Copyright (c) 2013 Robert Sallai. All rights reserved.
//

#import "AppDelegate.h"
#import "GameBrowserViewController.h"
#import "SocketConnection.h"
#import "Match.h"

@interface GameBrowserViewController ()

@property (strong, nonatomic) SocketConnection *connection;
@property (strong, nonatomic) NSMutableArray *matches; // of Match

@property (weak) IBOutlet NSTextField *matchTextField;
@property (weak) IBOutlet NSTableView *matchesTableView;

@end

#define left 0
#define right 1

@implementation GameBrowserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
      self.connection = [SocketConnection getSingletonInstance];
      [self.connection.inputStream setDelegate:self];
      [self.connection.outputStream setDelegate:self];
      self.matches = [[NSMutableArray alloc] init];
      [self.connection listMatches];
    }
  
    return self;
}

- (void) awakeFromNib{

}

#pragma mark Stream eventhandler

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent
{
	switch (streamEvent) {
      
    case NSStreamEventNone:
      break;
      
		case NSStreamEventOpenCompleted:
			break;
      
    case NSStreamEventHasSpaceAvailable:
      break;
      
		case NSStreamEventHasBytesAvailable:
      
			if (theStream == self.connection.inputStream)
      {
				uint8_t buffer[1024];
				NSUInteger len;
        NSString *response;
				
				while ([self.connection.inputStream hasBytesAvailable])
        {
					len = [self.connection.inputStream read:buffer maxLength:sizeof(buffer)];
					if (len > 0)
          {
						response = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
					}
				}
        [self.matches removeAllObjects];
        if (response)
        {
          //Separate the response string into "records"
          NSMutableArray *allMatches = [[NSMutableArray alloc] initWithArray:[response componentsSeparatedByString:@";"]];
          
          for (NSString *match in allMatches) {
            //Sperate each record into columns
            NSMutableArray *aMatch = [[NSMutableArray alloc] initWithArray:[match componentsSeparatedByString:@":"]];
//TODO: factor it out into a Conveneince Initializer
            Match *aMatchObject = [[Match alloc] init];
            aMatchObject.matchID = [aMatch[0] integerValue];
            aMatchObject.whitePlayer = aMatch[1];
            aMatchObject.wins = [aMatch[2] integerValue];
            aMatchObject.losses = [aMatch[3] integerValue];
            aMatchObject.ties = [aMatch[4] integerValue];
            
            [self.matches addObject:aMatchObject];
          }
          [self.matchesTableView reloadData];
        }
        
			}
			break;
			
		case NSStreamEventErrorOccurred:
      
			break;
			
		case NSStreamEventEndEncountered:
      
      [self.connection closeStreams];
			break;
	}
}

#pragma mark NSTableView data source methods

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  
  NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
  
  if( [tableColumn.identifier isEqualToString:@"PlayerName"] )
  {
    Match *match = [self.matches objectAtIndex:row];
    cellView.textField.stringValue = match.whitePlayer;
  }
  
  else if ([tableColumn.identifier isEqualToString:@"PlayerWins"]){
    Match *match = [self.matches objectAtIndex:row];
    cellView.textField.stringValue = [NSString stringWithFormat:@"%lu", match.wins];
  }
  
  else if ([tableColumn.identifier isEqualToString:@"PlayerLosses"]){
    Match *match = [self.matches objectAtIndex:row];
    cellView.textField.stringValue = [NSString stringWithFormat:@"%lu", match.losses];
  }
  
  else if ([tableColumn.identifier isEqualToString:@"PlayerTies"]){
    Match *match = [self.matches objectAtIndex:row];
    cellView.textField.stringValue = [NSString stringWithFormat:@"%lu", match.ties];
  }
  
  return cellView;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
  return [self.matches count];
  
}

#pragma mark IBActions

- (IBAction)logout:(id)sender
{
  [self.connection unlistFromLiveUpdate];
  AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
  
  [appDelegate changeViewControllerTo:@"LoginViewController"
                            Direction:left];
}

- (IBAction)create:(id)sender
{
  [self.connection createMatch:self.matchTextField.stringValue];
}

- (IBAction)delete:(id)sender
{
  [self.connection deleteMatch:self.matchTextField.stringValue];
}

- (IBAction)segue:(NSButton *)sender {
  
  [self.connection unlistFromLiveUpdate];
  AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
  
  [appDelegate changeViewControllerTo:@"ChessBoardViewController"
                            Direction:right];
  
}

@end
