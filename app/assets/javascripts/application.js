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

clicked = false
$(function(){
  var clickPictureToShow = function() {
    $('body').on('click', '.user-photo', function(){
      var timeCreated = $(this).attr('data_time');
      var photoAuthor = $(this).attr('data_user');
      var photoAuthorName = $(this).attr('data_username');
      var liked = $(this).attr('data_liked');
      var src = $(this).attr('src');
      var userProfilePic = $(this).attr('data_user_profile')


      $('.user-container').empty();
      $('.user-container').append('<img alt="Image" class="on-show-photo" src="'+
                                  src+'">' + '<a class="photo-info" href="/users/'+photoAuthor+
                                  '"><img src="'+userProfilePic+'">  '+photoAuthorName+'</a> ~  ' + timeCreated +
                                  ' ago<br>')
      if (liked == 'false'){
        $('.user-container').append('<a class="like-button" href="#">like</a>')
      }
      if (clicked){
        $('.like-button').trigger('click')
      } else {
        clicked = true
      }
      setTimeout(function(){
        clicked = false
      }, 170)
    })
  }

  $('body').on('click', '.user-photo', function(){

  })

  var likeClickHandler = function(){
    $('body').on('click', '.like-button', function(ev){
      ev.preventDefault();
      var photoId = $('.on-show-photo').attr('src').split('/')[2];
      $('#'+photoId).attr('data_liked', 'true');

      $.post(
        '/likes.json',
        {
          'like':
            { 'photo_id': photoId}
        },
        function(){
          $('.like-button').remove();
        }
      )
    })
  }

  clickPictureToShow();
  likeClickHandler();
})