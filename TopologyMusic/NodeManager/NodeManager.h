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

- (NSMutableArray *) getNodesMap;

- (Node *) getStartNode;
- (Node *) getEndNode;
- (NSArray<Node *> *) getMinPathList;

- (void) actionFillHole;
- (void) actionMakeBridge;
- (void) actionCaculateMinPath;
- (void) debug;

@end
