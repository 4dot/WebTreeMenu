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
    self.splashImgView.hidden = YES;
    
    [self performSelector:@selector(showLogoImage) withObject:nil afterDelay:0.7f];
}

- (void)showLogoImage
{
    // image opacity animation
    self.splashOpacityImgView.frame = self.splashImgView.frame;
    CGRect rcHide = self.splashOpacityImgView.frame;
    rcHide.origin.x = self.view.frame.size.width;
    self.splashImgView.hidden = NO;
    
    [UIView animateWithDuration:1.7f
                     animations:^(void){
                         self.splashOpacityImgView.frame = rcHide;
                     }
                     completion:^(BOOL finished){
                         [self performSelector:@selector(performSegueWithIdentifier:sender:) withObject:@"gotoMainView" afterDelay:0.8f];
                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
