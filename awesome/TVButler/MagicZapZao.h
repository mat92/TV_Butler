//
//  MagicZapZao.h
//  TVButler
//
//  Created by Lukas Boehler on 19.03.16.
//  Copyright © 2016 TVButler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MagicZapZao : NSObject

- (id)initWith:(NSArray *)interests andAvailableTVShows:(NSArray *)tvshows;

@property NSArray * interests;
@property NSArray * tvshows;

- (void)getNextZap:(void (^)(NSString * zapToTVShow))finishBlock;

@end
