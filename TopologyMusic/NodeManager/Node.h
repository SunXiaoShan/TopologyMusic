//
//  Node.h
//  TopologyMusic
//
//  Created by Phineas_Huang on 07/03/2017.
//  Copyright © 2017 SunXiaoShan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Node : NSObject

@property(nonatomic, retain) NSMutableArray<Node *> *parents;
@property(nonatomic, retain) NSMutableArray<Node *> *children;

@property (nonatomic, readonly) NSString *nodeId;
@property (nonatomic) NSInteger value;
@property (nonatomic) BOOL isMinPath;
@property (nonatomic) NSInteger btnTag;

- (void) removeRelationshipNodes;

@end

