//
//  CFTableViewController.m
//  GFWallPaper
//
//  Created by 黄 伟华 on 13-10-11.
//  Copyright (c) 2013年 黄 伟华. All rights reserved.
//

#import "CFTableViewController.h"
#import "CFNetwork.h"
#import "UIImageView+AFNetworking.h"



#import "FSBasicImage.h"
#import "FSBasicImageSource.h"
@interface CFTableViewController ()
{
    
    //同一个界面所有元素
    NSArray * _allCatogaryAry;
}
@end

@implementation CFTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    isIpad?(nibNameOrNil = [nibNameOrNil stringByAppendingString:@"_iPad"]):nil;
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuWillAppear:) name:UIMenuWillAppearNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(meuWillDisAppear:) name:UIMenuWillDisAppearNotification object:nil];

    
    //    [self reloadDataWithKind:@"art"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataWithKind:) name:CFKindDidChangedNotification object:nil];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewDidAppear:animated];
}
-(void)menuWillAppear:(NSNotification *)notification{
    NSLog(@"%s",__FUNCTION__);
    [self.scrollSelect stopScrollingDriver];
}
-(void)meuWillDisAppear:(NSNotification *)notification{
    NSLog(@"%s",__FUNCTION__);
    [self.scrollSelect startScrollingDriver];
}

//获取数据
-(void)reloadDataWithKind:(id)kind
{
    NSString * value  = nil;
    if ([kind isKindOfClass:[NSString class]]) {
        value = kind;
    }else if ([kind isKindOfClass:[NSNotification class]]){
        CFMenuListEntity * _kind = [(NSNotification *)kind object];
        value = _kind.name;
    }
    
    [[CFNetwork shareNetwork] getListOfKind:value sucusse:^(NSArray *categaryList) {
        if (!categaryList) {
            return ;
        }
        NSLog(@"%@",categaryList);
        
        if (categaryList.count <= 10) {
            NSAssert(categaryList.count <= 10, @"返回列表数小于10个 ，不与显示") ;
        }
        _allCatogaryAry = [categaryList copy];
        
        
        NSUInteger count = categaryList.count;
        self.leftColumnData = [categaryList subarrayWithRange:NSMakeRange(0, count/3)];
        self.rightColumnData  = [categaryList subarrayWithRange:NSMakeRange(count/3, (categaryList.count - count/3))];
        
        [self.scrollSelect setNeedsLayout];
    }];
}




#pragma mark -
- (CGFloat)scrollRateForColumnAtIndex: (NSInteger) index {
    
    return 15 + index * 15;
}
-(NSInteger) numberOfColumnsInScrollSelect:(KLScrollSelect *)scrollSelect {
    return 2 ;
}
-(NSInteger) scrollSelect:(KLScrollSelect *)scrollSelect numberOfRowsInColumnAtIndex:(NSInteger)index {
    if (index == 0) {

        NSLog(@"第一列:%d",self.leftColumnData.count);
        return self.leftColumnData.count;
    }
    else
    NSLog(@"第二列:%d",self.rightColumnData.count);

     return self.rightColumnData.count;
}
- (UITableViewCell*) scrollSelect:(KLScrollSelect*) scrollSelect cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    KLScrollingColumn* column = [[scrollSelect columns] objectAtIndex: indexPath.column];
    KLImageCell* cell;
    
    if (IOS_VERSION >= 6.0) {
        [column registerClass:[KLImageCell class] forCellReuseIdentifier:@"Cell" ];
        cell = [column dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    } else {
        cell = [column dequeueReusableCellWithIdentifier:@"Cell"];
        if (cell == nil) {
            cell = [[KLImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        }
    }
    
    [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
    
    NSArray * ary = indexPath.column == 0?self.leftColumnData:self.rightColumnData;
    CFThumbItemEntity * entity =(CFThumbItemEntity *) [ary objectAtIndex:indexPath.row];
    
//    NSLog(@"url -> \n%@",[Base_Url stringByAppendingString:entity.thumbImg]);
    
    NSString * url =[[Base_Url stringByAppendingString:entity.thumbImg] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //防止重用
    [cell.image setImage:nil];
    [cell.image setAFImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"thumb_loading.png"]];

    return cell;
}
- (void)scrollSelect:(KLScrollSelect *)tableView didSelectCellAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected cell at index %d, %d, %d", indexPath.column, indexPath.section, indexPath.row);
    
//    
//    NSArray * arytmp = indexPath.column == 0?self.leftColumnData:self.rightColumnData;
//
//    
//    CFThumbItemEntity * entity =(CFThumbItemEntity *) [arytmp objectAtIndex:indexPath.row];
//
//    NSString *url = [entity.link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    [[CFNetwork shareNetwork] getBigPicture:url sucusse:^(NSString *bigUrl)
//     {
//        UIImageView * imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//         [self.view addSubview:imageView];
//        [imageView setAFImageWithURL:[NSURL URLWithString:[Base_Url stringByAppendingString:bigUrl]] placeholderImage:nil];
//    }];
//    
//    return;
    
     
    /*
    int count = self.leftColumnData.count + self.rightColumnData.count;
    NSArray * ary = indexPath.column == 0?self.leftColumnData:self.rightColumnData;
    CFThumbItemEntity * curEntity =(CFThumbItemEntity *) [ary objectAtIndex:indexPath.row];
    
    
    
    // 1.封装图片数据
    
    KLScrollingColumn* column = [[tableView columns] objectAtIndex: indexPath.column];
    KLImageCell* cell = (KLImageCell*)[column cellForRowAtIndexPath:indexPath];
    
    
    NSUInteger curIndex = 0;
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        CFThumbItemEntity * entity =(CFThumbItemEntity *) [_allCatogaryAry objectAtIndex:i];
        if ([entity.link isEqualToString:curEntity.link]) {
            curIndex = i;
        }
        NSString *url = [entity.link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = cell.image; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = curIndex; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    
    */
    
    
    
    int count = self.leftColumnData.count + self.rightColumnData.count;
    NSArray * ary = indexPath.column == 0?self.leftColumnData:self.rightColumnData;
    CFThumbItemEntity * curEntity =(CFThumbItemEntity *) [ary objectAtIndex:indexPath.row];
    
    
    
    // 1.封装图片数据
    
    
    
    NSUInteger curIndex = 0;
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        CFThumbItemEntity * entity =(CFThumbItemEntity *) [_allCatogaryAry objectAtIndex:i];
        if ([entity.link isEqualToString:curEntity.link]) {
            curIndex = i;
        }
        NSString *url = [entity.link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        
        FSBasicImage *firstPhoto = [[FSBasicImage alloc] initWithImageURL:[NSURL URLWithString:url] name:entity.name];
        [photos addObject:firstPhoto];
    }
    
    FSBasicImageSource *photoSource = [[FSBasicImageSource alloc] initWithImages:photos];
    FSImageViewerViewController * pushController = [[FSImageViewerViewController alloc] initWithImageSource:photoSource imageIndex:curIndex];
    
    [self.navigationController pushViewController:pushController animated:YES];
}
- (CGFloat) scrollSelect: (KLScrollSelect*) scrollSelect heightForColumnAtIndex: (NSInteger) index {
    if (isIpad) {
        return 250;
    }
    return 150;
}


@end
