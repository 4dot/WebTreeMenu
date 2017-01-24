//
//  emTableViewCell.m
//  WebTreeMenu
//
//  Created by chanick park on 5/24/15.
//  Copyright (c) 2015 WebTreeMenu. All rights reserved.
//

#import "emTableViewCell.h"
#import "emMenuList.h"

@interface emTableViewCell()

@end

//
// emTableViewCell
//
@implementation emTableViewCell

- (void)awakeFromNib {
    
    // Create Separator
    CALayer *separator = [CALayer layer];
    separator.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.25].CGColor;
    separator.frame = CGRectMake(31, 43, 200, .5);
    [self.layer addSublayer:separator];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)extendImg:(BOOL)bExtend
{
    // change cell header image
    if(bExtend == self.bWasExtend)
        return;
    
    // open sub menus
    __weak emTableViewCell *weakSelf = self;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         // rotate image CW90
                         CGFloat fRot = bExtend ? M_PI_2 : 0;
                         weakSelf.btnExtend.transform = CGAffineTransformMakeRotation(fRot);
                         
                         weakSelf.bWasExtend = bExtend;
                         [weakSelf.delegate showChidMenu:bExtend menu:weakSelf.menu];
                     }
     ];
}

- (void)setCellData:(emMenu *)menu
{
    [self resetCellData];
    
    if(menu == nil) {
        return;
    }
    
    // set data
    _lblName.text = menu.name;
    _bWasExtend = menu.bOpened;
    _btnExtend.hidden = (menu.children.count > 0) ? NO : YES;
    _menu = menu;
    
    CGFloat fRot = menu.bOpened ? M_PI_2 : 0;
    _btnExtend.transform = CGAffineTransformMakeRotation(fRot);
}

- (void)resetCellData
{
    // reset
    _lblName.text = @"";
    _btnExtend.hidden = YES;
    _bWasExtend = NO;
    _menu = nil;
    _btnExtend.transform = CGAffineTransformMakeRotation(0);
}

#pragma mark - button actions

- (IBAction)onTouchUpBtnExtend:(id)sender
{
    [self extendImg:!_bWasExtend];
}


@end
