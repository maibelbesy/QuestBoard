function respondToNotification(payload, channel) {
	var type = payload.type;
  var message = payload.message;
  var count = payload.count;
  var url = payload.url;
  var id = payload.id;
  if (typeof message !== "undefined" && message !== null) {
    showNotificationsCard(message);
  }
  if (typeof count !== "undefined" && count !== null) {
    if (count > 0) {
      $('.badge').text(payload.count);
    } else {
      $('.badge').text('0');
    }
  }
  if (typeof url !== "undefined" && url !== null && count !== '0') {
    $notifs = $('.notifs');
    $notifs.click(function(){
      $.post('/notifications', JSON.stringify({id: id}));
      publishNotification(channel, {
        count: count - 1,
      }, url);
    });
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

  $notifs.hover(
     function(){
        $(this).stop(true,false);
    },
    function(){
      $(this).animate({opacity: 0, bottom:'1em'}, 'fast', function(){
        $notifs.hide();
      });
    });
}