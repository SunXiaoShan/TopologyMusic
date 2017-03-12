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

+ (void) performInBackground:(NSString *) identifier executeBlock:(void (^)()) block{
    const char *queueId = [[NSString stringWithFormat:@"%@.%@", [[NSBundle mainBundle] bundleIdentifier], identifier] UTF8String];
    dispatch_queue_t queue = dispatch_queue_create(queueId, NULL);
    dispatch_async(queue, block);
}

+ (void) performInMainThread:(void (^)()) block {
    
    dispatch_async(dispatch_get_main_queue(),block);
}

@end
