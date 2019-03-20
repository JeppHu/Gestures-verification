//
//  ViewController.m
//  Unlock with gestures
//
//  Created by Jepp on 2019/3/14.
//  Copyright © 2019年 Jepp. All rights reserved.
//

#import "ViewController.h"
#import "JPGesturesView.h"

@interface ViewController ()

@property (weak, nonatomic) JPGesturesView *gesturesView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    JPGesturesView *view = [[JPGesturesView alloc] init];
    [view setLineColor:[UIColor cyanColor]];
    [view setLineWidth:5];
    [self.view addSubview:view];
    
    self.gesturesView = view;
    
    NSString *myPwd = @"012";
    [view setPasswordHandle:^BOOL(NSString * _Nonnull pwd) {
        BOOL res = [pwd isEqualToString:myPwd];
        if (res) {
            
        }
        return res;
    }];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.gesturesView setFrame:self.view.bounds];
}

@end
