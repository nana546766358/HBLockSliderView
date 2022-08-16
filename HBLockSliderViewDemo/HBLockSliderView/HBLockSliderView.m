
//
//  HBLockSliderView.m
//  MySliderDemo
//
//  Created by 屌炸天 on 16/9/18.
//  Copyright © 2016年 yhb. All rights reserved.
//

#define kSliderW self.bounds.size.width
#define kSliderH self.bounds.size.height
#define kCornerRadius 5.0  //默认圆角为5
#define kBorderWidth 0.2 //默认边框为2
#define kAnimationSpeed 0.5 //默认动画移速
#define kForegroundColor [UIColor clearColor] //默认滑过颜色
#define kBackgroundColor [UIColor clearColor] //默认未滑过颜色
#define kThumbColor [UIColor clearColor] //默认Thumb颜色
#define kBorderColor [UIColor clearColor] //默认边框颜色
#define kThumbW 15 //默认的thumb的宽度

#import "HBLockSliderView.h"
#import "UIImage+GIF.h"
@interface HBLockSliderView () {
    // UILabel *_label;
    UIImageView *_thumbImageView;
    UIView *_foregroundView;
    UIView *_touchView;
    
}


@end
@implementation HBLockSliderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    //    UIImageView *backgroundV = [[UIImageView alloc] initWithFrame:self.bounds];
    //    backgroundV.image = [self drawRoundedCornerImageWithSize:backgroundV.frame.size radius:kCornerRadius borderWidth:kBorderWidth backgroundColor:kBackgroundColor borderColor:kBorderColor];
    //    [self insertSubview:backgroundV atIndex:0];
    
    _anmiView = [[UILabel alloc] init];
    [self addSubview:_anmiView];
    
    
    _label = [[UILabel alloc] initWithFrame:self.bounds];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:18];
    _foregroundView = [[UIView alloc] init];
    [self addSubview:_foregroundView];
    
    UIView *sliderView = [[UIView alloc] init];
    sliderView.frame = CGRectMake(0, 0, kSliderW, 60);
    sliderView.backgroundColor = [UIColor clearColor];
    [self addSubview:sliderView];
    
    _thumbImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _thumbImageView.layer.cornerRadius = kCornerRadius;
    _thumbImageView.layer.masksToBounds = YES;
    [self addSubview:_thumbImageView];

    [self setSliderValue:0.0];
    //默认配置
    self.thumbBack = YES;
    self.backgroundColor = kBackgroundColor;
    _foregroundView.backgroundColor = kForegroundColor;
    _thumbImageView.backgroundColor = kThumbColor;
    [self.layer setBorderColor:kBorderColor.CGColor];
    _touchView = _thumbImageView;
    
    _touchView = sliderView;
    
    _nextLabel = [[UILabel alloc] init];
    _nextLabel.frame = _label.frame;
    _nextLabel.font = [UIFont systemFontOfSize:18.0f];
    _nextLabel.frame = CGRectMake((kSliderW-20)/2-15, 15, (kSliderW-20)/2, 30);
    _nextLabel.textAlignment = NSTextAlignmentLeft;
    _nextLabel.textColor = [UIColor clearColor];
    [self addSubview:_nextLabel];
    
    _thumbImageView.userInteractionEnabled = YES;
    _touchView.userInteractionEnabled = YES;
    _foregroundView.userInteractionEnabled = YES;
}

#pragma mark - Public
- (void)setText:(NSString *)text{
    _text = text;
    _label.text = text;
    if (!_label.superview) {
        [self insertSubview:_label atIndex:1];
    }
}

- (void)setFont:(UIFont *)font{
    _font = font;
    _label.font = font;
}

- (void)setSliderValue:(CGFloat)value{
    [self setSliderValue:value animation:NO completion:nil];
}

- (void)setSliderValue:(CGFloat)value animation:(BOOL)animation completion:(void (^)(BOOL))completion{
    if (value > 1) {
        value = 1;
    }
    if (value < 1) {
        value = 0;
    }
    CGPoint point = CGPointMake(value * kSliderW, 0);
    typeof(self) weakSelf = self;
    if (animation) {
        [UIView animateWithDuration:kAnimationSpeed animations:^{
            [weakSelf fillForeGroundViewWithPoint:point];
        } completion:^(BOOL finished) {
            if (completion) {
                completion(finished);
            }
        }];
    } else {
        [self fillForeGroundViewWithPoint:point];
    }
}

- (void)setColorForBackgroud:(UIColor *)backgroud foreground:(UIColor *)foreground thumb:(UIColor *)thumb border:(UIColor *)border textColor:(UIColor *)textColor{
    //self.backgroundColor = backgroud;
    // _foregroundView.backgroundColor = foreground;
    self.backgroundColor = backgroud;
    _thumbImageView.backgroundColor = thumb;
    [self.layer setBorderColor:border.CGColor];
    _label.textColor = textColor;
}

- (void)setThumbImage:(UIImage *)thumbImage{
    _thumbImage = thumbImage;
    _thumbImageView.image = thumbImage ;
    [_thumbImageView sizeToFit];
    [self setSliderValue:0.0];
}

- (void)setThumbBeginImage:(UIImage *)beginImage finishImage:(UIImage *)finishImage{
//    self.thumbImage = beginImage;
//    self.finishImage = finishImage;
    
    //469 196
    UIImage *statusImg = [UIImage sd_animatedGIFNamed:@"ly_slider"];
    
   // UIImageView *statusImgView = [LYControl setImageView:@"xxx"];
    //statusImgView.image = statusImg;
    //statusImgView.frame = CGRectMake(105, 30, 50, 50);
   // [statusImageView addSubview:statusImgView];
    self.thumbImage = statusImg;
    self.finishImage = statusImg;
}

