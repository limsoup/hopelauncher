// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(function() {
	$('#edit_block_content').on('click',function() {
		var block = $('#block_content');
		block.attr('contenteditable', block.attr('contenteditable') == "true" ? "false" : "true" );
	});
});