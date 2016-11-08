//
//  FlyView.m
//  PalyBallDemo
//
//  Created by taojin on 16/4/27.
//  Copyright © 2016年 jianhua. All rights reserved.
//

#import "FlyView.h"

#define MyScreen [UIScreen mainScreen ].bounds

@interface FlyView (){
    UIView *leftWing;
    UIView *rightWing;
    UIView *twoleftWing;
    UIView *tworightWing;
    NSTimer *flyTime;
    NSInteger count;
    BOOL flyFlag;
}

@end

@implementation FlyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initFlyView{
    leftWing  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/2.0, self.frame.size.width/2.0)];
    rightWing = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width/2.0, 0, self.frame.size.width/2.0, self.frame.size.width/2.0)];
    leftWing.center  = CGPointMake(leftWing.center.x, self.frame.size.height/2.0);
    rightWing.center = CGPointMake(rightWing.center.x, self.frame.size.height/2.0);
    leftWing.layer.contents = (id)[[UIImage imageNamed:@"left.png"] CGImage];
    rightWing.layer.contents = (id)[[UIImage imageNamed:@"right.png"] CGImage];
    rightWing.backgroundColor = [UIColor blackColor];
    leftWing.backgroundColor = [UIColor blackColor];
    [self addSubview:leftWing];
    [self addSubview:rightWing];
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)startFlyAnimation{

        if (flyTime == nil) {
            [UIView animateWithDuration:1.0 animations:^{
                CGFloat jd = -0.5*M_PI_4;
                self.transform = CGAffineTransformMake(0.5*cosf(jd), 0.8*sinf(jd), 0.5*-sinf(jd), 0.8*cosf(jd), 0, 0);
                rightWing.layer.anchorPoint = CGPointMake(0, 0.5);
                rightWing.center = CGPointMake(rightWing.center.x - rightWing.frame.size.width/2.0f, rightWing.center.y);
                leftWing.layer.anchorPoint = CGPointMake(1.0, 0.5);
                leftWing.center = CGPointMake(leftWing.center.x + leftWing.frame.size.width/2.0f, leftWing.center.y);

                [self dwMakeView:leftWing isleft:YES];
                
                [self dwMakeView:rightWing isleft:NO];
            } completion:^(BOOL finished) {
                count = 90;
                flyTime = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(changeCodeBtn:) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:flyTime forMode:NSRunLoopCommonModes];
                
            }];
    }

}

- (void)endFlyAnimation{
    if (flyTime) {
        [flyTime invalidate];
        flyTime = nil;
        self.transform = CGAffineTransformIdentity;
        CATransform3D doctorTran = CATransform3DIdentity;
        doctorTran.m11 = sinf(2.0*M_PI*(90/360.0f));
        rightWing.layer.transform = doctorTran;
        leftWing.layer.transform = doctorTran;
        rightWing.backgroundColor = [UIColor clearColor];
        leftWing.backgroundColor = [UIColor clearColor];
        rightWing.layer.mask = nil;
        leftWing.layer.mask = nil;
        leftWing.frame = CGRectMake(0, 0, MyScreen.size.width/2.0f, 40);
        rightWing.frame = CGRectMake(MyScreen.size.width/2.0f, 0, MyScreen.size.width/2.0f, 40);
        
    }
}

- (void)changeCodeBtn:(NSTimer *)t{
    
    if (count > 360) {
        count = 0;
    }
    
    if (count >= 90) {
        if (!flyFlag) {
            count = 97;
        }
        flyFlag = YES;
    }
    if (count <= 0) {
        if (flyFlag) {
            count = -10;
        }
        flyFlag = NO;
    }
    if (count < 90&&count > 0) {
        CATransform3D doctorTran = CATransform3DIdentity;
        doctorTran.m11 = sinf(2.0*M_PI*(count/360.0f));
        rightWing.layer.transform = doctorTran;
        leftWing.layer.transform = doctorTran;
    }
    
    if (flyFlag) {
        count--;
    }
    else{
        count++;
    }
    if (!flyTime) {
        [t invalidate];
        CATransform3D doctorTran = CATransform3DIdentity;
        doctorTran.m11 = sinf(2.0*M_PI*(90/360.0f));
        rightWing.layer.transform = doctorTran;
        leftWing.layer.transform = doctorTran;
    }
}
- (void)dwMakeView:(UIView *)view isleft:(BOOL)isleft
{
    CGSize size = view.frame.size;
    view.layer.mask = [self handleWingWithSize:size isleft:isleft];
    //[view.layer addSublayer:[self handleWingWithSize:size isleft:isleft]];
}

- (CAShapeLayer *)handleWingWithSize:(CGSize)size isleft:(BOOL)isleft{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    //[shapeLayer setFillColor:[[UIColor whiteColor] CGColor]];
    //[shapeLayer setStrokeColor:[[UIColor redColor] CGColor]];
    //[shapeLayer setLineWidth:2.0];
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat jd = 0;
    CGFloat scaleX = size.width/600.0f;
    CGFloat scaleY = size.height/600.0f;
    CGAffineTransform transform;
    if (isleft) {
        transform = CGAffineTransformMake(scaleX*cosf(jd), scaleY*sinf(jd), scaleX*sinf(jd), scaleY*cosf(jd), 0, 0);
    }
    else{
        transform = CGAffineTransformMake(-scaleX*cosf(jd), scaleY*sinf(jd), -scaleX*sinf(jd), scaleY*cosf(jd),size.width, 0);
    }
    CGPathMoveToPoint(path, &transform, 600.0f, 600.0f);
    CGPathAddQuadCurveToPoint(path, &transform, 585.0f, 200.0f, 400.0f, 185.0f);
    CGPathAddQuadCurveToPoint(path, &transform, 30.0f, 150.0f, 0.0f, 0.0f);
    CGPathAddQuadCurveToPoint(path, &transform, 0.0f, 194.0f, 120.0f, 200.0f);
    CGPathAddQuadCurveToPoint(path, &transform, 100.0f, 394.0f, 240.0f, 400.0f);
    CGPathAddQuadCurveToPoint(path, &transform, 200.0f, 594.0f, 600.0f, 600.0f);
    CGPathMoveToPoint(path, &transform, 545.0f, 372.0f);
    CGPathAddArc(path, &transform, 525, 372, 20, 0, 2*M_PI,  NO);
    CGPathCloseSubpath(path);
    [shapeLayer setPath:path];
    CFRelease(path);
    
//    CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    pathAnima.duration = 2.0f;
//    pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    pathAnima.fromValue = [NSNumber numberWithFloat:0.0f];
//    pathAnima.toValue = [NSNumber numberWithFloat:1.0f];
//    pathAnima.fillMode = kCAFillModeForwards;
//    pathAnima.removedOnCompletion = NO;
//    [shapeLayer addAnimation:pathAnima forKey:@"strokeEndAnimation"];
    return shapeLayer;

}

- (void)removeFromSuperview{
    [super removeFromSuperview];
    if (flyTime) {
        [flyTime invalidate];
        flyTime = nil;
    }
}

- (void)dealloc{
    if (flyTime) {
        [flyTime invalidate];
        flyTime = nil;
    }
}


@end
