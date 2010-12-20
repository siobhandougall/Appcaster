//
//  AppcastXMLImporter.m
//  Appcaster
//
//  Created by Sean Dougall on 12/20/10.
//  Copyright 2010 Figure 53. All rights reserved.
//

#import "AppcastXMLImporter.h"
#import "DataModel.h"
#import "Document.h"

static AppcastXMLImporter *_sharedInstance = nil;

@implementation AppcastXMLImporter

@synthesize document = _document;

- (BOOL) busy
{
    return (_parser != nil);
}

+ (AppcastXMLImporter *) sharedInstance
{
    if (_sharedInstance == nil)
        _sharedInstance = [[AppcastXMLImporter alloc] init];
    
    return _sharedInstance;
}

- (void) importAppcastXML: (NSString *) filePath
{
    if (self.busy) 
    {
        NSLog(@"Error: Can't start a new import while an old one is in progress.");
        return;
    }
    _parser = [[NSXMLParser alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath] options:0 error:nil]];
    [_parser setDelegate:self];
    [_parser parse];
    [_parser release];
    _parser = nil;    
}

- (void) parser: (NSXMLParser *) parser
foundCharacters: (NSString *) string
{
    [_thisElementString appendString:string];
}

- (void) parser: (NSXMLParser *) parser 
didStartElement: (NSString *) elementName 
   namespaceURI: (NSString *) namespaceURI 
  qualifiedName: (NSString *) qualifiedName 
     attributes: (NSDictionary *) attributeDict
{
    if ([elementName isEqualToString:@"item"])
    {
        _thisRevision = [[Revision alloc] init];
    }
    else if ([elementName isEqualToString:@"enclosure"])
    {
        _thisRevision.signature = [attributeDict objectForKey:@"sparkle:dsaSignature"];
        _thisRevision.buildNumber = [attributeDict objectForKey:@"sparkle:version"];
        _thisRevision.zipFileSize = [[attributeDict objectForKey:@"length"] integerValue];
        NSScanner *versionScanner = [NSScanner scannerWithString:[attributeDict objectForKey:@"sparkle:shortVersionString"]];
        NSString *versionNumber = nil;
        [versionScanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:&versionNumber];
        _thisRevision.shortVersionNumber = versionNumber;
    }
    else
    {
        [_thisElementString release];
        _thisElementString = [NSMutableString new];
    }
}

- (void) parser: (NSXMLParser *) parser 
  didEndElement: (NSString *) elementName 
   namespaceURI: (NSString *) namespaceURI
  qualifiedName: (NSString *) qualifiedName
{
    if ([elementName isEqualToString:@"item"])
    {
        [self.document.revisionArrayController addObject:_thisRevision];
        [_thisRevision release];
        _thisRevision = nil;
    }
    else if ([elementName isEqualToString:@"pubDate"])
    {
        NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"dd MMM yyyy HH:mm:ss ZZ"];
        _thisRevision.date = [formatter dateFromString:[_thisElementString substringFromIndex:5]];
        NSLog(@"%@ => %@", [_thisElementString substringFromIndex:5], _thisRevision.date);
    }
}

@end
