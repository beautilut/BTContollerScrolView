//
//  BTScrollView.h
//  BTControllerScrolView
//
//  Created by Beautilut on 2017/5/31.
//  Copyright © 2017年 beautilut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTScrollerViewProtocol.h"


@interface BTScrollView : UIScrollView

@property (nonatomic , weak) id <BTScrollViewDelegate> btDelegate;
@property (nonatomic , weak) id <BTScrollViewDataSource> btDataSource;

-(void)reloadTable;
@end
