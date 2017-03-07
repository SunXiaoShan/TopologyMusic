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
    
    return self;
}

@end
