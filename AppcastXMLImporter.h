//
//  AppcastXMLImporter.h
//  Appcaster
//
//  Created by Sean Dougall on 12/20/10.
//  Copyright 2010 Figure 53. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Document;
@class Revision;

@interface AppcastXMLImporter : NSObject <NSXMLParserDelegate>
{
    Document            *_document;
    NSXMLParser         *_parser;
    NSMutableString     *_thisElementString;
    Revision            *_thisRevision;
    BOOL                 _busy;
}

@property (assign) Document *document;
@property (readonly) BOOL busy;

+ (AppcastXMLImporter *) sharedInstance;
- (void) importAppcastXML: (NSString *) filePath;

@end
