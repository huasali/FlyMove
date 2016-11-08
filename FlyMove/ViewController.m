//
//  ViewController.m
//  FlyMove
//
//  Created by sensology on 2016/11/8.
//  Copyright © 2016年 智觅智能. All rights reserved.
//

#import "ViewController.h"
#import "FlyView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FlyView *flyView = [[FlyView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    flyView.center = self.view.center;
    [flyView initFlyView];
    [flyView startFlyAnimation];
    [self.view addSubview:flyView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
