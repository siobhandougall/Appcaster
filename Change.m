//
//  Change.m
//  Appcaster
//
//  Created by Sean Dougall on 12/17/10.
//  Copyright 2010 Figure 53. All rights reserved.
//

#import "Change.h"
#import "DataModel.h"

@implementation Change

@synthesize changeType = _changeType;
@synthesize notes = _notes;

- (id) init
{
    if (self = [super init])
    {
        self.changeType = kChangeTypeUnspecified;
        self.notes = nil;
    }
    return self;
}

- (id) initWithCoder: (NSCoder *) decoder
{
    if (self = [self init])
    {
        self.changeType = [decoder decodeIntegerForKey:@"changeType"];
        self.notes = [decoder decodeObjectForKey:@"notes"];
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder *) coder
{
    [coder encodeInteger:self.changeType forKey:@"changeType"];
    [coder encodeObject:self.notes forKey:@"notes"];
}

@end
