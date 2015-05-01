
// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
// = require jquery
// = require jquery_ujs
//= require jquery.turbolinks
// = require turbolinks
//= require faye
// = require_tree .


// $(function(){
//   $('.quest').mouseenter(function(){
//     alert("ENTER");
//   });
//   $('.quest').mouseleave(function(){
//     alert("LEAVE");
//   });
// });

function initFayeClient() {
	return new Faye.Client('/faye');
};

function subscribeForNotifications(channel) {
	// var client;
	// client = new Faye.Client('/faye');
  var subscription = client.subscribe(channel, function(payload) {
  	respondToNotification(payload, channel);
  });
};

function unsubscribeForNotifications(subscription) {
	subscription.cancel();
};

function publishNotification(channel, payload, redirect) {
	if (typeof channel !== "undefined" && channel !== null) {
		publisher = client.publish(channel, payload);
	}
	if (typeof redirect !== "undefined" && redirect !== null) {
		publisher.then(function() {
		  // OK
		  $(window.location.replace(redirect));
		}, function(error) {
		  // NOT OK, redirect
		  $(window.location.replace(redirect));
		});
	}
};

function quitClient(client) {
	if (typeof client !== "undefined" && client !== null) {
    client.disconnect();
  }
};


