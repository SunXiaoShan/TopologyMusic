//
//  Uility.h
//  TopologyMusic
//
//  Created by Phineas_Huang on 07/03/2017.
//  Copyright © 2017 SunXiaoShan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MAX_SECTION 5
#define MAX_ROW 3

#define RAND_FROM_TO(min, max) (min + arc4random_uniform(max - min + 1))

@interface Uility : NSObject

@end
