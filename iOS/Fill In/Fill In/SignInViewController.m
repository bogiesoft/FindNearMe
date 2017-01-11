//
//  SignInViewController.m
//  Fill In
//
//  Created by Tony Shark on 1/10/17.
//  Copyright © 2017 Tony Shark. All rights reserved.
//

#import "SignInViewController.h"
#import "SignUpViewController.h"
#import "ForgotViewController.h"

@interface SignInViewController ()

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    
   
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_login"]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ForgotAction
{
    ForgotViewController* ForgotController = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotViewController"];
    if ([[UIDevice currentDevice].systemVersion integerValue] >= 8)
    {
        //For iOS 8
        ForgotController.providesPresentationContextTransitionStyle = YES;
        ForgotController.definesPresentationContext = YES;
        ForgotController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    else
    {
        //For iOS 7
        ForgotController.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    
    ForgotController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    dispatch_after(0, dispatch_get_main_queue(), ^{
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:ForgotController];
        navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:navController animated:NO completion:nil];
    });
}
- (IBAction)SignUpAction
{
    SignUpViewController* SignUpController = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    if ([[UIDevice currentDevice].systemVersion integerValue] >= 8)
    {
        //For iOS 8
        SignUpController.providesPresentationContextTransitionStyle = YES;
        SignUpController.definesPresentationContext = YES;
        SignUpController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    else
    {
        //For iOS 7
        SignUpController.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    
    SignUpController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    dispatch_after(0, dispatch_get_main_queue(), ^{
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:SignUpController];
        navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:navController animated:NO completion:nil];
    });
}
- (IBAction)SignInAction
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:TRUE forKey:@"AUTH"];
    [self dismissViewControllerAnimated:NO completion:nil]; // ios 6
}
@end
