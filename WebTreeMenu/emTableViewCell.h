//
//  emTableViewCell.h
//  WebTreeMenu
//
//  Created by chanick park on 5/24/15.
//  Copyright (c) 2015 WebTreeMenu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class emMenu;

@protocol emTableViewCellDelegate <NSObject>

- (void)showChidMenu:(BOOL)bOpen menu:(emMenu*)menu;

@end

@interface emTableViewCell : UITableViewCell

@property(nonatomic, assign) id<emTableViewCellDelegate> delegate;

@property(nonatomic, assign) BOOL bWasExtend;
@property(nonatomic, assign) BOOL bChild;
@property(nonatomic, retain) emMenu *menu;

@property(nonatomic, strong) IBOutlet UIButton  *btnExtend;
@property(nonatomic, strong) IBOutlet UILabel   *lblName;

- (void)setCellData:(emMenu*)menu;
- (void)resetCellData;

@end
