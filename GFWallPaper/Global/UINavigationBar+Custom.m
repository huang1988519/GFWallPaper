//
//  UINavigationBar+Custom.m
//  GFWallPaper
//
//  Created by 黄 伟华 on 13-10-12.
//  Copyright (c) 2013年 黄 伟华. All rights reserved.
//

#import "UINavigationBar+Custom.h"

@implementation UINavigationBar (Custom)
-(void)drawRect:(CGRect)rect{
    UIImage * image = [[UIImage imageNamed:@"barBackGround"] stretchableImageWithLeftCapWidth:5.f topCapHeight:5.f];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];

}
@end
