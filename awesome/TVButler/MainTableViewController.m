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
@property (weak, nonatomic) IBOutlet UIImageView *botStatus;

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    myTVShows = [[NSMutableArray alloc] init];
    currentTVShows = [[NSMutableArray alloc] init];
    
    [self setNeedsStatusBarAppearanceUpdate];
    [self updateTime];
    [NSTimer scheduledTimerWithTimeInterval: 60.0
                                     target: self
                                   selector: @selector(updateTime)
                                   userInfo: nil
                                    repeats: YES];
}

- (void)loadCurrentTVShows {
    myTVShows = [[NSMutableArray alloc] init];
    [self loadTVShowForSenderID: @"760289"];
    [self loadTVShowForSenderID: @"751045"];
    [self loadTVShowForSenderID: @"751045"];
    [self loadTVShowForSenderID: @"755688"];
    [self loadTVShowForSenderID: @"759507"];
}

- (void)loadTVShowForSenderID:(NSString *)senderId {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSDate * dateTimeCurrentA = [[NSDate date] dateByAddingTimeInterval: -18000];
    NSString * dateTimeCurrent = [dateFormatter stringFromDate: dateTimeCurrentA];
    NSString * paras = [NSString stringWithFormat: @"{\"criteria\":[{\"term\":\"publishedStartDateTime\",\"operator\":\"atLeast\",\"value\":\"%@\"},{\"term\":\"sourceId\",\"operator\":\"in\",\"values\":[\"%@\"]}],\"operator\":\"and\"}", dateTimeCurrent, senderId];
    NSString * masterURL = [NSString stringWithFormat: @"http://hack.api.uat.ebmsctogroup.com/stores-active/contentInstance/event/filter?numberOfResults=10&filter=%@&api_key=240e4458fc4c6ac85c290481646b21ef", [paras stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLUserAllowedCharacterSet]]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET: masterURL parameters: nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        //myTVShows = responseObject;
        NSArray * objects = (NSArray *)responseObject;
        NSDateFormatter *dateFormatterA = [[NSDateFormatter alloc] init];
        [dateFormatterA setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'+00:00'"];
        for(int i = 0; i < objects.count; i++) {
            NSDictionary * currentTVShow = [objects objectAtIndex: i];
            NSString * publishedStartDateTime = [currentTVShow objectForKey: @"publishedStartDateTime"];
            NSDate * tvShowStartDate = [dateFormatterA dateFromString: publishedStartDateTime];
            int publishedDuration = [[currentTVShow objectForKey: @"publishedDuration"] intValue];
            NSDate * tvShowEndDate = [tvShowStartDate dateByAddingTimeInterval: publishedDuration];
            if([self date: [NSDate date] isBetweenDate: tvShowStartDate andDate: tvShowEndDate]) {
                [myTVShows addObject: currentTVShow];
            }
        }
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate {
    return (([date compare:beginDate] != NSOrderedAscending) && ([date compare:endDate] != NSOrderedDescending));
}

- (void)updateTime {
    NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm"];
    _currentTimeLabel.text = [NSString stringWithFormat: @"Heute, %@", [dateFormatter stringFromDate:[NSDate date]]];
    
    [self loadCurrentTVShows];
}

- (IBAction)start:(id)sender {
    [Service getByURI: @"http://10.100.105.182:8001/api/v2/" timeout: 5.0 completionHandler:^(Service * _Nullable service, NSError * _Nullable error) {
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
    NSString * appUrl = @"mEVluQrjzm.BasicProject";
    NSString * channelID = @"hackwerkstatt.7hack.tvbutler";
    
    awesomeApplication = [service createApplication: channelID channelURI: appUrl args: nil];
    awesomeApplication.connectionTimeout = 5.0;
    awesomeApplication.delegate = self;
    [awesomeApplication start:^(BOOL success, NSError * _Nullable error) {
        // YEP?
        if(success) {
            [awesomeApplication connect: @{ @"name": @"penis" } completionHandler:^(ChannelClient * _Nullable asdf, NSError * _Nullable errasdf) {
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
    _botStatus.image = [UIImage imageNamed: @"butler_red_logo"];
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
    
    
    NSArray * titles = [currentTVShow objectForKey: @"searchableTitles"];
    NSString * title = @"";
    for(int i = 0; i < titles.count; i++) {
        NSDictionary * curr = [titles objectAtIndex: i];
        if([[curr objectForKey: @"type"] isEqualToString: @"main"]) {
            // THIS ONE!
            NSDictionary * value = [curr objectForKey: @"value"];
            if([value objectForKey: @"DE"]) {
                title = [value objectForKey: @"DE"];
            }
        }
    }
    
    // Configure the cell...
    cell.label.text = title;
    cell.sender.text = [currentTVShow objectForKey: @"sourceName"];
    
    NSArray * images = [currentTVShow objectForKey: @"relatedMaterial"];
    if(images.count > 0) {
        [cell.imageView setImageWithURL: [NSURL URLWithString: [[images objectAtIndex: 0] objectForKey: @"value"]]];
    }
    
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
