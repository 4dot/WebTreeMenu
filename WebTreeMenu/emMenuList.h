//
//  emMenuList.h
//  WebTreeMenu
//
//  Created by chanick park on 5/28/15.
//  Copyright (c) 2015 WebTreeMenu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFHpple.h"

@interface emMenu : NSObject

@property (strong) NSString *name;
@property (strong) NSArray  *children;
@property (strong) NSString *filename;
@property (assign) BOOL     bOpened;

@end



@interface emMenuList : NSObject

@property (strong) NSArray *menuData;

-(id)initWithMenuPath:(NSURL *)path;

- (NSArray *)parseMenuFrom:(NSURL *)file;
- (emMenu *)parseNode:(TFHppleElement *)node;

@end
