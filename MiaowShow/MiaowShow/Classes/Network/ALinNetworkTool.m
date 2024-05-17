//
//  ALinNetworkTool.m
//  MiaowShow
//
//  Created by ALin on 16/6/14.
//  Copyright © 2016年 ALin. All rights reserved.
//

#import "ALinNetworkTool.h"
#import "Reachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@implementation ALinNetworkTool
static ALinNetworkTool *_manager;
+ (instancetype)shareTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [ALinNetworkTool manager];
        // 设置超时时间
        _manager.requestSerializer.timeoutInterval = 5.f;
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
    });
    return _manager;
}


+ (NetworkStates)getNetworkStates {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    NetworkStates states = NetworkStatesNone;
    
    if (status == NotReachable) {
        states = NetworkStatesNone;
    } else if (status == ReachableViaWiFi) {
        states = NetworkStatesWIFI;
    } else if (status == ReachableViaWWAN) {
        CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
        NSString *currentRadioAccessTechnology = networkInfo.currentRadioAccessTechnology;
        
        if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS] ||
            [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge]) {
            states = NetworkStates2G;
        } else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyWCDMA] ||
                   [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSDPA] ||
                   [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSUPA] ||
                   [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMA1x] ||
                   [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0] ||
                   [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA] ||
                   [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB] ||
                   [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyeHRPD]) {
            states = NetworkStates3G;
        } else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE]) {
            states = NetworkStates4G;
        } else if (@available(iOS 14.1, *) && [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyNRNSA] ||
                   [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyNR]) {
            states = NetworkStates5G;
        }
    }
    
    return states;
}

@end
