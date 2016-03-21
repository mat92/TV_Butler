//
//  MainTableViewController.h
//  TVButler
//
//  Created by Lukas Boehler on 19.03.16.
//  Copyright © 2016 TVButler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SmartView/SmartView.h>

@interface MainTableViewController : UITableViewController <ServiceSearchDelegate, ChannelDelegate> {
    ServiceSearch * samsungSearch;
    NSMutableArray * myTVShows;
    Application * awesomeApplication;
    NSMutableArray * currentTVShows;
    UIView * pizzaHud;
    NSDate * awesomeDate;
}

@end
