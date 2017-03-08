//
//  Node.h
//  TopologyMusic
//
//  Created by Phineas_Huang on 07/03/2017.
//  Copyright © 2017 SunXiaoShan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndexPath : NSObject

@property(nonatomic, retain) IndexPath *indexPath;
@property (nonatomic) NSInteger section;
@property (nonatomic) NSInteger row;
@end

@interface Node : NSObject

@property(nonatomic, retain) IndexPath *indexPath;
@property(nonatomic, retain) NSMutableArray<Node *> *parents;
@property(nonatomic, retain) NSMutableArray<Node *> *children;

@property (nonatomic, readonly) NSString *nodeId;
@property (nonatomic) NSInteger value;

- (void) removeRelationshipNodes;

@end

