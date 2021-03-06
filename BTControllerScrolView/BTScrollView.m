//
//  BTScrollView.m
//  BTControllerScrolView
//
//  Created by Beautilut on 2017/5/31.
//  Copyright © 2017年 beautilut. All rights reserved.
//

#import "BTScrollView.h"

//typedef enum : NSUInteger {
//    BTScrollDirectLeft,
//    BTScrollDirectRight,
//} BTScrollDirect;

@interface BTScrollView () <UIScrollViewDelegate>

@property (nonatomic , strong) NSMutableSet * containSet;
@property (nonatomic , assign) NSInteger currentCount;
@end

@implementation BTScrollView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.pagingEnabled = YES;
        self.bounces = YES;
        self.containSet  = [NSMutableSet set];
        self.delegate = self;
    }
    return self;
}

-(void)reloadTable
{
    if ([self.btDataSource respondsToSelector:@selector(numberOfViewControllers)]) {
        self.currentCount = [self.btDataSource numberOfViewControllers];
        [self setContentSize:CGSizeMake(self.frame.size.width * self.currentCount, self.frame.size.height)];
        
        
        UIView * headerView = [self.btDataSource respondsToSelector:@selector(scrollerHeaderView)]? [self.btDataSource scrollerHeaderView] : nil;
        
        
        for (int x = 0 ; x < self.currentCount; x ++) {
            if ([self.btDataSource respondsToSelector:@selector(pageViewControllersAtIndex:)]) {
                BTScrollPageViewController * pageController = [self.btDataSource pageViewControllersAtIndex:x];
               
                CGRect frame = pageController.view.frame;
                frame.origin.x = x * frame.size.width;
                [pageController.view setFrame:frame];
                [self addSubview:pageController.view];
                 UIScrollView * scrol = [pageController scrollView];
                
                if (headerView) {
                    [scrol setContentInset:UIEdgeInsetsMake(headerView.frame.size.height, 0, 0, 0)];
                    
                    if (x == 0) {
                        CGRect frame = headerView.frame;
                        frame.origin.y = -frame.size.height;
                        headerView.frame = frame;
                        [scrol addSubview:headerView];
                        [scrol addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
                    }
                }
            }
        }
    }
}

-(void)setContentOffset:(CGPoint)contentOffset
{
    [super setContentOffset:contentOffset];
    
    NSInteger  leftIndex = contentOffset.x  / self.frame.size.width;
    NSInteger rightIndex = leftIndex + 1;
    if (rightIndex >= self.currentCount) {
        return;
    }
    
    if ([self.containSet containsObject:@(leftIndex)] && [self.containSet containsObject:@(rightIndex)]) {
        return;
    }else{
        NSInteger changeIndex = [self.containSet containsObject:@(leftIndex)] ? rightIndex : leftIndex;
        
        UIView * headerView = [self.btDataSource respondsToSelector:@selector(scrollerHeaderView)]? [self.btDataSource scrollerHeaderView] : nil;
        
        BTScrollPageViewController * pageController = [self.btDataSource pageViewControllersAtIndex:changeIndex];
        UIScrollView * scrol = [pageController scrollView];
        
        if (headerView) {
            if (headerView.frame.origin.y == - (headerView.frame.size.height - [self getScrollerHeight])) {
                [scrol setContentOffset:CGPointMake(0, - [self getScrollerHeight])];
            }else{
                [scrol setContentOffset:CGPointMake(0, -headerView.frame.size.height - headerView.frame.origin.y)];
            }
        }
        

        [self.containSet addObject:@(changeIndex)];
    }

    
}



-(void)updateHeader
{
    
}


#pragma mark  -- scroll view delegate --
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.btDelegate respondsToSelector:@selector(scrollViewDidScroll:)])
    {
        [self.btDelegate bt_scrollViewDidScroll:scrollView];
    }
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if ([self.btDelegate respondsToSelector:@selector(scrollViewDidZoom:)]) {
        [self.btDelegate bt_scrollViewDidZoom:scrollView];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if (scrollView == self) {
        NSInteger x = scrollView.contentOffset.x / self.frame.size.width;
        {
            [self.containSet removeAllObjects];
            [self.containSet addObject:@(x)];
        }
        BTScrollPageViewController * pageController = [self.btDataSource pageViewControllersAtIndex:x];
        UIScrollView * scrol = [pageController scrollView];
        
        UIView * headerView = [self.btDataSource respondsToSelector:@selector(scrollerHeaderView)]? [self.btDataSource scrollerHeaderView] : nil;
        if (headerView) {
            CGFloat contentOffSetY = -headerView.frame.size.height - scrol.contentOffset.y ;
            [headerView removeFromSuperview];
            CGRect frame = headerView.frame;
            frame.origin.y = contentOffSetY > -(headerView.frame.size.height - [self getScrollerHeight]) ? contentOffSetY : -(headerView.frame.size.height - [self getScrollerHeight]);
            headerView.frame = frame;
            [self.superview addSubview:headerView];
            
            [scrol removeObserver:self forKeyPath:@"contentOffset"];
        }
        
    }
    
    if ([self.btDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.btDelegate bt_scrollViewWillBeginDragging:scrollView];
    }
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if ([self.btDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.btDelegate bt_scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.btDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.btDelegate bt_scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if ([self.btDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [self.btDelegate bt_scrollViewWillBeginDecelerating:scrollView];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self) {
        UIView * headerView = [self.btDataSource respondsToSelector:@selector(scrollerHeaderView)]? [self.btDataSource scrollerHeaderView] : nil;
        if (headerView) {
            [headerView removeFromSuperview];
            CGRect frame = headerView.frame;
            NSInteger x = scrollView.contentOffset.x / self.frame.size.width;
            BTScrollPageViewController * pageController = [self.btDataSource pageViewControllersAtIndex:x];
            UIScrollView * scrol = [pageController scrollView];
            
            frame.origin.y = - headerView.frame.size.height;
            headerView.frame = frame;
            [scrol addSubview:headerView];
            
            [scrol addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        }
        
    }
    if ([self.btDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.btDelegate bt_scrollViewDidEndDecelerating:scrollView];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if ([self.btDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [self.btDelegate bt_scrollViewDidEndScrollingAnimation:scrollView];
    }
}

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if ([self.btDelegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
       return [self.btDelegate bt_viewForZoomingInScrollView:scrollView];
    }
    return nil;
}

-(void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    if ([self.btDelegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]) {
        [self.btDelegate bt_scrollViewWillBeginZooming:scrollView withView:view];
    }
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if ([self.btDelegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
        [self.btDelegate bt_scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}

-(BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    if ([self.btDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
        return [self.btDelegate bt_scrollViewShouldScrollToTop:scrollView];
    }
    return NO;
}

-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    if ([self.btDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
        [self.btDelegate bt_scrollViewShouldScrollToTop:scrollView];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark -- kvo --
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    UIScrollView * scrollView = object;
    UIView * header = [self.btDataSource respondsToSelector:@selector(scrollerHeaderView)]? [self.btDataSource scrollerHeaderView] : nil;
    if (header) {
        if (scrollView.contentOffset.y > -[self getScrollerHeight]) {
            CGRect frame = header.frame;
            frame.origin.y = scrollView.contentOffset.y - (header.frame.size.height - [self getScrollerHeight]);
            header.frame = frame;
        }else{
            CGRect frame = header.frame;
            frame.origin.y = -frame.size.height;
            header.frame = frame;
            
        }
    }
}

-(CGFloat)getScrollerHeight
{
    return [self.btDataSource respondsToSelector:@selector(scrollerFloatViewMarginHeight)] ? [self.btDataSource scrollerFloatViewMarginHeight] : 0;
}

@end
