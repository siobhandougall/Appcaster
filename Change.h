//
//  Change.h
//  Appcaster
//
//  Created by Sean Dougall on 12/17/10.
//  Copyright 2010 Figure 53. All rights reserved.
//

#import <Cocoa/Cocoa.h>

enum {
    kChangeTypeUnspecified = 0,
    kChangeTypeFixed = 'fix ',
    kChangeTypeAdded = 'add ',
    kChangeTypeChanged = 'chng'
};

@interface Change : NSObject <NSCoding>
{
    NSUInteger       _changeType;
    NSString        *_notes;
}

@property (assign) NSUInteger changeType;
@property (retain) NSString *notes;

@end
