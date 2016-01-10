//
//  ViewController.h
//  WebTreeMenu
//
//  Created by Özcan Akbulut on 23.10.13.
//  Copyright (c) 2013 Özcan Akbulut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "emTableViewCell.h"

@interface ViewController : UIViewController <emTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UITableView *sideMenuTable;

@end
