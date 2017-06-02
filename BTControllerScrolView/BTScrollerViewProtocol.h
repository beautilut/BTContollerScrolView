//
//  BTScrollerViewProtocol.h
//  BTControllerScrolView
//
//  Created by Beautilut on 2017/5/31.
//  Copyright © 2017年 beautilut. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BTScrollPageViewController.h"

@protocol BTScrollViewDataSource <NSObject>

-(UIView*)scrollerHeaderView;

@required
//
-(NSInteger)numberOfViewControllers;

//
-(BTScrollPageViewController*)pageViewControllersAtIndex:(NSInteger)index;

@end

@protocol BTScrollViewDelegate <NSObject>

- (void)bt_scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)bt_scrollViewDidZoom:(UIScrollView *)scrollView NS_AVAILABLE_IOS(3_2);


- (void)bt_scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)bt_scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0);
- (void)bt_scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

- (void)bt_scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
- (void)bt_scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

- (void)bt_scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;

- (nullable UIView *)bt_viewForZoomingInScrollView:(UIScrollView *)scrollView;
- (void)bt_scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view NS_AVAILABLE_IOS(3_2);
- (void)bt_scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale;

- (BOOL)bt_scrollViewShouldScrollToTop:(UIScrollView *)scrollView;
- (void)bt_scrollViewDidScrollToTop:(UIScrollView *)scrollView;

@end


