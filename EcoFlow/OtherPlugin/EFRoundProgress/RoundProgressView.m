//
//  RoundProgressView.m
//  DrawRound
//
//  Created by Destiny on 2018/7/26.
//  Copyright © 2018年 Destiny. All rights reserved.
//

#import "RoundProgressView.h"
#import "EFCoreTextArcView.h"

/** Degrees to Radian **/
#define degreesToRadians(degrees) ((degrees) / 180.0 * M_PI)

/** Radians to Degrees **/
#define radiansToDegrees(radians) ((radians) * (180.0 / M_PI))


#define kBorderWith 45
#define center CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0)

@interface RoundProgressView()

@property (strong, nonatomic) CAShapeLayer *outLayer;
@property (strong, nonatomic) CAShapeLayer *progressLayer;
@property (strong, nonatomic) UILabel *progressLabel;

@end

@implementation RoundProgressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawProgress];
    }
    return self;
}

-(void)drawProgress{
    
    UIBezierPath *loopPath = [UIBezierPath bezierPathWithArcCenter:center radius:(self.bounds.size.width - kBorderWith)/ 2.0 startAngle:-M_PI endAngle:M_PI * 1.0 clockwise:YES];
    
    // 外圈
    self.outLayer = [CAShapeLayer layer];
    self.outLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    self.outLayer.lineWidth = kBorderWith;
    self.outLayer.fillColor =  [UIColor clearColor].CGColor;
    self.outLayer.path = loopPath.CGPath;
    self.outLayer.lineJoin = kCALineJoinRound;
//    self.outLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:self.outLayer];
    
    // 进度条
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    self.progressLayer.strokeColor = [UIColor blackColor].CGColor;
    self.progressLayer.lineWidth = kBorderWith;
    self.progressLayer.strokeStart = 0;
    self.progressLayer.strokeEnd = 0;
    self.progressLayer.path = loopPath.CGPath;
//    self.progressLayer.lineJoin = kCALineJoinRound;
//    self.progressLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:self.progressLayer];
    
    // 进度Label
    self.progressLabel = [UILabel new];
    self.progressLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.progressLabel.font = [UIFont systemFontOfSize:40];
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    self.progressLabel.text = @"--";
    [self addSubview:self.progressLabel];
    
    UIBezierPath *loop2Path = [UIBezierPath bezierPathWithArcCenter:center radius:(self.bounds.size.width - kBorderWith)/ 2.0 startAngle:-M_PI * 5 / 8.0 endAngle:-M_PI * 3 / 8.0 clockwise:YES];
    
    // 外圈
    CAShapeLayer *layer2 = [CAShapeLayer layer];
    layer2.strokeColor = [UIColor cyanColor].CGColor;
    layer2.lineWidth = kBorderWith;
    layer2.fillColor =  [UIColor clearColor].CGColor;
    layer2.path = loop2Path.CGPath;
//    layer2.lineCap = kCALineCapRound;
    [self.layer addSublayer:layer2];
    
    //创建渐变层
    CAGradientLayer *gLayer = [[CAGradientLayer alloc] init];
    gLayer.frame = self.bounds;
    gLayer.colors = @[(__bridge id)[UIColor greenColor].CGColor,(__bridge id)[UIColor redColor].CGColor];
    gLayer.startPoint = CGPointMake(0.5, 0);
    gLayer.endPoint = CGPointMake(1, 1);

    gLayer.mask = layer2;
    [self.layer addSublayer:gLayer];
    
    EFCoreTextArcView *arcViewTest = [[EFCoreTextArcView alloc] initWithFrame:self.bounds font:[UIFont systemFontOfSize:30] text:@"灯光" radius:115 arcSize:50 color:[UIColor blackColor]];
        arcViewTest.backgroundColor = [UIColor clearColor];
    [self addSubview:arcViewTest];
    [self bringSubviewToFront:arcViewTest];
    
}

- (void)updateProgress:(CGFloat)progress {
    self.progressLayer.strokeStart = 0.4;
        
    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [CATransaction setAnimationDuration:0.5];
    
    self.progressLayer.strokeEnd =  progress / 100.0;
    [CATransaction commit];
    
    self.progressLabel.text = [NSString stringWithFormat:@"%.0f",progress];
}

- (void)setLineDashPattern:(NSArray *)lineDashPattern
{
    _lineDashPattern = lineDashPattern;
    self.outLayer.lineDashPattern = lineDashPattern;
    self.progressLayer.lineDashPattern = lineDashPattern;
}

- (void)setProgressColor:(UIColor *)progressColor
{
    self.progressLayer.strokeColor = progressColor.CGColor;
    self.progressLabel.textColor = progressColor;
}

- (void)setProgressFont:(UIFont *)progressFont
{
    self.progressLabel.font = progressFont;
}

@end
