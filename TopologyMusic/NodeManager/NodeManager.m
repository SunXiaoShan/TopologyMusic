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
        // TODO
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

- (void) handleParentNodes {
    // create filter
    NSMutableArray *mask = [[NSMutableArray alloc] init];
    for (int i=0; i<MAX_ROW; i++) {
        [mask addObject:startNode];
    }
    
    // for parent
    for (int section=0; section<MAX_SECTION; section++) {
        // TODO
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

- (void) handleChildrenNodes {
    // for children
    for (int section=0; section<MAX_SECTION-1; section++) {
        NSMutableArray *current = topologyNodeMap[section];
        NSMutableArray *next = topologyNodeMap[section+1];
        NSMutableArray *buf = [[NSMutableArray alloc] init];
        
        Node *n_0 = current[0];
        Node *n_1 = [current count]>1?current[1]:NULL;
        Node *n_2 = [current count]>2?current[2]:NULL;
        [buf addObject:n_0];
        if (n_1) {
            [buf addObject:n_1];
        }
        if (n_2) {
            [buf addObject:n_2];
        }
        
        Node *next_0 = next[0];
        Node *next_1 = [next count]>1?next[1]:NULL;
        Node *next_2 = [next count]>2?next[2]:NULL;
        [buf addObject:next_0];
        if (next_1) {
            [buf addObject:next_1];
        }
        if (next_2) {
            [buf addObject:next_2];
        }
        
        for (int row=0; row<[current count]; row++) {
            Node *n = current[row];
            NSInteger index = RAND_FROM_TO(0, [buf count]-1);
            Node *cmp = buf[index];
            if ([n.children count] == 0) {
                if (![n.nodeId isEqualToString:cmp.nodeId]) {
                    row--;
                    continue;
                }
                if ([cmp.children containsObject:n]) {
                    row--;
                    continue;
                }
                
                [n.children addObject:cmp];
                [cmp.parents addObject:n];
            }
        }
    }
    
    // for last section
    NSMutableArray *lastSection = topologyNodeMap[MAX_SECTION-1];
    Node *n_0 = lastSection[0];
    Node *n_1 = [lastSection count]>1?lastSection[1]:NULL;
    Node *n_2 = [lastSection count]>2?lastSection[2]:NULL;
    NSMutableArray *buf = [[NSMutableArray alloc] init];
    [buf addObject:endNode];
    [buf addObject:n_0];
    if (n_1) {
        [buf addObject:n_1];
    }
    if (n_2) {
        [buf addObject:n_2];
    }
    for (int row=0; row<[lastSection count]; row++) {
        Node *n = lastSection[row];
        NSInteger index = RAND_FROM_TO(0, [buf count]-1);
        Node *cmp = buf[index];
        if ([n.children count] == 0) {
            if ([n.nodeId isEqualToString:cmp.nodeId]) {
                row--;
                continue;
            }
            if ([cmp.parents containsObject:n]) {
                row--;
                continue;
            }
            [n.children addObject:cmp];
            [cmp.parents addObject:n];
        }
    }
}

- (void) actionMakeBridge {
    
    [self resetRelationshipNodes];
    
    [self handleParentNodes];
    [self handleChildrenNodes];
    
    if (![self isExistThreeChildrenNode]) {
        NSMutableArray *buf = [[NSMutableArray alloc] init];
        for (int section=0; section<[topologyNodeMap count]-1; section++) {
            NSMutableArray *rows = topologyNodeMap[section];
            NSMutableArray *nextRows = topologyNodeMap[section+1];
            if ([rows count] + [nextRows count] > 3 && [rows count] >= 2) {
                [buf addObject:rows];
            }
        }
        
        NSInteger radomSection = RAND_FROM_TO(0, [buf count]-1);
        NSMutableArray *temp = buf[radomSection];
        NSInteger mapIndex = [topologyNodeMap indexOfObject:temp];
        NSMutableArray *nextTemp = topologyNodeMap[mapIndex+1];
        
        NSInteger radomRow = RAND_FROM_TO(0, [temp count]-1);
        NSMutableArray *listTemp = [[NSMutableArray alloc] init];
        
        Node *n = temp[radomRow];
        if ([n.children count] > 3) {
            radomRow = ((radomRow-1)<0)?(radomRow+1):(radomRow-1);
            n = temp[radomRow];  // note
        }
        Node *n_0 = temp[0];
        [listTemp addObject:n_0];
        Node *n_1 = [temp count]>1?temp[1]:NULL;
        if (n_1) {
            [listTemp addObject:n_1];
        }
        Node *n_2 = [temp count]>2?temp[2]:NULL;
        if (n_2) {
            [listTemp addObject:n_2];
        }
        Node *next_0 = nextTemp[0];
        [listTemp addObject:next_0];
        Node *next_1 = [nextTemp count]>1?nextTemp[1]:NULL;
        if (next_1) {
            [listTemp addObject:next_1];
        }
        Node *next_2 = [nextTemp count]>2?nextTemp[2]:NULL;
        if (next_2) {
            [listTemp addObject:next_2];
        }
        
        for (int i=0; i<[listTemp count]; i++) {
            Node *cmp = listTemp[i];
            if ([n.nodeId isEqualToString:cmp.nodeId]) {
                continue;
            }
            if ([n.parents containsObject:cmp]) {
                continue;
            }
            if ([n.children containsObject:cmp]) {
                continue;
            }
            [n.children addObject:cmp];
            [cmp.parents addObject:n];
            
            if ([n.children count] == 3) {
                break;
            }
        }
    }
    
    NSInteger count = [self hasExistTwoChildrenNodesInInternal];
    if (count < 3) {
        for (int section=0; section<[topologyNodeMap count]-1; section++) {
            for (int row=0; row<[topologyNodeMap[section] count]; row++) {
                Node *node = topologyNodeMap[section][row];
                if ([node.children count] == 1) {
                    
                }
                
            }
        }
    }
    
    NSInteger is2Node = [self hasExistTwoChildrenNodesInInternal];
    NSInteger is3Node = [self isExistThreeChildrenNode];
    
    
    NSLog(@"is3Node :%d is2Node:%ld", is3Node, (long)is2Node);
    int test = 4234;

}

- (BOOL) isExistThreeChildrenNode {
    if ([startNode.children count] == 3) {
        return YES;
    }
    
    for (int section=0; section<[topologyNodeMap count]; section++) {
        for (int row=0; row<[topologyNodeMap[section] count]; row++) {
            Node *node = topologyNodeMap[section][row];
            if ([node.children count] == 3) {
                return YES;
            }
        }
    }
    return NO;
}

- (void) resetRelationshipNodes {
    [startNode removeRelationshipNodes];
    [endNode removeRelationshipNodes];
    
    for (int section=0; section<[topologyNodeMap count]; section++) {
        for (int row=0; row<[topologyNodeMap[section] count]; row++) {
            Node *node = topologyNodeMap[section][row];
            [node removeRelationshipNodes];
        }
    }
}

- (NSInteger) hasExistTwoChildrenNodesInInternal {
    NSInteger result = 0;
    for (int section=0; section<[topologyNodeMap count]; section++) {
        for (int row=0; row<[topologyNodeMap[section] count]; row++) {
            Node *node = topologyNodeMap[section][row];
            if ([node.children count] == 2) {
                result ++;
            }
        }
    }
    
    return result;
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
    
    NSInteger sumParent = 0;
    NSInteger sumChildren = 0;
    NSMutableString *str = [[NSMutableString alloc] initWithString:@"\n\n"];
    for (int row=0; row<MAX_ROW; row++) {
        for (int section=0; section<MAX_SECTION; section++) {
            
            if (section==0 && row==1) {
                [str appendFormat:@"%@", [NSString stringWithFormat:@"(%lu)1(%lu)\t",
                                  (unsigned long)[startNode.parents count],
                                  (unsigned long)[startNode.children count]]];
                sumParent += [startNode.parents count];
                sumChildren += [startNode.children count];
            }
            
            if ((section==0) && (row==0||row==2)) {
                [str appendFormat:@"\t\t"];
            }
            
            
            if ([topologyMap[section][row] isKindOfClass:[Node class]]) {
                Node *n = topologyMap[section][row];
                [str appendFormat:@"%@", [NSString stringWithFormat:@"(%lu)1(%lu)\t",
                                   (unsigned long)[n.parents count],
                                   (unsigned long)[n.children count]]];
                sumParent += [n.parents count];
                sumChildren += [n.children count];
                
            } else {
                [str appendFormat:@"(X)0(X)\t"];
            }
            
            if (section==4 && row==1) {
                [str appendFormat:@"%@", [NSString stringWithFormat:@"(%lu)1(%lu)\t",
                                          (unsigned long)[endNode.parents count],
                                          (unsigned long)[endNode.children count]]];
                sumParent += [endNode.parents count];
                sumChildren += [endNode.children count];
            }
        }
        [str appendFormat:@"\n\n"];
    }
    NSLog(@"map %@", str);
    NSLog(@"bridge = parent:%ld children:%ld", sumParent, sumChildren);
    
}



@end