- (void)removeRoundCorners:(BOOL)corners border:(BOOL)border{
    if (corners) {
        self.layer.cornerRadius = 0.0;
        self.layer.masksToBounds = NO;
        _thumbImageView.layer.cornerRadius = 0.0;
        _thumbImageView.layer.masksToBounds = NO;
    }
    if (border) {
        [self.layer setBorderWidth:0.0];
    }
}

- (void)setThumbHidden:(BOOL)thumbHidden{
    _thumbHidden = thumbHidden;
    _touchView = thumbHidden ? self : _thumbImageView;
    _thumbImageView.hidden = thumbHidden;
}


#pragma mark - Private
- (void)fillForeGroundViewWithPoint:(CGPoint)point{
    CGFloat thunmbW = self.thumbImage ? self.thumbImage.size.width : kThumbW;
    CGPoint p = point;
    //修正
    p.x += thunmbW/2;
    if (p.x > kSliderW) {
        p.x = kSliderW;
    }
    if (p.x < 0) {
        p.x = 0;
    }
    if (self.finishImage) {
        _thumbImageView.image = point.x  < (kSliderW - thunmbW/2) ? self.thumbImage : self.finishImage;
    }
    self.value = p.x  / kSliderW;
    
    if (point.x > kSliderW-20) {
        _foregroundView.frame = CGRectMake(0, 0, kSliderW-20, kSliderH);
    } else {
        _foregroundView.frame = CGRectMake(0, 0, point.x, kSliderH);
    }
    
    if (point.x == kSliderW-30) {
       // [self.delegate sliderHalfValue];
    }
    
    //修改滑动图片位置/大小
    if (_foregroundView.frame.size.width <= 0) {
        _thumbImageView.frame = CGRectMake(20, 20, 20, 20);
    }else if (_foregroundView.frame.size.width >= kSliderW) {
        _thumbImageView.frame = CGRectMake(_foregroundView.frame.size.width-20, 20, 20, 20);
    }else{
        _thumbImageView.frame = CGRectMake(_foregroundView.frame.size.width-20/2, 20, 20, 20);
    }
    
}

#pragma mark - optimize（TODO）
- (UIImage *)imageAddCornerWithImage:(UIImage *)image Radius:(CGFloat)radius andSize:(CGSize)size{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    CGContextAddPath(ctx,path.CGPath);
    CGContextClip(ctx);
    //    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    [image drawInRect:rect];
    CGContextDrawPath(ctx, kCGPathFillStroke);
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)drawRoundedCornerImageWithSize:(CGSize)size radius:(CGFloat)radius borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor borderColor:(UIColor *)borderColor{
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, borderWidth);
    CGContextSetStrokeColorWithColor(ctx, borderColor.CGColor);
    CGContextSetFillColorWithColor(ctx, backgroundColor.CGColor);
    CGFloat halfBorderWidth = borderWidth * 0.5;
    CGContextMoveToPoint(ctx, size.width - halfBorderWidth, radius + halfBorderWidth);  // 开始坐标右边开始
    CGContextAddArcToPoint(ctx, size.width - halfBorderWidth, size.height - halfBorderWidth, size.width - radius - halfBorderWidth, size.height - halfBorderWidth, radius);  // 右下角角度
    CGContextAddArcToPoint(ctx, halfBorderWidth, size.height - halfBorderWidth, halfBorderWidth, size.height - radius - halfBorderWidth, radius); // 左下角角度
    CGContextAddArcToPoint(ctx, halfBorderWidth, halfBorderWidth, size.width - halfBorderWidth, halfBorderWidth, radius); // 左上角
    CGContextAddArcToPoint(ctx, size.width - halfBorderWidth, halfBorderWidth, size.width - halfBorderWidth, radius + halfBorderWidth, radius); // 右上角
    CGContextDrawPath(ctx, kCGPathFillStroke);
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark - Touch
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = [touches anyObject];
//    if ( _touchView == _thumbImageView) {
//        return;
//    }
//    CGPoint point = [touch locationInView:self];
//    NSLog(@"point.x == %f",point.x);
//    [self fillForeGroundViewWithPoint:point];
//}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
//    if (touch.view != _touchView || touch.view != _thumbImageView) {
//        return;
//    }
    
    CGPoint point = [touch locationInView:self];
    [self fillForeGroundViewWithPoint:point];
    if ([self.delegate respondsToSelector:@selector(sliderValueChanging:)] ) {
        [self.delegate sliderValueChanging:self];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
//    if (touch.view != _touchView) {
//        return;
//    }
    CGPoint __block point = [touch locationInView:self];
    if ([self.delegate respondsToSelector:@selector(sliderEndValueChanged:)]) {
        [self.delegate sliderEndValueChanged:self];
    }
    typeof(self) weakSelf = self;
    if (_thumbBack) {
        //回到原点
        [UIView animateWithDuration:0.5 animations:^{
            point.x = 0;
            [weakSelf fillForeGroundViewWithPoint:point];
            if ([self.delegate respondsToSelector:@selector(sliderEndValueChanged:)]) {
                //   [self.delegate sliderEndValueChanged:self];
            }
        }];
    }
}

@end
