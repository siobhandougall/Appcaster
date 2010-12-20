//
//  Product.m
//  Appcaster
//
//  Created by Sean Dougall on 12/17/10.
//  Copyright 2010 Figure 53. All rights reserved.
//

#import "Product.h"
#import "DataModel.h"

@implementation Product

- (id) init
{
    if (self = [super init])
    {
        self.pathToBuiltProduct = nil;
        self.pathToPrivateKeyFile = nil;
        self.revisions = [NSMutableArray array];
        self.changesSinceLastRevision = [NSMutableArray array];
    }
    return self;
}

- (id) initWithCoder: (NSCoder *) decoder
{
    if (self = [self init])
    {
        self.pathToBuiltProduct = [decoder decodeObjectForKey:@"pathToBuiltProduct"];
        self.pathToPrivateKeyFile = [decoder decodeObjectForKey:@"pathToPrivateKeyFile"];
        self.revisions = [decoder decodeObjectForKey:@"revisions"];
        self.changesSinceLastRevision = [decoder decodeObjectForKey:@"changesSinceLastRevision"];
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder *) coder
{
    [coder encodeObject:self.pathToBuiltProduct forKey:@"pathToBuiltProduct"];
    [coder encodeObject:self.pathToPrivateKeyFile forKey:@"pathToPrivateKeyFile"];
    [coder encodeObject:self.revisions forKey:@"revisions"];
    [coder encodeObject:self.changesSinceLastRevision forKey:@"changesSinceLastRevision"];
}

@synthesize pathToBuiltProduct = _pathToBuiltProduct;
@synthesize pathToPrivateKeyFile = _pathToPrivateKeyFile;
@synthesize changesSinceLastRevision = _changesSinceLastRevision;
@synthesize revisions = _revisions;

- (NSArray *) sortedRevisions
{
    [self.revisions sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]];
    return [[self.revisions copy] autorelease];
}

@end
