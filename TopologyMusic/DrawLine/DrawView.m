//
//  DrawView.m
//  TopologyMusic
//
//  Created by Phineas_Huang on 09/03/2017.
//  Copyright © 2017 SunXiaoShan. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView

+ (void) drawArrowLine:(UIView *)view from:(CGPoint)start to:(CGPoint)end color:(UIColor *)color {
    
    CGPoint point2 = CGPointMake((end.x+start.x)/2, (end.y+start.y)/2);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:start];
    [path addQuadCurveToPoint:end controlPoint:point2];
    
    CGFloat angle = atan2f(end.y - point2.y, end.x - point2.x);
    
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.path = path.CGPath;
    shape.lineWidth = 3;
    shape.strokeColor = color.CGColor;
    shape.fillColor = [UIColor clearColor].CGColor;
    shape.frame = view.bounds;
    [view.layer addSublayer:shape];
    
    CGFloat distance = 6.0;
    path = [UIBezierPath bezierPath];
    [path moveToPoint:end];
    [path addLineToPoint:[self calculatePointFromPoint:end angle:angle + M_PI_2 distance:distance]]; // to the right
    [path addLineToPoint:[self calculatePointFromPoint:end angle:angle          distance:distance]]; // straight ahead
    [path addLineToPoint:[self calculatePointFromPoint:end angle:angle - M_PI_2 distance:distance]]; // to the left
    [path closePath];
    
    shape = [CAShapeLayer layer];
    shape.path = path.CGPath;
    shape.lineWidth = 2;
    shape.strokeColor = color.CGColor;
    shape.fillColor = color.CGColor;
    shape.frame = view.bounds;
    [view.layer addSublayer:shape];
}

+ (CGPoint)calculatePointFromPoint:(CGPoint)point angle:(CGFloat)angle distance:(CGFloat)distance {
    return CGPointMake(point.x + cosf(angle) * distance, point.y + sinf(angle) * distance);
}

@end
