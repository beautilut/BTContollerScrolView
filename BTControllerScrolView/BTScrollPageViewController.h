//
//  BTScrollPageViewController.h
//  BTControllerScrolView
//
//  Created by Beautilut on 2017/5/31.
//  Copyright © 2017年 beautilut. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BTScrollPageViewDelegate <NSObject>

//当前滑动视图
-(UIScrollView*)scrollView;

@end

@interface BTScrollPageViewController : UIViewController <BTScrollPageViewDelegate>

@end
