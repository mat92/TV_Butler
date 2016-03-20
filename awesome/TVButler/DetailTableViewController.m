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
@property (weak, nonatomic) IBOutlet UITextView *tvDescription;
@property (weak, nonatomic) IBOutlet UIButton *zapTo;

@end

@implementation DetailTableViewController

@synthesize tvShow;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)zapToParty:(id)sender {
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
    
    _zapTo.layer.cornerRadius = 5.0;
    
    NSArray * descriptions = [tvShow objectForKey: @"searchableTextItems"];
    NSString * description = @"";
    for(int i = 0; i < descriptions.count; i++) {
        NSDictionary * curr = [descriptions objectAtIndex: i];
        if([[curr objectForKey: @"type"] isEqualToString: @"long"]) {
            // THIS ONE!
            NSDictionary * value = [curr objectForKey: @"value"];
            if([value objectForKey: @"DE"]) {
                description = [value objectForKey: @"DE"];
            }
        }
    }
    
    // Configure the cell...
    _tvShowTitle.text = title;
    _tvShowSubTitle.text = [tvShow objectForKey: @"sourceName"];
    
    _tvDescription.text = description;
    
    NSArray * images = [tvShow objectForKey: @"relatedMaterial"];
    if(images.count > 0) {
        [_tvShowHeaderImage setImageWithURL: [NSURL URLWithString: [[images objectAtIndex: 0] objectForKey: @"value"]] placeholderImage: [UIImage imageNamed: @"no_image"]];
    } else {
        _tvShowHeaderImage.image = [UIImage imageNamed: @"no_image"];
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAction target:self action: @selector(shareIt:)];
}

- (void)shareIt:(id)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
