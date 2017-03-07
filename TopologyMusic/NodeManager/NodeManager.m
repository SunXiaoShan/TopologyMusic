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
    NSMutableArray *topologyNodeMap;
    BOOL isFirstFillHole;
    NSInteger nodeCount;
    
    Node *startNode;
    Node *endNode;
}
@end

@implementation NodeManager

static NodeManager *instance = nil;

#pragma mark - get instance

+ (id) getInstance
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[NodeManager alloc] init];
    });
    
    return instance;
}

#pragma mark - private functions

- (id) init {
    self = [super init];
    [self resetVariable];
    startNode = [[Node alloc] init];
    endNode = [[Node alloc] init];
    return self;
}

- (int) getTotalNodes {
    return RAND_FROM_TO(9, 12);
}

- (void) resetVariable {
    // reset array map
    topologyMap = [[NSMutableArray alloc] initWithCapacity: MAX_SECTION];
    topologyNodeMap = [[NSMutableArray alloc] initWithCapacity: MAX_SECTION];
    for (int i=0; i<MAX_SECTION; i++) {
        [topologyMap insertObject:[NSMutableArray arrayWithObjects:@"0",@"0",@"0",nil] atIndex:i];
        [topologyNodeMap addObject:[[NSMutableArray alloc] init]];
    }
    
    isFirstFillHole = YES;
    nodeCount = 0;
}

#pragma mark - public functions

- (void) actionFillHole {
    
    [self resetVariable];
    
    nodeCount = [self getTotalNodes];
    NSInteger buf = nodeCount;
    
    int section = 0;
    while (buf>0) {
        int min = isFirstFillHole?1:0;
        int max = MAX_ROW;
        int row = RAND_FROM_TO(min, max);
        
        if (row == 0) {
            if (++section >=MAX_SECTION) {
                section = 0;
            }
            continue;
        }
        
        if ([topologyMap[section][--row] isKindOfClass:[NSString class]]) {
            Node *node = [[Node alloc] init];
            topologyMap[section][row] = node;
            [topologyNodeMap[section] addObject:node];
            section ++;
            buf--;
        }
        
        if (section >= MAX_SECTION) {
            isFirstFillHole = NO;
            section = 0;
        }
    }
}

- (void) actionMakeBridge {
    
    // create filter
    NSMutableArray *mask = [[NSMutableArray alloc] init];
    for (int i=0; i<MAX_ROW; i++) {
        [mask addObject:startNode];
    }
    
    for (int section=0; section<MAX_SECTION; section++) {
        NSMutableArray *_mask = [[NSMutableArray alloc] initWithObjects:@"",@"",@"", nil];
        
        for (int row=0; row<MAX_ROW; row++) {
            if ([topologyMap[section][row] isKindOfClass:[Node class]]) {
                Node *n = topologyMap[section][row];

                NSInteger index = RAND_FROM_TO(0, MAX_ROW-1);
                Node *p = mask[index];
                
                [n.parents addObject:p];
                [p.children addObject:n];
                _mask[row] = n;
            }
        }
        
        for (int i=0; i<[_mask count]; i++) {
            if ([_mask[i] isKindOfClass:[Node class]]) {
                Node *p = _mask[i];
                mask[i] = p;
            }
        }
    }
    
    // end node select a child
    while(1) {
        NSInteger index = RAND_FROM_TO(0, MAX_ROW-1);
        if ([topologyMap[MAX_SECTION-1][index] isKindOfClass:[Node class]]) {
            Node *n = topologyMap[MAX_SECTION-1][index];
            [endNode.parents addObject:n];
            [n.children addObject:endNode];
            break;
        }
    }
}

#pragma mark - debug functions

- (void) debug {
    [self debugNodeCount];
    [self debugNodeMap];
    
}

- (void) debugNodeCount {
    NSLog(@"node count: %ld", (long)nodeCount);
}

- (void) debugNodeMap {
    
    NSMutableString *str = [[NSMutableString alloc] initWithString:@"\n\n"];
    for (int row=0; row<MAX_ROW; row++) {
        for (int section=0; section<MAX_SECTION; section++) {
            if ([topologyMap[section][row] isKindOfClass:[Node class]]) {
                Node *n = topologyMap[section][row];
                [str appendFormat:@"%@", [NSString stringWithFormat:@"(%lu)1(%lu)\t",
                                   (unsigned long)[n.parents count],
                                   (unsigned long)[n.children count]]];
            } else {
                [str appendFormat:@"(X)0(X)\t"];
            }
        }
        [str appendFormat:@"\n\n"];
    }
    NSLog(@"map %@", str);
    
}



@end
