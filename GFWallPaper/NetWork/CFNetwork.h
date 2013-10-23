//
//  CFNetwork.h
//  GFWallPaper
//
//  Created by 黄 伟华 on 13-10-11.
//  Copyright (c) 2013年 黄 伟华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

@interface CFNetwork : NSObject
{
    @private
    NSMutableArray * listOfKinds;
}
/**
 *	@brief	返回单利
 */
+(instancetype)shareNetwork;

/**
 *	@brief	获取菜单列表
 *  @param  categaryList
             成功后通过block 传一个数组出来
 *  @return  void
 */
-(void)getMenuOfKinds:(void (^)(NSArray * categaryList))categaryListBlock
;
/**
 *	@brief	获取某个种类下的列表
     @param  kind
             种类名字
 *  @param  kindList
        成功后通过block 传一个种类下的列表
 *  @return  void
 */
-(void)getListOfKind:(NSString *)kind sucusse:(void (^)(NSArray * kindList))kindListBlock;

-(void)getBigPicture:(NSString *)bigPicUrl sucusse:(void (^)(NSString * bigUrl))bigPicUrlBlock;
@end
