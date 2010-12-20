//
//  RevisionArrayController.m
//  Appcaster
//
//  Created by Sean Dougall on 12/17/10.
//  Copyright 2010 Figure 53. All rights reserved.
//

#import "RevisionArrayController.h"


@implementation RevisionArrayController

- (IBAction) remove: (id) sender
{
    if (NSRunAlertPanel(@"Really delete revision?", @"This will permanently remove this revision from the list, including associated data such as the revision's signature. This cannot be undone.", @"Delete", @"Cancel", nil) == NSOKButton)
        [super remove:sender];
}

@end
