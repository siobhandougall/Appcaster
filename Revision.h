//
//  Revision.h
//  Appcaster
//
//  Created by Sean Dougall on 12/17/10.
//  Copyright 2010 Figure 53. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Revision : NSObject <NSCoding>
{
    NSDate          *_date;
    NSString        *_shortVersionNumber;
    NSString        *_buildNumber;
    NSString        *_changeLogHTML;
    NSString        *_signature;
    NSUInteger       _zipFileSize;
}

@property (retain) NSDate *date;
@property (retain) NSString *shortVersionNumber;
@property (retain) NSString *buildNumber;
@property (retain) NSString *changeLogHTML;
@property (retain) NSString *signature;
@property (assign) NSUInteger zipFileSize;

@end
