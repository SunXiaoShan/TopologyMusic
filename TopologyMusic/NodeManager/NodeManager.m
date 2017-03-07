//
//  NodeManager.m
//  TopologyMusic
//
//  Created by Phineas_Huang on 07/03/2017.
//  Copyright © 2017 SunXiaoShan. All rights reserved.
//


#import "NodeManager.h"

@interface NodeManager () {
    NSMutableArray *topologyMap;
    BOOL isFirstFillHole;
    NSInteger nodeCount;
}
@end

@implementation NodeManager

static NodeManager *instance = nil;

+ (id) getInstance
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[NodeManager alloc] init];
    });
    
    return instance;
}

- (id) init {
    self = [super init];
    [self resetVariable];
    return self;
}

- (int) getTotalNodes {
    return RAND_FROM_TO(9, 12);
}

- (void) resetVariable {
    // reset array map
    topologyMap = [[NSMutableArray alloc] initWithCapacity: MAX_SECTION];
    for (int i=0; i<MAX_SECTION; i++) {
        [topologyMap insertObject:[NSMutableArray arrayWithObjects:@"0",@"0",@"0",nil] atIndex:i];
    }
    

    isFirstFillHole = YES;
    nodeCount = 0;
}

- (void) actionFillHole {
    
    [self resetVariable];
    
    nodeCount = [self getTotalNodes];
    NSInteger buf = nodeCount;
    
    int section = 0;
    while (buf>0) {
        int min = isFirstFillHole?1:0;
        int max = MAX_ROW;
        int row = RAND_FROM_TO(min, max);
        NSLog(@"%d %d %d", row, max, min);
        
        if (row == 0) {
            section ++;
            continue;
        }
        
        if ([topologyMap[section][--row] isKindOfClass:[NSString class]]) {
            
            Node *node = [[Node alloc] init];
            topologyMap[section][row] = node;
            section ++;
            buf--;
        }
        
        if (section >= MAX_SECTION) {
            isFirstFillHole = NO;
            section = 0;
        }
    }
    
    [self debugNodeCount];
    
}

- (void) debugNodeCount {
    NSLog(@"node count: %ld", (long)nodeCount);
}

- (void) debugNodeMap {
    
    NSMutableString *str = [[NSMutableString alloc] initWithString:@"\n\n"];
    for (int row=0; row<MAX_ROW; row++) {
        for (int section=0; section<MAX_SECTION; section++) {
            if ([topologyMap[section][row] isKindOfClass:[Node class]]) {
                [str appendFormat:@"1\t"];
            } else {
                [str appendFormat:@"0\t"];
            }
        }
        [str appendFormat:@"\n\n"];
    }
    NSLog(@"map %@", str);
    
}



@end
