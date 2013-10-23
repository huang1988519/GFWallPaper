//
//  CFGlobal.m
//  GFWallPaper
//
//  Created by 黄 伟华 on 13-10-14.
//  Copyright (c) 2013年 黄 伟华. All rights reserved.
//

#import "CFGlobal.h"

@implementation CFGlobal
+(instancetype)shareGlobal{
    static CFGlobal * globalInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!globalInstance) {
            globalInstance = [[CFGlobal alloc] init];
        }
    });
    

    return globalInstance;
}

#pragma mark - -Set -Get
-(void)setKind:(CFMenuListEntity *)kind{
    if (!kind) {
        return;
    }
    _kind = kind;
    
    //发送通知，告诉种类已经改变
    [[NSNotificationCenter defaultCenter] postNotificationName:CFKindDidChangedNotification object:_kind];
}
@end
