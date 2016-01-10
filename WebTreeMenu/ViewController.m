//
//  ViewController.m
//  WebTreeMenu
//
//  Created by Özcan Akbulut on 23.10.13.
//  Copyright (c) 2013 Özcan Akbulut. All rights reserved.
//

#import "ViewController.h"
#import "TFHpple.h"
#import "emTableViewCell.h"
#import "emMenuList.h"

#warning This webpage is a test page. Please change to your webpage link.
static NSString *HOMEPAGE = @"http://www.EmpireNailSupply.com";

@interface ViewController ()

@property (strong,nonatomic) emMenuList *menuList;
@property (strong,nonatomic) NSString *strSelectedKey;
@property (strong,nonatomic) NSMutableArray *arrOpenedMenu;
@property (assign,nonatomic) BOOL bShowSideMenuView;

@end

@implementation ViewController
@synthesize menuList, mainView, sideMenuTable, webView, bShowSideMenuView, arrOpenedMenu;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    bShowSideMenuView = NO;
    arrOpenedMenu = [[NSMutableArray alloc] init];
    
    self.navigationController.navigationBarHidden = NO;
    
    // Create Gesture
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
    
    // Begin - Custom Navigation,..
    self.navigationController.navigationBar.translucent = YES;
    [(UIView*)[self.navigationController.navigationBar.subviews objectAtIndex:0] setAlpha:0.8f];
    // End - Custom Navigation,..
    
    // close side menu view
    [self hideMenu];
    
    // request web page
    NSURL* nsUrl = [NSURL URLWithString:HOMEPAGE];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    
    [webView loadRequest:request];
    
    // parsing side menu with html format
    [self loadSlideMenu];
}

- (void)loadSlideMenu
{
    menuList = [[emMenuList alloc] initWithMenuPath:[NSURL URLWithString:HOMEPAGE]];
    
    // first, load first level menu
    for(emMenu *headMenu in menuList.menuData){
        [arrOpenedMenu addObject:headMenu];
    }
    
    // show tableview
    [sideMenuTable reloadData];
}

- (void)setExtendMenus:(emMenu*)parentMenu idx:(NSInteger)index
{
    NSMutableArray *arrIndexPaths = [NSMutableArray array];
    
    // set open flag
    parentMenu.bOpened = YES;
    
    for(emMenu *child in parentMenu.children){
        [arrOpenedMenu insertObject:child atIndex:++index];
        [arrIndexPaths addObject:[NSIndexPath indexPathForRow:index inSection:1]];
    }
    [sideMenuTable insertRowsAtIndexPaths:arrIndexPaths withRowAnimation:UITableViewRowAnimationTop];
}

- (void)setContractMenus:(emMenu*)parentMenu idx:(NSInteger)index
{
    NSMutableArray *arrIndexPaths = [NSMutableArray array];
    
    // set open flag
    parentMenu.bOpened = NO;
    
    for(emMenu *child in parentMenu.children){
        [arrOpenedMenu removeObject:child];
        [arrIndexPaths addObject:[NSIndexPath indexPathForRow:++index inSection:1]];
    }
    [sideMenuTable deleteRowsAtIndexPaths:arrIndexPaths withRowAnimation:UITableViewRowAnimationTop];
}

#pragma mark - Actions -
- (IBAction)onTouchUpShowSideMenu:(id)sender {
    
    if(bShowSideMenuView) //only show the menu if it is not already shown
        [self hideMenu];
    else
        [self showMenu];
    
}

#pragma mark - animations -
-(void)showMenu
{
    if(bShowSideMenuView == YES)
        return;
    
    bShowSideMenuView = YES;
    
    //slide the content view to the right to reveal the menu
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rcMainView = mainView.frame;
        rcMainView.origin.x = sideMenuTable.frame.size.width;
        [mainView setFrame:rcMainView];
        
        CGRect rcNavi = self.navigationController.navigationBar.frame;
        rcNavi.origin.x = sideMenuTable.frame.size.width;
        [self.navigationController.navigationBar setFrame:rcNavi];
    }];
}

-(void)hideMenu
{
    if(bShowSideMenuView == NO)
        return;
    
    bShowSideMenuView = NO;
    
    //slide the content view to the left to hide the menu
    [UIView animateWithDuration:0.3f
                     animations:^{
                         CGRect rcMainView = mainView.frame;
                         rcMainView.origin.x = 0;
                         [mainView setFrame:rcMainView];
                         
                         CGRect rcNavi = self.navigationController.navigationBar.frame;
                         rcNavi.origin.x = 0;
                         [self.navigationController.navigationBar setFrame:rcNavi];
                     }
                     completion:^(BOOL bFinished){
                         // contract all
                         for(emMenu *menu in arrOpenedMenu){
                             menu.bOpened = NO;
                         }
                         // reset menu array with header menus
                         [arrOpenedMenu removeAllObjects];
                         for (emMenu *menuHeader in menuList.menuData){
                             [arrOpenedMenu addObject:menuHeader];
                         }
                         
                         [sideMenuTable reloadData];
                     }
     ];
}

#pragma mark - Gesture handlers -

-(void)handleSwipeLeft:(UISwipeGestureRecognizer*)recognizer{
    
    if(mainView.frame.origin.x != 0)
        [self hideMenu];
}

-(void)handleSwipeRight:(UISwipeGestureRecognizer*)recognizer{
    if(mainView.frame.origin.x == 0)
        [self showMenu];
}

#pragma mark - UITableView Datasource -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)
        return 1;
    else{
        return arrOpenedMenu.count;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([indexPath section] == 0) {
        UITableViewCell *avatarCell = [tableView dequeueReusableCellWithIdentifier:@"avatarMenuCell"];
        UIImageView *imageAvatar = (UIImageView *) [avatarCell viewWithTag:301];
        imageAvatar.image = [UIImage imageNamed:@"ENSLogo.png"];
        
        CALayer *imageLayer = imageAvatar.layer;
        [imageLayer setBorderWidth:0];
        
        return avatarCell;
    } else {
        
        emTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
        cell.delegate = self;
        
        emMenu *menu = [arrOpenedMenu objectAtIndex:indexPath.row];
        if(menu)
        {
            [cell setCellData:menu];
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == 0)
        return 150;
    else
        return 36;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else
        return @"Menu Items";
}

-(NSString *) URLEncodeString:(NSString *) str
{
    
    NSMutableString *tempStr = [NSMutableString stringWithString:str];
    [tempStr replaceOccurrencesOfString:@" " withString:@"+" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempStr length])];
    
    
    return [[NSString stringWithFormat:@"%@",tempStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - UITableView Delegate -

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    emMenu *menu = [arrOpenedMenu objectAtIndex:indexPath.row];
    if(menu)
    {
        NSString *strSubUrl = menu.filename;
        NSString *strUrl = [NSString stringWithFormat:@"%@%@", HOMEPAGE, strSubUrl];
        strUrl = [self URLEncodeString:strUrl];
        NSURL* nsUrl = [NSURL URLWithString:strUrl];
        
        NSLog(@"link to: %@", [nsUrl absoluteString]);
        
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:nsUrl];
        [webView loadRequest:urlRequest];
        
        [self hideMenu];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - emTableViewCellDelegate

- (void)showChidMenu:(BOOL)bOpen menu:(emMenu *)menu
{
    NSInteger index = [arrOpenedMenu indexOfObject:menu];
    if(bOpen){
        [self setExtendMenus:menu idx:index];
    }
    else{
        [self setContractMenus:menu idx:index];
    }
}

@end
