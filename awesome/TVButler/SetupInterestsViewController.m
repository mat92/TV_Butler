//
//  SetupInterestsViewController.m
//  TVButler
//
//  Created by Lukas Boehler on 19.03.16.
//  Copyright © 2016 TVButler. All rights reserved.
//

#import "SetupInterestsViewController.h"
#import "YSLDraggableCardContainer.h"
#import "CardView.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

#define RGB(r, g, b)     [UIColor colorWithRed: (r) / 255.0 green: (g) / 255.0 blue: (b) / 255.0 alpha : 1]

@interface SetupInterestsViewController () <YSLDraggableCardContainerDelegate, YSLDraggableCardContainerDataSource>
@property (nonatomic, strong) YSLDraggableCardContainer *container;
@property (nonatomic, strong) NSMutableArray *datas;
@end

@implementation SetupInterestsViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _container = [[YSLDraggableCardContainer alloc]init];
    double topSpacing = 80.0;
    _container.frame = CGRectMake(0, topSpacing, self.view.frame.size.width, self.view.frame.size.height - topSpacing);
    _container.backgroundColor = [UIColor clearColor];
    _container.dataSource = self;
    _container.delegate = self;
    _container.canDraggableDirection = YSLDraggableDirectionLeft | YSLDraggableDirectionRight;
    [self.view addSubview:_container];
    
    NSString * sevenHackApiURLRequest = @"http://api.7hack.de:80/v1/tvshows?apikey=9VeEdUMw&selection=%7BtotalCount%2Cdata%7Bid%2Ctitles%7Bdefault%7D%2Ckeyworkds%7Bdefault%7D%2Cgenres%2Cimages%28subType%3A%22Cover%20Big%22%29%7Burl%2CsubType%7D%7D%7D";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET: sevenHackApiURLRequest parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSArray * tvShow = [[responseObject objectForKey: @"response"] objectForKey: @"data"];
        _datas = [NSMutableArray array];
        for (int i = 0; i < tvShow.count; i++) {
            NSDictionary * currentTVShow = [tvShow objectAtIndex: i];
            
            @try {
                NSDictionary *dict = @{@"image" : [[[currentTVShow objectForKey: @"images"] objectAtIndex: 0] objectForKey: @"url"],
                                       @"name" : [[currentTVShow objectForKey: @"titles"] objectForKey: @"default"]};
                [_datas addObject:dict];
            }
            @catch (NSException *exception) {
            }
            @finally {
            }
        }
        [_container reloadCardContainer];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark -- YSLDraggableCardContainer DataSource
- (UIView *)cardContainerViewNextViewWithIndex:(NSInteger)index
{
    NSDictionary *dict = _datas[index];
    CardView *view = [[CardView alloc]initWithFrame:CGRectMake(10, 64, self.view.frame.size.width - 20, self.view.frame.size.width - 20)];
    view.backgroundColor = [UIColor whiteColor];
    [view.imageView setImageWithURL: [NSURL URLWithString: dict[@"image"]]];
    view.imageView.contentMode = UIViewContentModeScaleAspectFill;
    view.label.text = [NSString stringWithFormat:@"%@  %ld",dict[@"name"],(long)index];
    return view;
}

- (NSInteger)cardContainerViewNumberOfViewInIndex:(NSInteger)index
{
    return _datas.count;
}

#pragma mark -- YSLDraggableCardContainer Delegate
- (void)cardContainerView:(YSLDraggableCardContainer *)cardContainerView didEndDraggingAtIndex:(NSInteger)index draggableView:(UIView *)draggableView draggableDirection:(YSLDraggableDirection)draggableDirection
{
    if (draggableDirection == YSLDraggableDirectionLeft) {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
    
    if (draggableDirection == YSLDraggableDirectionRight) {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
}

- (void)cardContainderView:(YSLDraggableCardContainer *)cardContainderView updatePositionWithDraggableView:(UIView *)draggableView draggableDirection:(YSLDraggableDirection)draggableDirection widthRatio:(CGFloat)widthRatio heightRatio:(CGFloat)heightRatio
{
    CardView *view = (CardView *)draggableView;
    
    if (draggableDirection == YSLDraggableDirectionDefault) {
        view.selectedView.alpha = 0;
    }
    
    if (draggableDirection == YSLDraggableDirectionLeft) {
        view.selectedView.backgroundColor = RGB(215, 104, 91);
        view.selectedView.alpha = widthRatio > 0.8 ? 0.8 : widthRatio;
    }
    
    if (draggableDirection == YSLDraggableDirectionRight) {
        view.selectedView.backgroundColor = RGB(114, 209, 142);
        view.selectedView.alpha = widthRatio > 0.8 ? 0.8 : widthRatio;
    }
}

- (void)cardContainerViewDidCompleteAll:(YSLDraggableCardContainer *)container;
{
    NSLog(@"++ Did CompleteAll");
    // Save interests and go for it.
}
          
- (void)cardContainerView:(YSLDraggableCardContainer *)cardContainerView didSelectAtIndex:(NSInteger)index draggableView:(UIView *)draggableView {
        NSLog(@"++ Tap card index : %ld",(long)index);
}

@end
