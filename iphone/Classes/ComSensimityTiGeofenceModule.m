/**
 * TiSensimityGeofence
 *
 * Created by William Rijksen
 * Copyright (c) 2016 Enrise. All rights reserved.
 */

#import "ComSensimityTiGeofenceModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation ComSensimityTiGeofenceModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"3f422fc5-a329-47c2-bae9-014d4660d891";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"com.sensimity.ti.geofence";
}

- (CLLocationManager *)locationManager
{
    if (_locationManager) {
        return _locationManager;
    } else {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        [_locationManager requestAlwaysAuthorization];
        return _locationManager;
    }
}

#pragma mark Cleanup

-(void)dealloc
{
    if (self.locationManager) {
        [self.locationManager release];
    }
	[super dealloc];
}

#pragma Public APIs

-(void) startMonitoringForRegion:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_SINGLE_ARG(args, NSDictionary);

    CLCircularRegion *region = [self regionForArgs:args];

    NSLog(@"[INFO] Turning on region monitoring in %@", region);

    [self.locationManager startMonitoringForRegion:region];
}

-(void)stopMonitoringAllRegions:(id)args
{
    for(id region in self.locationManager.monitoredRegions) {
        [self.locationManager stopMonitoringForRegion:region];
    }

    NSLog(@"[INFO] Turned off monitoring in ALL regions.");
}

#pragma Create region

- (CLCircularRegion *)regionForArgs:(id)args
{
    CGFloat latitude = [TiUtils floatValue:[args objectForKey:@"latitude"]];
    CGFloat longitude = [TiUtils floatValue:[args objectForKey:@"longitude"]];
    CGFloat radius = [TiUtils floatValue:[args objectForKey:@"radius"]];

    NSString *identifier = [TiUtils stringValue:[args objectForKey:@"identifier"]];

    CLCircularRegion *region = [self createCircularRegionWithLatitude: latitude
        longitude: longitude
        radius: radius
		identifier: identifier
    ];

    return region;
}

- (CLCircularRegion *)createCircularRegionWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude radius:(NSInteger)radius identifier:(NSString *)identifier
{
	CLLocationCoordinate2D center = CLLocationCoordinate2DMake(latitude, longitude);
	CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:center radius:radius identifier:identifier];

    return [region autorelease];
}

#pragma Fire event after enter or exit region

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"[INFO] Entered region %@", region.identifier);

    [self fireEvent:@"enteredRegion" withObject:[self detailsForBeaconRegion:(CLCircularRegion *)region]];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"[INFO] exited region %@", region.identifier);

    [self fireEvent:@"exitedRegion" withObject:[self detailsForBeaconRegion:(CLCircularRegion *)region]];
}

- (NSDictionary *)detailsForBeaconRegion:(CLBeaconRegion *)region
{
    NSMutableDictionary *details = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                             region.identifier, @"identifier",
                             nil
    ];

    return details;
}

@end
