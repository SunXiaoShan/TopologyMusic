//
//  Node.m
//  TopologyMusic
//
//  Created by Phineas_Huang on 07/03/2017.
//  Copyright © 2017 SunXiaoShan. All rights reserved.
//

#import "Node.h"

@implementation Node

- (id) init {
    self = [super init];
    self.parents = [[NSMutableArray alloc] init];
    self.children = [[NSMutableArray alloc] init];
    _nodeId = [Utility getSerialNumber];
    self.value = RAND_FROM_TO(1, 7);
    self.isMinPath = NO;
    return self;
}

- (void) removeRelationshipNodes {
    self.isMinPath = NO;
    [self.parents removeAllObjects];
    [self.children removeAllObjects];
    self.value = RAND_FROM_TO(1, 7);
}

@end
