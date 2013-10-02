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
//= require blueimp-gallery/blueimp-gallery.js
//= require jQuery-File-Upload-master/js/vendor/tmpl.min.js
//= require jQuery-File-Upload-master/js/vendor/canvas-to-blob.js
//= require jQuery-File-Upload-master/js/vendor/load-image.min.js
//= require jQuery-File-Upload-master/js/vendor/jquery.ui.widget.js
//= require jQuery-File-Upload-master/js/jquery.fileupload.js
//= require jQuery-File-Upload-master/js/jquery.fileupload-ui.js
//= require jQuery-File-Upload-master/js/jquery.fileupload-process.js
//= require jQuery-File-Upload-master/js/jquery.fileupload-image.js
//= require_directory .

/* jQuery-File-Upload-master */
/* tinymce/tinymce.min.js */

$(function() {
	
	if($("#project_profile_image") > 0){
		$("#project_profile_image").imagepicker();
	}
	if( $('.selectpicker').length > 0){
		$('.selectpicker').selectpicker();
	}
		
	$('#login-btn').on('click',function(){
		$(this).hide();
		$('#nav-login').show();
	});

	if($('.datepicker').length > 0){
		$('.datepicker').datepicker({
		    format: 'mm/dd/yyyy'
		});
	}
	
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
	      var gallery = $('.project-partial .thumbnail'),
	          url;
	      gallery = gallery.filter(function(index){
	      	console.log($(this).css('background-image')== "none")
	      	return ($(this).css('background-image') == "none");
	      });
	      $.each(data.photos.photo, function (index, photo) {
	      		if(index+1 > gallery.length){
	      			return false;
	      		}
	          url = 'http://farm' + photo.farm + '.static.flickr.com/' +
	              photo.server + '/' + photo.id + '_' + photo.secret;
	          $(gallery[index]).css('background-image', 'url(\''+url+'.jpg\')')
	          // $('<img src='+url + '_b.jpg>')
	          //     // .append($('<img>').prop('src', url + '_b.jpg')
	          //     // .prop('href', url + '_b.jpg')
	          //     // .prop('title', photo.title)
	          //     .appendTo(gallery[index]);
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