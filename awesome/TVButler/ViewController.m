//
//  ViewController.m
//  TVButler
//
//  Created by Lukas Boehler on 19.03.16.
//  Copyright © 2016 TVButler. All rights reserved.
//

#import "ViewController.h"
#import "SetupInterestsViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if(![PFUser currentUser]) {
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        logInViewController.signUpController.emailAsUsername = YES;
        logInViewController.signUpController.delegate = self;
        logInViewController.emailAsUsername = YES;
        logInViewController.delegate = self;
        UIImageView *logo = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"butler_logo"]];
        logo.contentMode=UIViewContentModeScaleAspectFit;
        logInViewController.logInView.logo = logo;
        
        UIImageView *logoA = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"butler_logo"]];
        logoA.contentMode=UIViewContentModeScaleAspectFit;
        logInViewController.signUpController.signUpView.logo = logoA;
        logInViewController.signUpController.signUpView.signUpButton.backgroundColor = [UIColor colorWithRed:0.9961 green:0.8078 blue:0.1961 alpha:1.0];
        
        [self presentViewController:logInViewController animated: NO completion:nil];
    } else {
        // We are logged in. Go party!
        [[PFUser currentUser] fetchInBackgroundWithBlock:^(PFObject *user, NSError *error) {
            NSString * trainingDone = [user objectForKey: @"trainingDone"];
            if(trainingDone && [trainingDone length] > 0) {
                UINavigationController * mainNavigationController = [self.storyboard instantiateViewControllerWithIdentifier: @"mainNavigationController"];
                [self presentViewController: mainNavigationController animated: YES completion: nil];
            } else {
                SetupInterestsViewController * setupInterestView = [self.storyboard instantiateViewControllerWithIdentifier: @"setupInterestView"];
                [self presentViewController: setupInterestView animated: YES completion:^{
                    
                }];
            }
        }];
    }
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    // log the user in.
    [signUpController dismissViewControllerAnimated: YES completion:^{
        
    }];
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [logInController dismissViewControllerAnimated: YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
