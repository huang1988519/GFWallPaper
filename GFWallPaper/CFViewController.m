//
//  CFViewController.m
//  GFWallPaper
//
//  Created by 黄 伟华 on 13-10-11.
//  Copyright (c) 2013年 黄 伟华. All rights reserved.
//

#import "CFViewController.h"
#import "CFNetwork.h"
#import "RNFrostedSidebar.h"

#import "CFTableViewController.h"
@interface CFViewController ()<RNFrostedSidebarDelegate>
@property (nonatomic, strong) NSMutableIndexSet * optionIndices;
@property (nonatomic, strong) RNFrostedSidebar *callout;
@end

@implementation CFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage * image = [[UIImage imageNamed:@"barBackGround"] stretchableImageWithLeftCapWidth:5.f topCapHeight:5.f];
    self.navigationController.navigationBar.layer.contents = (id)image.CGImage;
    
    
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:1];
    
    //添加手势
    UISwipeGestureRecognizer * swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showMune:)];
    swipeGesture.numberOfTouchesRequired = 1;
    swipeGesture.direction               = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGesture];
    swipeGesture = nil;
    
    

    
    
    //获取菜单数据
    [[CFNetwork shareNetwork] getMenuOfKinds:^(NSArray *categaryList) {
        NSArray * menuList = [categaryList copy];
        
        
        if (!menuList || menuList.count <=0) {
            AlertWithMsg(@"菜单没有数据");
        }
        self.menuArray = menuList;
        
        
        NSMutableArray * names = [NSMutableArray array];
        NSMutableArray * colors= [NSMutableArray array];
        [self.menuArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CFMenuListEntity * entity = obj;
            [names addObject:entity.name];
            
            
            [colors addObject:[UIColor colorWithRed:200/255.f green:242/255.f blue:0 alpha:1]];
        }];
        
        
        
        _callout = [[RNFrostedSidebar alloc] initWithImages:names selectedIndices:self.optionIndices borderColors:colors];
        _callout.tintColor = [UIColor colorWithRed:25/255.f green:35/255.f blue:45/255.f alpha:0.8];
        _callout.delegate = self;
        [_callout show];

        
    }];
    

    [self reloadData];

}
-(void)reloadData{
    
    CFTableViewController * tableView = [[CFTableViewController alloc] initWithNibName:@"CFTableViewController" bundle:nil];
    
    [self.view addSubview:tableView.view];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)showMune:(id)sender{
    [_callout show];
}
#pragma mark - RNFrostedSidebarDelegate
- (void)sidebar:(RNFrostedSidebar *)sidebar willShowOnScreenAnimated:(BOOL)animatedYesOrNo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UIMenuWillAppearNotification object:self];
}
- (void)sidebar:(RNFrostedSidebar *)sidebar didDismissFromScreenAnimated:(BOOL)animatedYesOrNo
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UIMenuWillDisAppearNotification object:self];

}
- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index
{
    
    [sidebar dismiss];
    
     CFMenuListEntity * entity = [self.menuArray objectAtIndex:index];
    [[CFGlobal shareGlobal] setKind:entity];
    self.title = entity.name;
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didEnable:(BOOL)itemEnabled itemAtIndex:(NSUInteger)index {
    [self.optionIndices removeAllIndexes];
}
@end
