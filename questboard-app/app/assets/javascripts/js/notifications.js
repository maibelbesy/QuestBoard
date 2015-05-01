function respondToNotification(payload) {
	var type = payload.type;
  var message = payload.message;
  var count = payload.count;
  if (typeof message !== "undefined" && message !== null) {
    showNotificationsCard(message);
  }
  if (typeof count !== "undefined" && count !== null && count !== '0') {
    $('.notifs-label').text('Notifications [' + payload.count + ']');
  }
}

function showNotificationsCard(message) {
	$notifs = $('.notifs');
	$message = $('.notifs-message');
	$message.text(message);
  $notifs.show();
  $notifs.animate({opacity: 1, bottom:'2em'}, 'fast').delay(5000).animate({opacity: 0, bottom:'1em'}, 'fast', function(){
    $notifs.hide();
  });
}