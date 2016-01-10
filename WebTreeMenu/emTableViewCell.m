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

@implementation emTableViewCell

- (void)awakeFromNib {
    // Initialization code
    CALayer *separator = [CALayer layer];
    separator.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.25].CGColor;
    separator.frame = CGRectMake(31, 43, 200, .5);
    [self.layer addSublayer:separator];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)extendImg:(BOOL)bExtend
{
    // change cell header image
    if(bExtend == self.bWasExtend)
        return;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         // rotate cw90
                         CGFloat fRot = bExtend ? M_PI_2 : 0;
                         self.btnExtend.transform = CGAffineTransformMakeRotation(fRot);
                         
                         self.bWasExtend = bExtend;
                         [self.delegate showChidMenu:bExtend menu:self.menu];
                     }
                     completion:^(BOOL finished){
                         // lock during animation
                     }
     ];
}

- (void)setCellData:(emMenu *)menu
{
    [self resetCellData];
    
    // set
    if(menu)
    {
        self.lblName.text = menu.name;
        self.bWasExtend = menu.bOpened;
        self.btnExtend.hidden = (menu.children.count > 0) ? NO : YES;
        self.menu = menu;
        
        CGFloat fRot = menu.bOpened ? M_PI_2 : 0;
        self.btnExtend.transform = CGAffineTransformMakeRotation(fRot);
    }
}

- (void)resetCellData
{
    // init
    self.lblName.text = @"";
    self.btnExtend.hidden = YES;
    self.bWasExtend = NO;
    self.menu = nil;
    self.btnExtend.transform = CGAffineTransformMakeRotation(0);
}

#pragma mark - button actions

- (IBAction)onTouchUpBtnExtend:(id)sender
{
    [self extendImg:!self.bWasExtend];
}


@end
