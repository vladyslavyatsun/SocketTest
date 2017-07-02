//
//  SSConnector.m
//  SimpleSoket
//
//  Created by Vladislav Yatsun on 7/2/17.
//  Copyright © 2017 Vladislav Yatsun. All rights reserved.
//

#import "SSConnector.h"

CFReadStreamRef readStream;
CFWriteStreamRef writeStream;

NSInputStream *inputStream;
NSOutputStream *outputStream;

@interface SSConnector ()<NSStreamDelegate>

@end

@implementation SSConnector

- (void)setup {
	NSURL *url = [NSURL URLWithString:host];
	CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (CFStringRef)[url host], port, &readStream, &writeStream);

	if(!CFWriteStreamOpen(writeStream))
	{
		NSLog(@"Error, writeStream not open");
	}

	if(!CFReadStreamOpen(readStream))
	{
		NSLog(@"Error, readStream not open");
	}
}

- (void)open {

	inputStream = (NSInputStream *)readStream;
	outputStream = (NSOutputStream *)writeStream;

	[inputStream retain];
	[outputStream retain];

	[inputStream setDelegate:self];
	[outputStream setDelegate:self];

	[inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

	[inputStream open];
	[outputStream open];
}

- (void)close
{

	[inputStream close];
	[outputStream close];

	[inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

	[inputStream setDelegate:nil];
	[outputStream setDelegate:nil];

	[inputStream release];
	[outputStream release];

	inputStream = nil;
	outputStream = nil;
}

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)event
{
	switch(event)
	{

		case NSStreamEventHasBytesAvailable:
		{
			if(stream == inputStream) {
				uint8_t buf[1024];
				long len = 0;

				len = [inputStream read:buf maxLength:1024];

				if(len > 0) {
					NSMutableData* data = [[NSMutableData alloc] initWithLength:0];
					[data appendBytes: (const void *)buf length:len];
					NSString *s = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];

					[self.delegate connector:self didReadMessage:s];

					[data release];
				}
			}
			break;
		}
		default: {
			NSLog(@"Stream is sending an Event: %lu", (unsigned long)event);
			break;
		}
	}
}

- (void)writeOut:(NSString *)message
{
	uint8_t *buf = (uint8_t *)[message UTF8String];
	[outputStream write:buf maxLength:strlen((char *)buf)];
}

@end
