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
//= require raphael-min
//= require g.raphael-min
//= require_directory .

/* jQuery-File-Upload-master/*/

$(function() {
	if( $('.selectpicker').length > 0){
		$('.selectpicker').selectpicker();
	}
		
	$('#login-btn').on('click',function(){
		$(this).hide();
		$('#nav-login').show();
	});
	
	//where there is cleditor
  // $("textarea").cleditor({width:500, height:180, useCSS:true})[0].focus();

	$.ajax({
	      url: 'http://api.flickr.com/services/rest/',
	      data: {
	          format: 'json',
	          method: 'flickr.interestingness.getList',
	          api_key: '7617adae70159d09ba78cfec73c13be3'
	      },
	    dataType: 'jsonp',
	      jsonp: 'jsoncallback'
	  }).done(function (data) {
	      // var gallery = $('#gallery'),
	      var gallery = $('.thumbnail'),
	          url;
	      $.each(data.photos.photo, function (index, photo) {
	      		if(index+1 > gallery.length){
	      			return false;
	      		}
	          url = 'http://farm' + photo.farm + '.static.flickr.com/' +
	              photo.server + '/' + photo.id + '_' + photo.secret;
	          $('<img src='+url + '_b.jpg>')
	              // .append($('<img>').prop('src', url + '_b.jpg')
	              // .prop('href', url + '_b.jpg')
	              // .prop('title', photo.title)
	              .appendTo(gallery[index]);
	      });
	  });
	// if($('#block_content, #message_body').length > 0)
	// {
	// 	$('#block_content, #message_body').cleditor({
	// 		 width: '100%',
	// 		 height: '800px'
	// 	});
	// }
});