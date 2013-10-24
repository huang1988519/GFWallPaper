//
//  CFTableViewController.h
//  GFWallPaper
//
//  Created by 黄 伟华 on 13-10-11.
//  Copyright (c) 2013年 黄 伟华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLScrollSelect.h"
@interface CFTableViewController : UIViewController<KLScrollingColumnDelegate,KLScrollSelectDataSource,KLScrollSelectDelegate>
@property (weak, nonatomic) IBOutlet KLScrollSelect *scrollSelect;
@property (nonatomic, strong) NSArray * leftColumnData;
@property (nonatomic, strong) NSArray * rightColumnData;
@property (nonatomic, assign) UINavigationController * navigationController;

-(void)reloadDataWithKind:(NSString *)kind;

@end
