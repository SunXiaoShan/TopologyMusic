//
//  Utility.m
//  TopologyMusic
//
//  Created by Phineas_Huang on 08/03/2017.
//  Copyright © 2017 SunXiaoShan. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+ (NSString *) getSerialNumber {
    
    static unsigned int serialNumber = 0;
    if (serialNumber > 9999) {
        serialNumber = 0;
    }else{
        serialNumber ++;
    }
    
    unsigned long long timeSerialNumber = [[NSDate date] timeIntervalSince1970];
    timeSerialNumber = timeSerialNumber * 10000 + serialNumber;
    
    return [NSString stringWithFormat:@"%llu", timeSerialNumber];
}

@end
