//
//  Document.m
//  Appcaster
//
//  Created by Sean Dougall on 12/17/10.
//  Copyright 2010 Figure 53. All rights reserved.
//

#import "Document.h"
#import "DataModel.h"
#import "AppcastController.h"

@implementation Document

@synthesize product = _product;
@synthesize revisionArrayController = _revisionArrayController;
@synthesize appcastController = _appcastController;

- (IBAction) importAppcastXML: (id) sender
{
    [self.appcastController importAppcastXML:sender];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.product = [[[Product alloc] init] autorelease];
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    return [NSKeyedArchiver archivedDataWithRootObject:self.product];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    self.product = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return YES;
}

@end
