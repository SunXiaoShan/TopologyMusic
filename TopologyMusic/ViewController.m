//
//  ViewController.m
//  TopologyMusic
//
//  Created by Phineas_Huang on 07/03/2017.
//  Copyright © 2017 SunXiaoShan. All rights reserved.
//

#import "ViewController.h"
#import "NodeManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"step 1");
    [[NodeManager getInstance] actionFillHole];
    NSLog(@"step 2");
    [[NodeManager getInstance] actionMakeBridge];
    NSLog(@"debug");
    [[NodeManager getInstance] debug];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
