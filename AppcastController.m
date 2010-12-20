//
//  AppcastController.m
//  Appcaster
//
//  Created by Sean Dougall on 12/17/10.
//  Copyright 2010 Figure 53. All rights reserved.
//

#import "AppcastController.h"
#import "Document.h"
#import "DataModel.h"
#import "NSData+NSString.h"
#import "AppcastXMLImporter.h"

@implementation AppcastController

@synthesize document = _document;
@synthesize revisionArrayController = _revisionArrayController;
@synthesize changeArrayController = _changeArrayController;

- (IBAction) finalizeUpdate: (id) sender
{
    // Gather some strings for later reference
    NSBundle *appBundle = [NSBundle bundleWithPath:[self.document.product.pathToBuiltProduct path]];
    NSDictionary *plist = [appBundle infoDictionary];
    NSDictionary *localizedPlist = [appBundle localizedInfoDictionary];
    NSString *productName = [plist objectForKey:@"CFBundleExecutable"];
    NSString *buildNumber = [NSString stringWithFormat:@"%@", [plist objectForKey:@"CFBundleVersion"]];
    NSString *shortVersionNumber = [localizedPlist objectForKey:@"CFBundleShortVersionString"];
    NSString *baseDirectoryPath = [[self.document.product.pathToBuiltProduct path] stringByDeletingLastPathComponent];
    NSString *releaseDirectoryPath = [NSString stringWithFormat:@"%@/%@/%@-%@", baseDirectoryPath, productName, shortVersionNumber, buildNumber];
    NSString *zipFilePath = [NSString stringWithFormat:@"%@/%@-%@-%@.zip", releaseDirectoryPath, productName, shortVersionNumber, buildNumber];
    
    // Run script to zip and sign update
    NSTask *task = [[[NSTask alloc] init] autorelease];
	[task setLaunchPath:@"/bin/sh"];
	[task setArguments:[NSArray arrayWithObjects:
                        [[NSBundle mainBundle] pathForResource:@"process" ofType:@"sh"],
                        [self.document.product.pathToBuiltProduct path],
                        [self.document.product.pathToPrivateKeyFile path],
                        nil]];
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    [task setStandardInput:[NSPipe pipe]];
    NSFileHandle *resultHandle = [pipe fileHandleForReading];
	[task launch];
	[task waitUntilExit];
    NSString *signature = [[resultHandle readDataToEndOfFile] UTF8String];
    
    // Get file size
    FILE *file = fopen([zipFilePath UTF8String], "r");
    fseek(file, 0, SEEK_END);
    NSInteger zipSizeInBytes = ftell(file);
    fclose(file);
    
    // Generate release notes
    NSMutableString *releaseNotesHTML = [NSMutableString stringWithFormat:@"<html>\n  <head>\n    <meta http-equiv=\"content-type\" content=\"text/html;charset=utf-8\">\n    <title>What\'s new in %@?</title>\n    <meta name=\"robots\" content=\"anchors\">\n    <link href=\"style-releases.css\" type=\"text/css\" rel=\"stylesheet\" media=\"all\">\n  </head>\n  <body>", productName];
    for (Change *change in self.document.product.changesSinceLastRevision)
    {
        switch (change.changeType)
        {
            case kChangeTypeAdded:
                [releaseNotesHTML appendFormat:@"\n    <p>\n      <b class=\"added\">ADDED:</b> %@\n    </p>", change.notes];
                break;
            case kChangeTypeFixed:
                [releaseNotesHTML appendFormat:@"\n    <p>\n      <b class=\"fixed\">FIXED:</b> %@\n    </p>", change.notes];
                break;
            case kChangeTypeChanged:
                [releaseNotesHTML appendFormat:@"\n    <p>\n      <b class=\"changed\">CHANGED:</b> %@\n    </p>", change.notes];
                break;
            default:
                [releaseNotesHTML appendFormat:@"\n    <p>\n      <b>NOTE:</b> %@\n    </p>", change.notes];
                break;
        }
    }
    [releaseNotesHTML appendString:@"\n  </body>\n</html>"];

    NSError *err = nil;
    
    [[NSFileManager defaultManager] createDirectoryAtPath:releaseDirectoryPath withIntermediateDirectories:YES attributes:nil error:err];
    if (err)
    {
        NSRunAlertPanel(@"Error finalizing.", @"Unable to create directory for release products.", @"OK", nil, nil);
        return;
    }

    [releaseNotesHTML writeToURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@.html", releaseDirectoryPath, buildNumber]] atomically:YES encoding:NSUTF8StringEncoding error:&err];
    if (err)
    {
        NSRunAlertPanel(@"Error finalizing.", @"Unable to write release notes: %@.", @"OK", nil, nil, [err localizedFailureReason]);
        return;
    }
    
    // Create new revision to archive into product's "revisions" array
    Revision *rev = [[Revision new] autorelease];
    rev.buildNumber = buildNumber;
    rev.shortVersionNumber = shortVersionNumber;
    rev.signature = [signature stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    rev.zipFileSize = zipSizeInBytes;
    [self.document.product.revisions addObject:rev];
    [self.document.product.changesSinceLastRevision removeAllObjects];
    [self.revisionArrayController willChangeValueForKey:@"arrangedObjects"];
    [self.revisionArrayController didChangeValueForKey:@"arrangedObjects"];
    [self.changeArrayController willChangeValueForKey:@"arrangedObjects"];
    [self.changeArrayController didChangeValueForKey:@"arrangedObjects"];
    
    // Generate appcast.xml
    NSMutableString *appcastXML = [NSMutableString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                                   \n<rss version=\"2.0\" xmlns:sparkle=\"http://www.andymatuschak.org/xml-namespaces/sparkle\"  xmlns:dc=\"http://purl.org/dc/elements/1.1/\">\
                                   \n\t<channel>\
                                   \n\t\t<title>%@ Changelog</title>\
                                   \n\t\t<link>http://figure53.com/%@/downloads/appcast.xml</link>\
                                   \n\t\t<description>Most recent changes with links to updates.</description>\
                                   \n\t\t<language>en</language>\
                                   ",
                                   productName,
                                   [productName lowercaseString]];
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"EEE, dd MMM YYYY HH:mm:ss ZZ"];
    for (Revision *revision in self.document.product.sortedRevisions)
    {
        [appcastXML appendFormat:@"\n\n\t\t<item>\
         \n\t\t\t<title>Version %@ (%@)</title>\
         \n\t\t\t<sparkle:releaseNotesLink>http://figure53.com/%@/downloads/release-notes/%@.html</sparkle:releaseNotesLink>\
         \n\t\t\t<pubDate>%@</pubDate>\
         \n\t\t\t<enclosure url=\"http://figure53.com/%@/downloads/%@-%@-%@\" sparkle:version=\"%@\" sparkle:shortVersionString=\"%@ (%@)\" type=\"application/octet-stream\" length=\"%u\" sparkle:dsaSignature=\"%@\"/>\
         \n\t\t</item>",
         revision.shortVersionNumber,
         revision.buildNumber,
         [productName lowercaseString],
         revision.buildNumber,
         [formatter stringFromDate:revision.date],
         [productName lowercaseString],
         productName,
         revision.shortVersionNumber,
         revision.buildNumber,
         revision.buildNumber,
         revision.shortVersionNumber,
         revision.buildNumber,
         revision.zipFileSize,
         revision.signature
        ];
    }
    
    [appcastXML appendString:@"\n\n</channel>\n</rss>"];
    [appcastXML writeToURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/appcast.xml", releaseDirectoryPath]] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
	// Reveal in Finder
	NSMutableArray *comps = [NSMutableArray arrayWithArray:[releaseDirectoryPath pathComponents]];
	[comps removeObjectAtIndex:0];
	NSString *revealSource = [NSString stringWithFormat:@"tell application \"Finder\" to reveal folder \"%@\" of startup disk",
							  [comps componentsJoinedByString:@":"]];
	NSAppleScript *script = [[[NSAppleScript alloc] initWithSource:revealSource] autorelease];
	NSDictionary *errDict = nil;
	[script executeAndReturnError:&errDict];
}

- (IBAction) importAppcastXML: (id) sender
{
    NSOpenPanel *op = [NSOpenPanel openPanel];
    [op setAllowedFileTypes:[NSArray arrayWithObject:@"xml"]];
    [op setAllowsMultipleSelection:NO];
    if ([op runModal] == NSFileHandlingPanelOKButton)
    {
        AppcastXMLImporter *importer = [AppcastXMLImporter sharedInstance];
        importer.document = self.document;
        [importer importAppcastXML:[op filename]];
    }
}

@end
