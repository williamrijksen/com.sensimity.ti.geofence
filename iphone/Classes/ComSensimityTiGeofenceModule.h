/**
 * TiSensimityGeofence
 *
 * Created by William Rijksen
 * Copyright (c) 2016 Enrise. All rights reserved.
 */

#import "TiModule.h"
#import <CoreLocation/CoreLocation.h>

@interface ComSensimityTiGeofenceModule : TiModule<CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
}

@end
