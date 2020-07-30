var exec = require('cordova/exec');

function HyperTrackPlugin() { 
	console.log("HyperTrackPlugin.js: is created");
}

// Initialize SDK //
HyperTrackPlugin.prototype.initialize = function(publishableKey, success, error) {
	console.log("Initializing with key " + publishableKey);
	exec(success, error, "HyperTrackPlugin", 'initialize', [publishableKey]);
}

// Get the device Id //
HyperTrackPlugin.prototype.getDeviceId = function(success, error) {
	console.log("getDeviceId");
	exec(success, error, "HyperTrackPlugin", 'getDeviceId', []);
}

// Set the device name //
HyperTrackPlugin.prototype.setDeviceName = function(deviceName, success, error) {
	console.log("setDeviceName " + deviceName);
	exec(success, error, "HyperTrackPlugin", 'setDeviceName', [deviceName]);
}

// Set the device metadata //
HyperTrackPlugin.prototype.setDeviceMetadata = function(deviceMetadata, success, error) {
	const metadataString = JSON.stringify(deviceMetadata);
	console.log("setDeviceMetadata " + metadataString);
	exec(success, error, "HyperTrackPlugin", 'setDeviceMetadata', [metadataString]);
}



// FIRE READY //
exec(function(result){ console.log("HyperTrackPlugin is Ready") }, function(result){ console.log("HyperTrackPlugin Ready ERROR") }, "HyperTrackPlugin",'ready',[]);

var HyperTrackPlugin = new HyperTrackPlugin();
module.exports = HyperTrackPlugin;
