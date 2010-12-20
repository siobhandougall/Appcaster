//
//  Product.h
//  Appcaster
//
//  Created by Sean Dougall on 12/17/10.
//  Copyright 2010 Figure 53. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Product : NSObject <NSCoding>
{
    NSURL           *_pathToBuiltProduct;
    NSURL           *_pathToPrivateKeyFile;
    NSMutableArray  *_revisions;
    NSMutableArray  *_changesSinceLastRevision;
}

@property (retain) NSURL *pathToBuiltProduct;
@property (retain) NSURL *pathToPrivateKeyFile;
@property (retain) NSMutableArray *revisions;
@property (readonly) NSArray *sortedRevisions;
@property (retain) NSMutableArray *changesSinceLastRevision;

@end
