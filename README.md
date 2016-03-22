## com.sensimity.ti.geofence

Start monitoring for geofences in one or more regions. This will continue in the background if the key `NSLocationAlwaysUsageDescription` is defined. Once the app has run once, iOS will start your app and run the event handler if it finds one of the monitored regions. The app does not have to be running.

### Usage
#### Start/stop monitoring
To start monitoring a geofence, define a latitude and longitude of the region you want to monitor. Also define a radius of the geofence and define a identifier of it. There is a maximum of 20 regions to monitor simultaneously.
##### To start monitor a region
```
var tiGeoFence = require('com.sensimity.ti.geofence');

var region = {
	"latitude": 51.550503,
	"longitude": -0.304841,
	"radius": 25, // radius in meters
	"identifier": "Wembley London"
};
tiGeoFence.startMonitoringForRegion(region);
```

##### To stop monitoring all regions
```
tiGeoFence.stopMonitoringAllRegions();
```

#### Handle enter/exit region
When the user reached a region, the enteredRegion event triggers. Depending of the definition of the `NSLocationAlwaysUsageDescription`-key, the application will be started for a few seconds so you're able to handle the entered/exited region signal even when the application is not started. 
##### Handle entering region
```
tiGeoFence.addEventListener('enteredRegion', function (region) {
    // region entered, region contains the identifier
	console.log(JSON.stringify(region));
});
```
##### Handle exited region
```
tiGeoFence.addEventListener('exitedRegion', function (region) {
    // region exited, region contains the identifier
	console.log(JSON.stringify(region));
});
```