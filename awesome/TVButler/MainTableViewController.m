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
#import "DetailTableViewController.h"
#import "MagicZapZao.h"

@interface MainTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    myTVShows = [[NSMutableArray alloc] init];
    
    [self setNeedsStatusBarAppearanceUpdate];
    [self updateTime];
    [NSTimer scheduledTimerWithTimeInterval: 60.0
                                     target: self
                                   selector: @selector(updateTime)
                                   userInfo: nil
                                    repeats: YES];
}

- (void)loadCurrentTVShows {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSString * dateTimeCurrent = [dateFormatter stringFromDate: [NSDate date]];
    
    NSDictionary * filterPara = @{@"criteria": @[ @{@"term":@"publishedStartDateTime",@"operator":@"atLeast",@"value": dateTimeCurrent},@{@"term":@"publishedStartDateTime",@"operator":@"atMost",@"value": dateTimeCurrent},@{@"term":@"sourceId",@"operator":@"in",@"value": @[@760289, @751048, @751045]}],@"operator":@"and"};
    NSDictionary * paras = @{
                             @"filter": filterPara,
                             @"numberOfResults": @"100",
                             @"api_key": @"240e4458fc4c6ac85c290481646b21ef"
                             };
    
    NSString * sevenHackApiURLRequest = @"http://hack.api.uat.ebmsctogroup.com/stores-active/contentInstance/event/filter";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET: sevenHackApiURLRequest parameters: paras progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        myTVShows = responseObject;
        [self.tableView reloadData];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)updateTime {
    NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm"];
    _currentTimeLabel.text = [NSString stringWithFormat: @"Heute, %@", [dateFormatter stringFromDate:[NSDate date]]];
    
    // Update current tv shows.
    [self loadCurrentTVShows];
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
    
    awesomeApplication = [service createApplication: channelID channelURI: appUrl args: nil];
    awesomeApplication.connectionTimeout = 5.0;
    awesomeApplication.delegate = self;
    [awesomeApplication start:^(BOOL success, NSError * _Nullable error) {
        // YEP?
        if(success) {
            [awesomeApplication connect: @{} completionHandler:^(ChannelClient * _Nullable asdf, NSError * _Nullable errasdf) {
                if(asdf) {
                    NSLog(@"Should be connected... Maybe.. u never know!");
                }
            }];
        } else {
            // FUCK?
        }
    }];
}

- (void)onMessage:(Message *)message {
    if([message.event isEqualToString: @"availableChannels"]) {
        // YEP!
    }
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
    MagicZapZao * zapZap = [[MagicZapZao alloc] init];
    [zapZap getNextZap:^(NSString *zapToTVShow) {
        [awesomeApplication publishWithEvent: @"changeToChannel" message: zapToTVShow];
    }];
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
    //cell.label.text = [currentTVShow objectForKey: @"name"];
    cell.sender.text = [currentTVShow objectForKey: @"sourceName"];
    [cell.imageView setImageWithURL: [NSURL URLWithString: [currentTVShow objectForKey: @"image_url"]]];
    cell.containerView.layer.cornerRadius = 5.0;
    cell.progressView.frame = CGRectMake(0, 0, cell.containerView.frame.size.width * 0.4, cell.containerView.frame.size.height);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    DetailTableViewController * detailTableView = [self.storyboard instantiateViewControllerWithIdentifier: @"detailTableView"];
    detailTableView.tvShowName = @"Law And Order";
    [self.navigationController pushViewController: detailTableView animated: YES];
}

@end
