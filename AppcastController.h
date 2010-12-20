//
//  AppcastController.h
//  Appcaster
//
//  Created by Sean Dougall on 12/17/10.
//  Copyright 2010 Figure 53. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Document;

@interface AppcastController : NSObject 
{
    Document            *_document;
    NSArrayController   *_revisionArrayController;
    NSArrayController   *_changeArrayController;
}

@property (assign) IBOutlet Document *document;
@property (assign) IBOutlet NSArrayController *revisionArrayController;
@property (assign) IBOutlet NSArrayController *changeArrayController;

- (IBAction) finalizeUpdate: (id) sender;
- (IBAction) importAppcastXML: (id) sender;

@end
