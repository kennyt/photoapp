// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .


$(function(){
  var clickPictureToShow = function() {
    $('body').on('click', '.user-photo', function(){
      var timeCreated = $(this).attr('data_time');
      var photoAuthor = $(this).attr('data_user');
      var photoAuthorEmail = $(this).attr('data_user_email')
      var src = $(this).attr('src')
      var that = this;

      $('.user-container').empty();
      $('.user-container').append('<a href="/users/'+photoAuthor+
                                  '">'+photoAuthorEmail+'</a>  ' + timeCreated +
                                  'ago' + '<img alt="Image" class="on-show-photo" src="'+
                                  src+'">')
    })
  }

  clickPictureToShow();
})