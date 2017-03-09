//
//  DrawView.h
//  TopologyMusic
//
//  Created by Phineas_Huang on 09/03/2017.
//  Copyright © 2017 SunXiaoShan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <math.h>
#import <CoreGraphics/CoreGraphics.h>

@interface DrawView : UIView

+ (void) drawArrowLine:(UIView *)view from:(CGPoint)start to:(CGPoint)end color:(UIColor *)color;

@end
