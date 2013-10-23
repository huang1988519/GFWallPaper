//
//  CFEntitys.m
//  GFWallPaper
//
//  Created by 黄 伟华 on 13-10-11.
//  Copyright (c) 2013年 黄 伟华. All rights reserved.
//

#import "CFEntitys.h"

@implementation CFMenuListEntity



-(NSString *)description{
    return [NSString stringWithFormat:@"name:%@         link:%@         cover:%@",_name,_link,_coverImg];
}
@end


@implementation CFThumbItemEntity

-(NSString *)description{
    return [NSString stringWithFormat:@"name:%@         link:%@         thumb: %@",self.name,self.link,_thumbImg];
}

@end
