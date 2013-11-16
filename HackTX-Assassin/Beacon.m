//
//  Beacon.m
//  HackTX-Assassin
//
//  Created by Alan Bouzek on 11/15/13.
//  Copyright (c) 2013 cmlinac. All rights reserved.
//

#import "Beacon.h"

@implementation Beacon
@synthesize centralManager, peripheralManager;

int distance;
NSDate *lastUpdated;
NSString *trackingIdentifier;

-(void)setup {
    centralManager = [[CBCentralManager alloc] init];
    peripheralManager = [[CBPeripheralManager alloc] init];
}

-(void)startTrackingForIdentifier:(NSString *)identifier {
    NSDictionary *scanOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@(YES)};
    NSArray *services = @[[CBUUID UUIDWithString:identifier]];
    trackingIdentifier = identifier;
    [centralManager scanForPeripheralsWithServices:services options:scanOptions];
}

-(void)stopTracking {
    trackingIdentifier = nil;
    [centralManager stopScan];
}

-(void)startAdvertisingWithIdentifier:(NSString *)identifier {
    NSDictionary *advertisingData = @{CBAdvertisementDataLocalNameKey:identifier,
                                      CBAdvertisementDataServiceUUIDsKey:@[[CBUUID UUIDWithString:identifier]]};
    [peripheralManager startAdvertising:advertisingData];
}

-(void)stopAdvertising {
    [peripheralManager stopAdvertising];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    if ([[advertisementData objectForKey:@"identifier"] isEqualToString:trackingIdentifier]) {
        distance = [RSSI intValue];
        lastUpdated = [NSDate date];
    }
}

- (int)convertRSSIToRange:(int)distance {
    if (distance < -86) {
        return 0;
    }
    else if (distance < -62) {
        return 1;
    }
    else if (distance < -31) {
        return 2;
    }
    else if (distance < 0) {
        return 3;
    }
    return -1;
}

- (int)distanceToTarget {
    if (lastUpdated && [[NSDate date] timeIntervalSinceDate:lastUpdated] < 20) {
        return [self convertRSSIToRange:distance];
    }
    return -1;
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {}

@end
