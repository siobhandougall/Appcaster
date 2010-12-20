//
//  NSString+NSData.m
//  Chroma
//
//  Created by Sean Dougall on 5/28/10.
//  Copyright 2010 Figure 53. All rights reserved.
//

#import "NSData+NSString.h"


@implementation NSData (NSStringConversion)

- (NSString *) UTF8String
{
	char *nullTerm = malloc(sizeof(char));
	nullTerm[0] = 0x0;
	
	NSMutableData *newData = [self mutableCopy];
	if (((char *)[newData bytes])[[newData length] - 1] != 0x0)
		[newData appendBytes:nullTerm length:1];
	
	free(nullTerm);
	
	NSString *result = [NSString stringWithCString:[newData bytes] encoding:NSUTF8StringEncoding];
	[newData release];
	
	return result;
}

@end
