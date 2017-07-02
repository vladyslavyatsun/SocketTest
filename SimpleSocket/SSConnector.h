//
//  SSConnector.h
//  SimpleSoket
//
//  Created by Vladislav Yatsun on 7/2/17.
//  Copyright © 2017 Vladislav Yatsun. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SSConnectorDelegate;

@interface SSConnector : NSObject
{
	@public

	NSString *host;
	int port;
}

@property (nonatomic, assign, readwrite) id<SSConnectorDelegate> delegate;

- (void)setup;
- (void)open;
- (void)close;
- (void)writeOut:(NSString *)message;

@end

@protocol SSConnectorDelegate <NSObject>

- (void)connector:(SSConnector *)connector didReadMessage:(NSString *)message;

@end
