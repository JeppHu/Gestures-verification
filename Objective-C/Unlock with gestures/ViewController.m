//
//  ViewController.m
//  Unlock with gestures
//
//  Created by Jepp on 2019/3/14.
//  Copyright © 2019年 Jepp. All rights reserved.
//

#import "ViewController.h"
#import "GesturesView.h"

@interface ViewController ()

@property (weak, nonatomic) GesturesView *gesturesView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    GesturesView *view = [[GesturesView alloc] init];
    [view setLineColor:[UIColor redColor]];
    [view setLineWidth:5];
    [self.view addSubview:view];
    self.gesturesView = view;
    
    NSString *yourPwd = @"012";
    [view setPasswordHandle:^BOOL(NSString * _Nonnull pwd) {
        BOOL res = [pwd isEqualToString:yourPwd];
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
