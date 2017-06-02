//
//  BTScrollViewController.m
//  BTControllerScrolView
//
//  Created by Beautilut on 2017/5/31.
//  Copyright © 2017年 beautilut. All rights reserved.
//

#import "BTScrollViewController.h"
#import "BTScrollView.h"

@interface BTScrollViewController () <BTScrollViewDataSource , BTScrollViewDelegate>

@property (nonatomic , strong) BTScrollView * btScrollView;

@property (nonatomic , strong) NSMutableArray * vcLists;

@property (nonatomic , strong) UIView * headerView;
@end

@implementation BTScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btScrollView = [[BTScrollView alloc] initWithFrame:self.view.bounds];
    self.btScrollView.btDelegate = self;
    self.btScrollView.btDataSource = self;
    [self.view addSubview:_btScrollView];
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
    self.headerView.backgroundColor = [UIColor redColor];
    UIButton * touchButton = [[UIButton alloc] initWithFrame:CGRectMake(130, 130, 40, 40)];
    [touchButton setBackgroundColor:[UIColor greenColor]];
    [touchButton addTarget:self action:@selector(touchClick) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:touchButton];
    
    self.vcLists = [[NSMutableArray alloc] init];
    
    BTScrollPageViewController * vc1 = [[BTScrollPageViewController alloc] init];
    [self.vcLists addObject:vc1];
    
    BTScrollPageViewController * vc2 = [[BTScrollPageViewController alloc] init];
    [self.vcLists addObject:vc2];
    
    BTScrollPageViewController * vc3 = [[BTScrollPageViewController alloc] init];
    [self.vcLists addObject:vc3];
    
    BTScrollPageViewController * vc4 = [[BTScrollPageViewController alloc] init];
    [self.vcLists addObject:vc4];
    
    [self.btScrollView reloadTable];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchClick
{
    NSLog(@"click");
}

#pragma mark  -- 

-(NSInteger)numberOfViewControllers
{
    return self.vcLists.count;
}

-(BTScrollPageViewController*)pageViewControllersAtIndex:(NSInteger)index
{
    return [self.vcLists objectAtIndex:index];
}

-(UIView*)scrollerHeaderView
{
    return self.headerView;
}

@end
