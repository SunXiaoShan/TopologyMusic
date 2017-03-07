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

@end

