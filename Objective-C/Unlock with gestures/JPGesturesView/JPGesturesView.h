//
//  JPGesturesView.h
//  Unlock with gestures
//
//  Created by Jepp on 2019/3/14.
//  Copyright © 2019年 Jepp. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kGesturesColCount 3
#define kGesturesButtonCount 9
#define kGesturesButtonWidth 64

NS_ASSUME_NONNULL_BEGIN

@interface JPGesturesView : UIView

@property (copy, nonatomic) BOOL (^passwordHandle)(NSString *);
@property (strong, nonatomic) UIImage *normalImage;
@property (strong, nonatomic) UIImage *selectedImamge;
@property (strong, nonatomic) UIImage *disabledImage;
@property (strong, nonatomic) UIColor *lineColor;
@property (assign, nonatomic) CGFloat lineWidth;

@end

NS_ASSUME_NONNULL_END
