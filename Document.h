//
//  Document.h
//  Appcaster
//
//  Created by Sean Dougall on 12/17/10.
//  Copyright 2010 Figure 53. All rights reserved.
//


#import <Cocoa/Cocoa.h>

@class Product;
@class RevisionArrayController;
@class AppcastController;

@interface Document : NSDocument
{
    Product                     *_product;
    RevisionArrayController     *_revisionArrayController;
    AppcastController           *_appcastController;
}

@property (retain) Product *product;
@property (assign) IBOutlet RevisionArrayController *revisionArrayController;
@property (assign) IBOutlet AppcastController *appcastController;

- (IBAction) importAppcastXML: (id) sender;

@end
