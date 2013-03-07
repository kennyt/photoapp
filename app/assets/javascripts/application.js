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
      var photoId = $(this).attr('id')
      var userProfilePic = $(this).attr('data_user_profile')

      $('.user-container').empty();
      $('.user-container').append('<img alt="Image" class="on-show-photo" src="'+
                                  src+'" id='+photoId+'>' + '<a class="photo-info" href="/users/'+photoAuthor+
                                  '"><img src="'+userProfilePic+'">  '+photoAuthorName+'</a> ~  ' + timeCreated +
                                  ' ago<br>')
      if (liked == 'false'){
        $('.user-container').append('<a class="like-button" href="#">like</a>')
      }

      // allows users to double-click to like
      if (clicked){
        $('.like-button').trigger('click')
      } else {
        clicked = true
        setTimeout(function(){
          clicked = false
        }, 210)
      }
    })
  }

  var likeClickHandler = function(){
    $('body').on('click', '.like-button', function(ev){
      ev.preventDefault();
      var photoId = $('.on-show-photo').attr('id')
      $('#'+photoId).attr('data_liked', 'true');

      $.post(
        '/likes.json',
        {
          'like':
            { 'photo_id': photoId }
        },
        function(){
          $('.like-button').remove();
        }
      )
    })
  }

  var deletePhotoClickHandler = function(){
    $('body').on('click', '.delete-photo', function(){
      var id = $(this).attr('data-photo-id')
      $('.photo-holder-'+ id).remove();
      $.post(
        '/photos/'+$(this).attr('data-photo-id')+'.json',
        {'_method' : 'delete'},
        function(){
          console.log('hi');
          console.log(id);
        })
    })
  }

  clickPictureToShow();
  likeClickHandler();
  deletePhotoClickHandler();
})

// this method gets called on all pages that need facebook & twitter share
activateTweetAndFbShare = function(){
  // facebook
  (function(d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) return;
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/en_US/all.js#xfbml=1&appId=492172844179398";
    fjs.parentNode.insertBefore(js, fjs);
  }(document, 'script', 'facebook-jssdk'));

  // twitter
  !function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];
    if(!d.getElementById(id)){js=d.createElement(s);
      js.id=id;js.src="https://platform.twitter.com/widgets.js";
      fjs.parentNode.insertBefore(js,fjs);
    }
  }(document,"script","twitter-wjs");
}