//
//  LoginViewController.m
//  MySQLChessOSX
//
//  Created by Robert Sallai on 10/10/13.
//  Copyright (c) 2013 Robert Sallai. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import  "PlayerInfo.h"

@interface LoginViewController ()

@property (strong, nonatomic) SocketConnection *connection;
@property (strong, nonatomic) PlayerInfo *playerinfo;

@property (weak) IBOutlet NSTextField *usernameTextField;
@property (weak) IBOutlet NSSecureTextField *passwordTextField;
@property (weak) IBOutlet NSTextFieldCell *feedbackLabel;


@end

@implementation LoginViewController

#define left 0
#define right 1
#define top 2
#define bottom 3

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      self.connection = [SocketConnection getSingletonInstance];
      [self.connection.inputStream setDelegate:self];
      [self.connection.outputStream setDelegate:self];
      self.playerinfo = [PlayerInfo getSingletonInstance];
    }
    return self;
}

- (void)awakeFromNib{

}


# pragma mark NSStream eventhandler

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent
{
	switch (streamEvent) {
			
    case NSStreamEventNone:
      [self.feedbackLabel setStringValue:[NSString stringWithFormat:@"Input:%lu, Output:%lu", [self.connection.inputStream streamStatus], [self.connection.inputStream streamStatus]]];
      break;
      
		case NSStreamEventOpenCompleted:
      [self.feedbackLabel setStringValue:[NSString stringWithFormat:@"Input:%lu, Output:%lu", [self.connection.inputStream streamStatus], [self.connection.inputStream streamStatus]]];
      break;
      
    case NSStreamEventHasSpaceAvailable:
      [self.feedbackLabel setStringValue:[NSString stringWithFormat:@"Input:%lu, Output:%lu", [self.connection.inputStream streamStatus], [self.connection.inputStream streamStatus]]];
      break;
      
		case NSStreamEventHasBytesAvailable:
      
[self.feedbackLabel setStringValue:[NSString stringWithFormat:@"Input:%lu, Output:%lu", [self.connection.inputStream streamStatus], [self.connection.inputStream streamStatus]]];
			if (theStream == self.connection.inputStream)
      {
				uint8_t buffer[1024];
				NSUInteger len;
        NSString * response;
				
				while ([self.connection.inputStream hasBytesAvailable])
        {
					len = [self.connection.inputStream read:buffer maxLength:sizeof(buffer)];
					if (len > 0)
          {
            response = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
          }
				}
        
        if (nil != response)
        {
          BOOL login = [response integerValue];
          if (login)
          {
            [self.feedbackLabel setStringValue:@"Sikeres bejelentkezes"];\
            self.playerinfo.playername = [self.usernameTextField stringValue];
            AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
            [appDelegate changeViewControllerTo:@"GameBrowserViewController"
                                      Direction:right];
            
          }
          else
          {
            [self.feedbackLabel setStringValue:@"Sikertelen bejelentkezes"];
          }
        }
			}
			break;
			
		case NSStreamEventErrorOccurred:
			[self.feedbackLabel setStringValue:[NSString stringWithFormat:@"Input:%lu, Output:%lu", [self.connection.inputStream streamStatus], [self.connection.inputStream streamStatus]]];
      [self.connection closeStreams];
			break;
			
		case NSStreamEventEndEncountered:
      [self.feedbackLabel setStringValue:[NSString stringWithFormat:@"Input:%lu, Output:%lu", [self.connection.inputStream streamStatus], [self.connection.inputStream streamStatus]]];
      [self.connection closeStreams];
			break;
	}
}

#pragma mark IBActions

- (IBAction)login:(NSButton *)sender {
  NSString *credentials = [NSString stringWithFormat:@"login:%@:%@",
                           [self.usernameTextField stringValue],
                           [self.passwordTextField stringValue]];
  
  [self.connection login:credentials];

}



@end
