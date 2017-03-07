//
//  NodeManager.h
//  TopologyMusic
//
//  Created by Phineas_Huang on 07/03/2017.
//  Copyright © 2017 SunXiaoShan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Node.h"

@interface NodeManager : NSObject

+ (id) getInstance;

- (void) actionFillHole;
- (void) actionMakeBridge;
- (void) debug;

@end
