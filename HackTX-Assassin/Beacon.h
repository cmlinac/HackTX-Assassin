//
//  Beacon.h
//  HackTX-Assassin
//
//  Created by Alan Bouzek on 11/15/13.
//  Copyright (c) 2013 cmlinac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface Beacon : NSObject <CBCentralManagerDelegate, CBPeripheralManagerDelegate>

@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
@property (nonatomic, strong) CBCentralManager *centralManager;

- (void)setup;
- (void)startTrackingForIdentifier:(NSString*)identifier;
- (void)stopTracking;
- (void)startAdvertisingWithIdentifier:(NSString*)identifier;
- (void)stopAdvertising;
- (int)distanceToTarget;

@end
