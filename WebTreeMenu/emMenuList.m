//
//  emMenuList.m
//  WebTreeMenu
//
//  Created by chanick park on 5/28/15.
//  Copyright (c) 2015 WebTreeMenu. All rights reserved.
//

#import "emMenuList.h"

@implementation emMenu

@end


//
// emMenuList
//
@implementation emMenuList

@synthesize menuData;


-(id) initWithMenuPath:(NSURL *)path {
    
    self = [super init];
    
    if(self){
        self.menuData = [self parseMenuFrom:path];
    }
    return self;
}

// parseMenu from url
- (NSArray *) parseMenuFrom:(NSURL *)file {
    
    NSData *data = [NSData dataWithContentsOfURL:file];
    
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
    NSString *slideXpathQueryString = @"//div[@id='mainNavi']/ul/li";
    NSArray *elements = [doc searchWithXPathQuery:slideXpathQueryString];
    
    NSMutableArray *menu = [NSMutableArray new];
    
    for(TFHppleElement *element in elements){
        
        emMenu *entry = [self parseNode:element];
        if(entry != nil) {
            [menu addObject:entry];
        }
    }
    return menu;
}

// Parse Html tag
// <a href = "...">, <ul>, <li>
//
- (emMenu *) parseNode:(TFHppleElement *)node {
    
    // find link on the web page
    // <a href = "...">
    
    NSArray *links = [node childrenWithTagName:@"a"];
    if([links count] == 0)
        return nil;
    
    TFHppleElement *element = [links objectAtIndex:0];
    
    NSString *href = [element.attributes objectForKey:@"href"];
    if([href containsString:@"blank.htm"])
        href = @"";
    
    // find sub menus
    NSMutableArray *children = [NSMutableArray new];
    NSArray *lists = [node childrenWithTagName:@"ul"];
    
    for(TFHppleElement *list in lists) {
        
        NSArray *listItems = [list childrenWithTagName:@"li"];
        
        for(TFHppleElement *listItem in listItems){
            emMenu *child = [self parseNode:listItem];
            [children addObject:child];
        };
    }
    
    // create menu
    emMenu *entry = [emMenu new];
    entry.name = element.text;
    entry.filename = href;
    entry.children = children;
    entry.bOpened = NO;
    
    return entry;
}

@end
