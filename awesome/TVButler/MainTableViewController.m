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
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <Parse/Parse.h>
#import "tvShowTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>

@interface MainTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    myTVShows = [[NSMutableArray alloc] init];
    [self refreshTVShows];
    
    [self setNeedsStatusBarAppearanceUpdate];
    [self updateTime];
    [NSTimer scheduledTimerWithTimeInterval: 60.0
                                     target: self
                                   selector: @selector(updateTime)
                                   userInfo: nil
                                    repeats: YES];
}

- (void)loadCurrentTVShows {
    /* http://hack.api.uat.ebmsctogroup.com/stores-active/contentInstance/event/filter?numberOfResults=100&filter={%22criteria%22:[{%22term%22:%22publishedStartDateTime%22,%22operator%22:%22atLeast%22,%22value%22:%222016-03-19T18:00:00Z%22},{%22term%22:%22publishedStartDateTime%22,%22operator%22:%22atMost%22,%22value%22:%222016-03-19T22:00:00Z%22},{%22term%22:%22sourceName%22,%22operator%22:%22in%22,%22values%22:[%22RTL%22,%22ProSieben%22]}],%22operator%22:%22and%22}&api_key=240e4458fc4c6ac85c290481646b21ef */
    NSString * sevenHackApiURLRequest = @"";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET: sevenHackApiURLRequest parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)updateTime {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm"];
    _currentTimeLabel.text = [NSString stringWithFormat: @"Heute, %@", [dateFormatter stringFromDate:[NSDate date]]];
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
    NSString * appUrl = @"y9oM2n7YMl.tvbutler";
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
    /*[self.navigationController.navigationBar setBackgroundImage: [UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;*/
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
    tvShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tvShowCell" forIndexPath:indexPath];
    
    NSDictionary * currentTVShow = [myTVShows objectAtIndex: indexPath.row];
    
    // Configure the cell...
    cell.label.text = [currentTVShow objectForKey: @"name"];
    [cell.imageView setImageWithURL: [NSURL URLWithString: [currentTVShow objectForKey: @"image_url"]]];
    cell.containerView.layer.cornerRadius = 5.0;
    cell.progressView.frame = CGRectMake(0, 0, cell.containerView.frame.size.width * 0.4, cell.containerView.frame.size.height);
    
    return cell;
}

@end
