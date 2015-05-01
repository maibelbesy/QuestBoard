$(function(){
  $('.quest').mouseenter(function(){
    // alert($(this).attr('id'));
    $("#del-"+$(this).attr('id')).show();
  });
  $('.quest').mouseleave(function(){
    $("#del-"+$(this).attr('id')).hide();
  });
});