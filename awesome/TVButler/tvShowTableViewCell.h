//
//  tvShowTableViewCell.h
//  TVButler
//
//  Created by Lukas Boehler on 19.03.16.
//  Copyright © 2016 TVButler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tvShowTableViewCell : UITableViewCell

@property IBOutlet UIImageView * imageView;
@property IBOutlet UILabel * label;
@property IBOutlet UILabel * sender;
@property IBOutlet UIView * containerView;
@property IBOutlet UIView * progressView;
@property IBOutlet NSLayoutConstraint * widthConstraint;

@end
