//
//  CFEntitys.h
//  GFWallPaper
//
//  Created by 黄 伟华 on 13-10-11.
//  Copyright (c) 2013年 黄 伟华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFMenuListEntity : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) UIImage  * coverImg;
@property (nonatomic, strong) NSString * link;
@end




@interface CFThumbItemEntity : CFMenuListEntity
@property (nonatomic, strong) NSString * thumbImg;

@end