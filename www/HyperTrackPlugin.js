var exec = require('cordova/exec');

function HyperTrackPlugin() { 
	console.log("HyperTrackPlugin.js: is created");
}

// Initialize SDK //
HyperTrackPlugin.prototype.initialize = function( publishableKey, success, error ){
	console.log("Initializing with key " + publishableKey);
	exec(success, error, "HyperTrackPlugin", 'initialize', [publishableKey]);
}

// FIRE READY //
exec(function(result){ console.log("HyperTrackPlugin is Ready") }, function(result){ console.log("HyperTrackPlugin Ready ERROR") }, "HyperTrackPlugin",'ready',[]);

var HyperTrackPlugin = new HyperTrackPlugin();
module.exports = HyperTrackPlugin;
