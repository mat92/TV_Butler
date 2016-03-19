//
//  MainTableViewController.m
//  TVButler
//
//  Created by Lukas Boehler on 19.03.16.
//  Copyright © 2016 TVButler. All rights reserved.
//

#import "MainTableViewController.h"
#import "DevicesTableViewController.h"
#import <BIZPopupView/BIZPopupViewController.h>
#import <Parse/Parse.h>

@interface MainTableViewController ()

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    myTVShows = [[NSMutableArray alloc] init];
    [self refreshTVShows];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)refreshTVShows {
    [[PFUser currentUser] fetchInBackgroundWithBlock:^(PFObject *user, NSError *error) {
        if([user objectForKey: @"tvShows"]) {
            myTVShows = [user objectForKey: @"tvShows"];
            [self.tableView reloadData];
        }
    }];
}

- (IBAction)start:(id)sender {
    samsungSearch = [Service search];
    samsungSearch.delegate = self;
    [samsungSearch start];
    
    [Service getByURI: @"http://10.100.105.182:8001/api/v2/" timeout:5.0 completionHandler:^(Service * _Nullable service, NSError * _Nullable error) {
        if(service) {
            [self connectToTV: service];
        }
    }];
}

- (void)onServiceFound:(Service *)service {
}

- (void)onServiceLost:(Service *)service {
}

- (void)connectToTV:(Service *)service {
    NSString * appUrl = @"http://apps.appwerkstatt.net/tvbuttler/TVButler";
    NSString * channelID = @"hackwerkstatt.7hack.tvbutler";
    
    Application * awesomeApplication = [service createApplication: channelID channelURI: appUrl args: nil];
    awesomeApplication.connectionTimeout = 5.0;
    [awesomeApplication start:^(BOOL success, NSError * _Nullable error) {
        // YEP?
        if(success) {
            NSLog(@"YO:APP STARTED.");
        } else {
            // FUCK?
        }
    }];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        [self zapZap];
    } 
}

- (void)zapZap {
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage: [UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [myTVShows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tvShowCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    
    return cell;
}

@end
