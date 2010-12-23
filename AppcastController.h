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

- (IBAction) packageUpdate: (id) sender;
- (IBAction) finalizeUpdate: (id) sender;
- (void) packageUpdate: (id) sender finalize: (BOOL) shouldFinalize;
- (IBAction) importAppcastXML: (id) sender;

@end
