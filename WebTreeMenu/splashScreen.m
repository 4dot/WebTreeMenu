//
//  splashScreen.m
//  WebTreeMenu
//
//  Created by chanick park on 5/3/15.
//  Copyright (c) 2015 WebTreeMenu. All rights reserved.
//

#import "splashScreen.h"

@interface splashScreen ()

@property (weak, nonatomic) IBOutlet UIImageView *splashImgView;
@property (weak, nonatomic) IBOutlet UIImageView *splashOpacityImgView;

@end

@implementation splashScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // hide navi bar
    self.navigationController.navigationBarHidden = YES;
    _splashImgView.hidden = YES;
    
    [self performSelector:@selector(showLogoImage) withObject:nil afterDelay:0.7f];
}

- (void)showLogoImage
{
    // image opacity animation
    _splashOpacityImgView.frame = _splashImgView.frame;
    _splashImgView.hidden = NO;
    
    CGRect rcHide = _splashOpacityImgView.frame;
    rcHide.origin.x = self.view.frame.size.width;
    
    
    // opacity animation
    __weak splashScreen *weakSelf = self;
    
    [UIView animateWithDuration:1.7f
                     animations:^(void){
                         weakSelf.splashOpacityImgView.frame = rcHide;
                     }
                     completion:^(BOOL finished){
                         [weakSelf performSelector:@selector(performSegueWithIdentifier:sender:) withObject:@"gotoMainView" afterDelay:0.8f];
                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
