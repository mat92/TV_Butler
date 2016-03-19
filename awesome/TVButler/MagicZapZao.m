//
//  MagicZapZao.m
//  TVButler
//
//  Created by Lukas Boehler on 19.03.16.
//  Copyright © 2016 TVButler. All rights reserved.
//

#import "MagicZapZao.h"

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
    
    finishBlock(@"Pro7");
}

@end
