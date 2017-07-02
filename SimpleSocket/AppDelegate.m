//
//  AppDelegate.m
//  SimpleSocket
//
//  Created by Vladislav Yatsun on 7/2/17.
//  Copyright © 2017 Vladislav Yatsun. All rights reserved.
//

#import "AppDelegate.h"
#import "SSConnector.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	SSConnector *connector = [[SSConnector alloc] init];
	connector->host = @"http://127.0.0.1";
	connector->port = 8888;

	[connector setup];
	[connector open];
	[connector writeOut:@"hello world"];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}


@end
