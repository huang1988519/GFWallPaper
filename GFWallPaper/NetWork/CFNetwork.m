//
//  CFNetwork.m
//  GFWallPaper
//
//  Created by 黄 伟华 on 13-10-11.
//  Copyright (c) 2013年 黄 伟华. All rights reserved.
//

#import "CFNetwork.h"
#import "TFHpple.h"

@interface CFNetwork ()
{
    AFHTTPClient * _client;
    NSString     * _path;
}
@end

@implementation CFNetwork

+(instancetype)shareNetwork{
    
    static CFNetwork  * network = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!network) {
            network = [[CFNetwork alloc] init];
        }
    });
    
    return network;
}
#pragma mark - instance methed

-(void)getMenuOfKinds:(void (^)(NSArray * categaryList))categaryListBlock
{
    
    
    if (!listOfKinds) {
        listOfKinds = [[NSMutableArray alloc] init];
    }else{
        categaryListBlock(listOfKinds);
    }
    
    __block NSMutableArray * lists = listOfKinds;
    
    
    
    NSURL *url=[[NSURL alloc]initWithString:Base_Url];//创建URL对象
    
    AFHTTPClient * request  = [AFHTTPClient clientWithBaseURL:url];
    [request getPath:nil parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        TFHpple * doc       = [[TFHpple alloc] initWithHTMLData:operation.responseData];
        
        
        
        NSArray * elements  = [doc searchWithXPathQuery:@"//td[@class='menu']/a"];
        [elements enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            CFMenuListEntity * entity = [[CFMenuListEntity alloc] init];
            
            TFHppleElement * element = [elements objectAtIndex:idx];
            
            NSString * name  =[[element firstChild] content];
            NSString * link  =[element objectForKey:@"href"];
            
            entity.name = name;
            entity.link = link;
            [lists addObject:entity];
            
            entity = nil;
        }];
        
        categaryListBlock(lists);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        categaryListBlock(nil);

    }];
    
    
}

-(void)getListOfKind:(NSString *)kind sucusse:(void (^)(NSArray * kindList))kindListBlock{

    if (_path) {
        NetworkShow(NO);
        NSLog(@"%@",[_client.operationQueue operations]);
        [_client cancelAllHTTPOperationsWithMethod:nil path:kind];
    }
    
    
    __block NSMutableArray * array = [NSMutableArray array];
    
    
    NSURL *url=[[NSURL alloc]initWithString:Base_Url];//创建URL对象
    if (!_client) {
        _client  = [AFHTTPClient clientWithBaseURL:url];

    }
    
    NetworkShow(YES);
    _path = [kind copy];
    
    
    [_client getPath:[kind lowercaseString] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NetworkShow(NO);

        
        TFHpple * doc       = [[TFHpple alloc] initWithHTMLData:operation.responseData];
        
        
        
        NSArray * elements  = [doc searchWithXPathQuery:@"//div[@class='table-div']/a"];
        [elements enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            CFThumbItemEntity * entity = [[CFThumbItemEntity alloc] init];
            
            TFHppleElement * element = [elements objectAtIndex:idx];
            
            NSString * name  =[[element firstChild] objectForKey:@"title"];
            NSString * thumb =[[element firstChild] objectForKey:@"src"];
            NSString * link  =[element objectForKey:@"href"];
            
            entity.name = name;
            entity.thumbImg = thumb;
            entity.link = link;
            [array addObject:entity];
            
            entity = nil;
        }];
        
        kindListBlock(array);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NetworkShow(NO);

        
        kindListBlock(nil);
        
    }];
    
    
}

-(void)getBigPicture:(NSString *)bigPicUrl sucusse:(void (^)(NSString * bigUrl))bigPicUrlBlock{
    
    __block NSMutableArray * array = [NSMutableArray array];
    
    
    NSURL *url=[[NSURL alloc]initWithString:Base_Url];//创建URL对象
    if (!_client) {
        _client  = [AFHTTPClient clientWithBaseURL:url];
        
    }
    
    NetworkShow(YES);
    
    
    [_client getPath:bigPicUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NetworkShow(NO);
        
        
        TFHpple * doc       = [[TFHpple alloc] initWithHTMLData:operation.responseData];
        
        
        
        NSArray * elements  = [doc searchWithXPathQuery:@"//div[@id='downloadbox']/a"];
        
        CFMenuListEntity * entity = [[CFMenuListEntity alloc] init];
        [elements enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            
            
            TFHppleElement * element = [elements objectAtIndex:idx];
            
            NSString * name  =[[element firstChild] content];
            NSString * link  =[element objectForKey:@"href"];
            
            entity.name = name;
            entity.link = link;
            
        }];
        
        bigPicUrlBlock(entity.link);
        entity = nil;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NetworkShow(NO);
        
        
        bigPicUrlBlock(nil);
        
        
    }];

    
}
@end
