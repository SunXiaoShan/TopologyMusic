//
//  Utility.h
//  TopologyMusic
//
//  Created by Phineas_Huang on 08/03/2017.
//  Copyright © 2017 SunXiaoShan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DrawView.h"

#define MAX_SECTION 5
#define MAX_ROW 3

#define RAND_FROM_TO(min, max) (min + arc4random_uniform(max - min + 1))

@interface Utility : NSObject

+ (NSString *) getSerialNumber;

@end
