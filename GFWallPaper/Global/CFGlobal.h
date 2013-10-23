//
//  CFGlobal.h
//  GFWallPaper
//
//  Created by 黄 伟华 on 13-10-14.
//  Copyright (c) 2013年 黄 伟华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFGlobal : NSObject
{
    @private
    
}
/**
 @brief  存储选中的分类
 */
@property (nonatomic, strong) CFMenuListEntity * kind;

+(instancetype)shareGlobal;

@end
