//
//  MagicZapZao.m
//  TVButler
//
//  Created by Lukas Boehler on 19.03.16.
//  Copyright © 2016 TVButler. All rights reserved.
//

#import "MagicZapZao.h"
#import <AFNetworking/AFHTTPSessionManager.h>

@implementation MagicZapZao

- (id)initWith:(NSArray *)interests andAvailableTVShows:(NSArray *)tvshows
{
    self = [super init];
    if(self)
    {
        // YO.
        _interests = interests;
        _tvshows = tvshows;
    }
    return self;
}

- (void)getNextZap:(void (^)(NSString * zapToTVShow))finishBlock {
    /*
     http://hack.api.uat.ebmsctogroup.com/stores-active/contentInstance/event/filter?numberOfResults=100&filter={"criteria":[{"term":"publishedStartDateTime","operator":"atLeast","value":"2016-03-19T18:00:00Z"},{"term":"publishedStartDateTime","operator":"atMost","value":"2016-03-19T22:00:00Z"},{"term":"sourceName","operator":"in","values":["RTL","ProSieben"]}],"operator":"and"}&api_key=240e4458fc4c6ac85c290481646b21ef
     */
    
    NSString * sevenHackApiURLRequest = @"";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET: sevenHackApiURLRequest parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        finishBlock(@"PRO7");
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
