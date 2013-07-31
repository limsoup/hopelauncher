/*
 * jQuery File Upload Plugin JS Example 8.2
 * https://github.com/blueimp/jQuery-File-Upload
 *
 * Copyright 2010, Sebastian Tschan
 * https://blueimp.net
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/MIT
 */

/*jslint nomen: true, regexp: true */
/*global $, window, navigator, blueimp */
var gallery;
$(function () {
    'use strict';
    $('#image-links').on('click', 'a', function(event) {
        event.preventDefault();
        // console.log(event);
        // console.log($('#image-links').find('a'));
        gallery = blueimp.Gallery($('#image-links a'), {
            index: $(this).data('index')
        });
    });
    // Initialize the jQuery File Upload widget:
    $('#fileupload').fileupload({
        // Uncomment the following to send cross-domain cookies:
        //xhrFields: {withCredentials: true},
        // url: 'server/php/'
        url: $('#fileupload').attr('action'),
        done: function(e, data) {
            // $.each(data.result.files, function(index, value){
                // console.log(value.thumb);
                $("#image-links").append("<a href=\""+data.result.url+"\" data-gallery = \"gallery\" class=\"slide\" data-index="+parseInt(data.result.index)+" title= \""+data.result.name+"\"> <img src=\""+data.result.thumb+"\"> </a>");
            // var links = document.getElementById('links').getElementsByTagName('a')
            // options = {
            //     // Set to true to initialize the Gallery with carousel specific options:
            //     carousel: false
            // }
            //console.log(blueimp);
            // gallery = blueimp.Gallery($('#image-links a'), {
            //     // Set to true to initialize the Gallery with carousel specific options:
            //     carousel: true
            // });
            }
    });

    // Enable iframe cross-domain access via redirect option:
    $('#fileupload').fileupload(
        'option',
        'redirect',
        window.location.href.replace(
            /\/[^\/]*$/,
            '/cors/result.html?%s'
        )
    );

    if (window.location.hostname === 'blueimp.github.io') {
        // Demo settings:
        $('#fileupload').fileupload('option', {
            url: '//jquery-file-upload.appspot.com/',
            // Enable image resizing, except for Android and Opera,
            // which actually support image resizing, but fail to
            // send Blob objects via XHR requests:
            disableImageResize: /Android(?!.*Chrome)|Opera/
                .test(window.navigator && navigator.userAgent),
            maxFileSize: 5000000,
            acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i
        });
        // Upload server status check for browsers with CORS support:
        if ($.support.cors) {
            $.ajax({
                url: '//jquery-file-upload.appspot.com/',
                type: 'HEAD'
            }).fail(function () {
                $('<span class="alert alert-error"/>')
                    .text('Upload server currently unavailable - ' +
                            new Date())
                    .appendTo('#fileupload');
            });
        }
    } else {
        // // Load existing files:
        // $('#fileupload').addClass('fileupload-processing');
        // $.ajax({
        //     // Uncomment the following to send cross-domain cookies:
        //     //xhrFields: {withCredentials: true},
        //     url: $('#fileupload').fileupload('option', 'url'),
        //     dataType: 'json',
        //     context: $('#fileupload')[0]
        // }).always(function () {
        //     $(this).removeClass('fileupload-processing');
        // }).done(function (result) {
        //     if($(this).fileupload('option','done') !== null){
        //         $(this).fileupload('option', 'done').call(this, null, {result: result});
        //     }
        // });
    }

    // Show the blueimp Gallery as lightbox when clicking on image links:
    $('#fileupload .files').on('click', '.gallery', function (event) {
        // The :even filter removes duplicate links (thumbnail and file name links):
        if (blueimp.Gallery($('#fileupload .gallery').filter(':even'), {
                index: this
            })) {
            // Prevent the default link action on
            // successful Gallery initialization:
            event.preventDefault();
        }
    });

});
