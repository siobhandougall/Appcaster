//
//  Revision.m
//  Appcaster
//
//  Created by Sean Dougall on 12/17/10.
//  Copyright 2010 Figure 53. All rights reserved.
//

#import "Revision.h"
#import "DataModel.h"

@implementation Revision

- (id) init
{
    if (self = [super init])
    {
        self.date = [NSDate date];
        self.shortVersionNumber = nil;
        self.buildNumber = nil;
        self.changeLogHTML = nil;
        self.signature = nil;
        self.zipFileSize = 0;
    }
    return self;
}

- (id) initWithCoder: (NSCoder *) decoder
{
    if (self = [self init])
    {
        self.date = [decoder decodeObjectForKey:@"date"];
        self.shortVersionNumber = [decoder decodeObjectForKey:@"shortVersionNumber"];
        self.buildNumber = [decoder decodeObjectForKey:@"buildNumber"];
        self.changeLogHTML = [decoder decodeObjectForKey:@"changeLogHTML"];
        self.signature = [decoder decodeObjectForKey:@"signature"];
        self.zipFileSize = [decoder decodeIntegerForKey:@"zipFileSize"];
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder *) coder
{
    [coder encodeObject:self.date forKey:@"date"];
    [coder encodeObject:self.shortVersionNumber forKey:@"shortVersionNumber"];
    [coder encodeObject:self.buildNumber forKey:@"buildNumber"];
    [coder encodeObject:self.changeLogHTML forKey:@"changeLogHTML"];
    [coder encodeObject:self.signature forKey:@"signature"];
    [coder encodeInteger:self.zipFileSize forKey:@"zipFileSize"];
}

@synthesize date = _date;
@synthesize shortVersionNumber = _shortVersionNumber;
@synthesize buildNumber = _buildNumber;
@synthesize changeLogHTML = _changeLogHTML;
@synthesize signature = _signature;
@synthesize zipFileSize = _zipFileSize;

@end