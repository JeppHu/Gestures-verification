//
//  GesturesView.m
//  Unlock with gestures
//
//  Created by Jepp on 2019/3/14.
//  Copyright © 2019年 Jepp. All rights reserved.
//

#import "GesturesView.h"

@interface GesturesView ()

@property (strong, nonatomic) NSMutableArray *btns;
@property (strong, nonatomic) NSMutableArray *lineBtns;
@property (assign, nonatomic) CGPoint currentPoint;

@end

@implementation GesturesView

- (NSMutableArray *)btns {
    if (!_btns) {
        _btns = [NSMutableArray arrayWithCapacity:kGesturesButtonCount];
        for (NSInteger i = 0; i < kGesturesButtonCount; i ++) {
            UIButton *btn = [[UIButton alloc] init];
            btn.userInteractionEnabled = NO;
            btn.tag = i;
            [btn setBackgroundImage:self.normalImage forState:UIControlStateNormal];
            [btn setBackgroundImage:self.selectedImamge forState:UIControlStateSelected];
            [btn setBackgroundImage:self.disabledImage forState:UIControlStateDisabled];
            [self addSubview:btn];
            [self.btns addObject:btn];
        }
    }
    return _btns;
}

- (NSMutableArray *)lineBtns {
    if (!_lineBtns) {
        _lineBtns = [NSMutableArray array];
    }
    return _lineBtns;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.normalImage = [UIImage imageNamed:@"gesture_normal"];
    self.selectedImamge = [UIImage imageNamed:@"gesture_selected"];
    self.disabledImage = [UIImage imageNamed:@"gesture_error"];
    if (!self.backgroundColor) {
        self.backgroundColor = [UIColor whiteColor];
    }
    self.lineColor = [UIColor lightGrayColor];
    self.lineWidth = 10;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat w = kGesturesButtonWidth;
    int colCount = kGesturesColCount;
    
    if (self.bounds.size.width >= self.bounds.size.height) {
        CGFloat margin = (self.bounds.size.height - w * colCount) / (colCount + 1);
        CGFloat side = (self.bounds.size.width - self.bounds.size.height) * 0.5;
        for (NSInteger i = 0; i < kGesturesButtonCount; i ++) {
            CGFloat x = (i % colCount) * (w + margin) + margin + side;
            CGFloat y = (i / colCount) * (w + margin) + margin;
            [self.btns[i] setFrame:CGRectMake(x, y, w, w)];
        }
    } else {
        CGFloat margin = (self.bounds.size.width - w * colCount) / (colCount + 1);
        CGFloat side = (self.bounds.size.height - self.bounds.size.width) * 0.5;
        for (NSInteger i = 0; i < kGesturesButtonCount; i ++) {
            CGFloat x = (i % colCount) * (w + margin) + margin;
            CGFloat y = (i / colCount) * (w + margin) + margin + side;
            [self.btns[i] setFrame:CGRectMake(x, y, w, w)];
        }
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *t = touches.anyObject;
    CGPoint p = [t locationInView:t.view];
    for (UIButton *btn in self.btns) {
        // 将点到的 btn 设置为选中状态
        if (CGRectContainsPoint(btn.frame, p)) {
            btn.selected = YES;
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *t = touches.anyObject;
    CGPoint p = [t locationInView:t.view];
    self.currentPoint = p;
    for (UIButton *btn in self.btns) {
        if (CGRectContainsPoint(btn.frame, p)) {
            btn.selected = YES;
            
            if (![self.lineBtns containsObject:btn]) {
                [self.lineBtns addObject:btn];
            }
        }
    }
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 验证密码
    [self getInputPassword];
    // 滑动的最后一刻, 将多出线取消
    self.currentPoint = [self.lineBtns.lastObject center];
    [self setNeedsDisplay];
}

- (void)getInputPassword {
    NSString *password = @"";
    for (UIButton *btn in self.lineBtns) {
        password = [password stringByAppendingString:[NSString stringWithFormat:@"%ld", btn.tag]];
    }
    NSLog(@"%@", password);
    if (self.passwordHandle) {
        BOOL res = self.passwordHandle(password);
        if (res) {
            [self clear];
        } else {
            [self error];
        }
    }
}

- (void)error {
    // 取消按钮的 selected 状态, 增加 enable 的状态
    for (UIButton *btn in self.lineBtns) {
        btn.selected = NO;
        btn.enabled = NO;
    }
    
    // 短暂关闭用户交互
    self.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.userInteractionEnabled = YES;
        [self clear];
    });
}

- (void)clear {
    // 取消按钮的 selected 状态, 还原 enable 的状态
    for (UIButton *btn in self.btns) {
        btn.selected = NO;
        btn.enabled = YES;
    }
    [self.lineBtns removeAllObjects];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (!self.lineBtns.count) {
        return;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (NSInteger i = 0; i < self.lineBtns.count; i ++) {
        UIButton *btn = self.lineBtns[i];
        // 起点
        if (i == 0) {
            [path moveToPoint:btn.center];
        } else {
            [path addLineToPoint:btn.center];
        }
    }
    
    // 连接到手指的位置
    [path addLineToPoint:self.currentPoint];
    
    [self.lineColor set];
    [path setLineWidth:self.lineWidth];
    [path setLineCapStyle:kCGLineCapRound];
    [path setLineJoinStyle:kCGLineJoinRound];
    [path stroke];
}

@end
