//
//  ViewController.m
//  BTControllerScrolView
//
//  Created by Beautilut on 2017/5/24.
//  Copyright © 2017年 beautilut. All rights reserved.
//

#import "ViewController.h"
#import "BTScrollViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    BTScrollViewController * vc = [[BTScrollViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
//    self.view.backgroundColor = [UIColor greenColor];

    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
