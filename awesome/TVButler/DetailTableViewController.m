//
//  DetailTableViewController.m
//  TVButler
//
//  Created by Lukas Boehler on 20.03.16.
//  Copyright © 2016 TVButler. All rights reserved.
//

#import "DetailTableViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <AFNetworking/AFHTTPSessionManager.h>

@interface DetailTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *tvShowHeaderImage;
@property (weak, nonatomic) IBOutlet UILabel *tvShowTitle;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tvContentSection;
@property (weak, nonatomic) IBOutlet UILabel *tvShowSubTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressConstraint;
@property (weak, nonatomic) IBOutlet UIView *progressView;

@end

@implementation DetailTableViewController

@synthesize tvShow;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    NSArray * titles = [tvShow objectForKey: @"searchableTitles"];
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
    _tvShowTitle.text = title;
    _tvShowSubTitle.text = [tvShow objectForKey: @"sourceName"];
    
    NSArray * images = [tvShow objectForKey: @"relatedMaterial"];
    if(images.count > 0) {
        [_tvShowHeaderImage setImageWithURL: [NSURL URLWithString: [[images objectAtIndex: 0] objectForKey: @"value"]]];
    }
    
    NSDateFormatter *dateFormatterA = [[NSDateFormatter alloc] init];
    [dateFormatterA setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'+00:00'"];
    NSString * publishedStartDateTime = [tvShow objectForKey: @"publishedStartDateTime"];
    NSDate * tvShowStartDate = [dateFormatterA dateFromString: publishedStartDateTime];
    float publishedDuration = [[tvShow objectForKey: @"publishedDuration"] intValue];
    float alreadyWatched = [[NSDate date] timeIntervalSince1970] - [tvShowStartDate timeIntervalSince1970];
    float progress = alreadyWatched / publishedDuration;
    _progressConstraint.constant = self.view.frame.size.width * progress;
    [_progressView needsUpdateConstraints];
    [_progressView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
