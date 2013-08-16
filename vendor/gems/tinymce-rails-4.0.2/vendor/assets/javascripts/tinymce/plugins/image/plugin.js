//tinymce.PluginManager.add("image",function(e){function t(e,t){function n(e,n){i.parentNode.removeChild(i),t({width:e,height:n})}var i=document.createElement("img");i.onload=function(){n(i.clientWidth,i.clientHeight)},i.onerror=function(){n()},i.src=e;var a=i.style;a.visibility="hidden",a.position="fixed",a.bottom=a.left=0,a.width=a.height="auto",document.body.appendChild(i)}function n(t){return function(){var n=e.settings.image_list;"string"==typeof n?tinymce.util.XHR.send({url:n,success:function(e){t(tinymce.util.JSON.parse(e))}}):t(n)}}function i(n){function i(){var e=[{text:"None",value:""}];return tinymce.each(n,function(t){e.push({text:t.text||t.title,value:t.value||t.url,menu:t.menu})}),e}function a(e){var t,n,i,a;t=c.find("#width")[0],n=c.find("#height")[0],i=t.value(),a=n.value(),c.find("#constrain")[0].checked()&&u&&m&&i&&a&&(e.control==t?(a=Math.round(i/u*a),n.value(a)):(i=Math.round(a/m*i),t.value(i))),u=i,m=a}function r(){function t(t){function i(){t.onload=t.onerror=null,e.selection.select(t),e.nodeChanged()}t.onload=function(){n.width||n.height||f.setAttribs(t,{width:t.clientWidth,height:t.clientHeight}),i()},t.onerror=i}var n=c.toJSON();""===n.width&&(n.width=null),""===n.height&&(n.height=null),""===n.style&&(n.style=null),n={src:n.src,alt:n.alt,width:n.width,height:n.height,style:n.style},h?f.setAttribs(h,n):(n.id="__mcenew",e.insertContent(f.createHTML("img",n)),h=f.get("__mcenew"),f.setAttrib(h,"id",null)),t(h)}function o(e){return e&&(e=e.replace(/px$/,"")),e}function l(){t(this.value(),function(e){e.width&&e.height&&(u=e.width,m=e.height,c.find("#width").value(u),c.find("#height").value(m))})}function s(){function e(e){return e.length>0&&/^[0-9]+$/.test(e)&&(e+="px"),e}var t=c.toJSON(),n=f.parseStyle(t.style);delete n.margin,n["margin-top"]=n["margin-bottom"]=e(t.vspace),n["margin-left"]=n["margin-right"]=e(t.hspace),n["border-width"]=e(t.border),c.find("#style").value(f.serializeStyle(f.parseStyle(f.serializeStyle(n))))}var c,d,u,m,g,f=e.dom,h=e.selection.getNode();u=f.getAttrib(h,"width"),m=f.getAttrib(h,"height"),"IMG"!=h.nodeName||h.getAttribute("data-mce-object")?h=null:d={src:f.getAttrib(h,"src"),alt:f.getAttrib(h,"alt"),width:u,height:m},n&&(g={name:"target",type:"listbox",label:"Image list",values:i(),onselect:function(e){var t=c.find("#alt");(!t.value()||e.lastControl&&t.value()==e.lastControl.text())&&t.value(e.control.text()),c.find("#src").value(e.control.value())}});var p=[{name:"src",type:"filepicker",filetype:"image",label:"Source",autofocus:!0,onchange:l},g,{name:"alt",type:"textbox",label:"Image description"},{type:"container",label:"Dimensions",layout:"flex",direction:"row",align:"center",spacing:5,items:[{name:"width",type:"textbox",maxLength:3,size:3,onchange:a},{type:"label",text:"x"},{name:"height",type:"textbox",maxLength:3,size:3,onchange:a},{name:"constrain",type:"checkbox",checked:!0,text:"Constrain proportions"}]}];e.settings.image_advtab?(h&&(d.hspace=o(h.style.marginLeft||h.style.marginRight),d.vspace=o(h.style.marginTop||h.style.marginBottom),d.border=o(h.style.borderWidth),d.style=e.dom.serializeStyle(e.dom.parseStyle(e.dom.getAttrib(h,"style")))),c=e.windowManager.open({title:"Insert/edit image",data:d,bodyType:"tabpanel",body:[{title:"General",type:"form",items:p},{title:"Advanced",type:"form",pack:"start",items:[{label:"Style",name:"style",type:"textbox"},{type:"form",layout:"grid",packV:"start",columns:2,padding:0,alignH:["left","right"],defaults:{type:"textbox",maxWidth:50,onchange:s},items:[{label:"Vertical space",name:"vspace"},{label:"Horizontal space",name:"hspace"},{label:"Border",name:"border"}]}]}],onSubmit:r})):c=e.windowManager.open({title:"Edit image",data:d,body:p,onSubmit:r})}e.addButton("image",{icon:"image",tooltip:"Insert/edit image",onclick:n(i),stateSelector:"img:not([data-mce-object])"}),e.addMenuItem("image",{icon:"image",text:"Insert image",onclick:n(i),context:"insert",prependToContext:!0})});
/**
 * plugin.js
 *
 * Copyright, Moxiecode Systems AB
 * Released under LGPL License.
 *
 * License: http://www.tinymce.com/license
 * Contributing: http://www.tinymce.com/contributing
 */

/*global tinymce:true */

/**
 * plugin.js
 *
 * Copyright, Moxiecode Systems AB
 * Released under LGPL License.
 *
 * License: http://www.tinymce.com/license
 * Contributing: http://www.tinymce.com/contributing
 */

/*global tinymce:true */

tinymce.PluginManager.add('image', function(editor) {
	function getImageSize(url, callback) {
		var img = document.createElement('img');

		function done(width, height) {
			img.parentNode.removeChild(img);
			callback({width: width, height: height});
		}

		img.onload = function() {
			done(img.clientWidth, img.clientHeight);
		};

		img.onerror = function() {
			done();
		};

		img.src = url;

		var style = img.style;
		style.visibility = 'hidden';
		style.position = 'fixed';
		style.bottom = style.left = 0;
		style.width = style.height = 'auto';

		document.body.appendChild(img);
	}

	function createImageList(callback) {
		return function() {
			var imageList = editor.settings.image_list;

			if (typeof(imageList) == "string") {
				tinymce.util.XHR.send({
					url: imageList,
					success: function(text) {
						callback(tinymce.util.JSON.parse(text));
					}
				});
			} else {
				callback(imageList);
			}
		};
	}

	function showDialog(imageList) {
		var win, data, dom = editor.dom, imgElm = editor.selection.getNode();
		var width, height, imageListCtrl;

		function buildImageList() {
			var linkImageItems = [{text: 'None', value: ''}];
			
			tinymce.each(imageList, function(link) {
				linkImageItems.push({
					type: 'menuitem',
					// classes: 'menu-item',
					style:"width:150px; height:150px;background-image:url("+link.value+"); background-size: auto 150px; background-repeat:no-repeat; background-position: center top;text-align:",
					text: link.text || link.title,
					value: link.value || link.url,
					image: link.value,
					icon: link.value,
					menu: link.menu,
					hideMenu: tinymce.ui.MenuItem.hideMenu
				});
			});

			return linkImageItems;
		}

		function recalcSize(e) {
			var widthCtrl, heightCtrl, newWidth, newHeight;

			widthCtrl = win.find('#width')[0];
			heightCtrl = win.find('#height')[0];

			newWidth = widthCtrl.value();
			newHeight = heightCtrl.value();

			if (win.find('#constrain')[0].checked() && width && height && newWidth && newHeight) {
				if (e.control == widthCtrl) {
					newHeight = Math.round((newWidth / width) * newHeight);
					heightCtrl.value(newHeight);
				} else {
					newWidth = Math.round((newHeight / height) * newWidth);
					widthCtrl.value(newWidth);
				}
			}

			width = newWidth;
			height = newHeight;
		}

		function onSubmitForm() {
			function waitLoad(imgElm) {
				function selectImage() {
					imgElm.onload = imgElm.onerror = null;
					editor.selection.select(imgElm);
					editor.nodeChanged();
				}

				imgElm.onload = function() {
					if (!data.width && !data.height) {
						dom.setAttribs(imgElm, {
							width: imgElm.clientWidth,
							height: imgElm.clientHeight
						});
					}

					selectImage();
				};

				imgElm.onerror = selectImage;
			}

			var data = win.toJSON();

			if (data.width === '') {
				data.width = null;
			}

			if (data.height === '') {
				data.height = null;
			}

			if (data.style === '') {
				data.style = null;
			}

			data = {
				src: data.src,
				alt: data.alt,
				width: data.width,
				height: data.height,
				style: data.style
			};

			if (!imgElm) {
				data.id = '__mcenew';
				editor.insertContent(dom.createHTML('img', data));
				imgElm = dom.get('__mcenew');
				dom.setAttrib(imgElm, 'id', null);
			} else {
				dom.setAttribs(imgElm, data);
			}

			waitLoad(imgElm);
		}

		function removePixelSuffix(value) {
			if (value) {
				value = value.replace(/px$/, '');
			}

			return value;
		}

		function updateSize() {
			getImageSize(this.value(), function(data) {
				if (data.width && data.height) {
					width = data.width;
					height = data.height;

					win.find('#width').value(width);
					win.find('#height').value(height);
				}
			});
		}

		width = dom.getAttrib(imgElm, 'width');
		height = dom.getAttrib(imgElm, 'height');

		if (imgElm.nodeName == 'IMG' && !imgElm.getAttribute('data-mce-object')) {
			data = {
				src: dom.getAttrib(imgElm, 'src'),
				alt: dom.getAttrib(imgElm, 'alt'),
				width: width,
				height: height
			};
		} else {
			imgElm = null;
		}

		if (imageList) {
			// imageList = tinyMCE.activeEditor.controlManager.createDropMenu('target');
			imageListCtrl = {
				name: 'targetContainer',
				type: 'menubutton',
				text: 'menubutton',
				label: 'Image list',
				menu : {
					type:'menu',
					name: 'target',
					layout:'stack',
					classes: 'image-plugin-class',
					minHeight: 100,
					minWidth: 400,
					items: buildImageList(),
					onselect: function(e) {
						var altCtrl = win.find('#alt');
						console.log(altCtrl);
						if (!altCtrl.value() || (e.lastControl && altCtrl.value() == e.lastControl.text())) {
							altCtrl.value(e.control.text());
						}

						win.find('#src').value(e.control.value());
					}
				}
			};
		}

		// General settings shared between simple and advanced dialogs
		var generalFormItems = [
			{name: 'src', type: 'filepicker', filetype: 'image', label: 'Source', autofocus: true, onchange: updateSize},
			imageListCtrl,
			{name: 'alt', type: 'textbox', label: 'Image description'},
			{
				type: 'container',
				label: 'Dimensions',
				layout: 'flex',
				direction: 'row',
				align: 'center',
				spacing: 5,
				items: [
					{name: 'width', type: 'textbox', maxLength: 3, size: 3, onchange: recalcSize},
					{type: 'label', text: 'x'},
					{name: 'height', type: 'textbox', maxLength: 3, size: 3, onchange: recalcSize},
					{name: 'constrain', type: 'checkbox', checked: true, text: 'Constrain proportions'}
				]
			}
		];

		function updateStyle() {
			function addPixelSuffix(value) {
				if (value.length > 0 && /^[0-9]+$/.test(value)) {
					value += 'px';
				}

				return value;
			}

			var data = win.toJSON();
			var css = dom.parseStyle(data.style);

			delete css.margin;
			css['margin-top'] = css['margin-bottom'] = addPixelSuffix(data.vspace);
			css['margin-left'] = css['margin-right'] = addPixelSuffix(data.hspace);
			css['border-width'] = addPixelSuffix(data.border);

			win.find('#style').value(dom.serializeStyle(dom.parseStyle(dom.serializeStyle(css))));
		}

		if (editor.settings.image_advtab) {
			// Parse styles from img
			if (imgElm) {
				data.hspace = removePixelSuffix(imgElm.style.marginLeft || imgElm.style.marginRight);
				data.vspace = removePixelSuffix(imgElm.style.marginTop || imgElm.style.marginBottom);
				data.border = removePixelSuffix(imgElm.style.borderWidth);
				data.style = editor.dom.serializeStyle(editor.dom.parseStyle(editor.dom.getAttrib(imgElm, 'style')));
			}

			// Advanced dialog shows general+advanced tabs
			win = editor.windowManager.open({
				title: 'Insert/edit image',
				data: data,
				bodyType: 'tabpanel',
				body: [
					{
						title: 'General',
						type: 'form',
						items: generalFormItems
					},

					{
						title: 'Advanced',
						type: 'form',
						pack: 'start',
						items: [
							{
								label: 'Style',
								name: 'style',
								type: 'textbox'
							},
							{
								type: 'form',
								layout: 'grid',
								packV: 'start',
								columns: 2,
								padding: 0,
								alignH: ['left', 'right'],
								defaults: {
									type: 'textbox',
									maxWidth: 50,
									onchange: updateStyle
								},
								items: [
									{label: 'Vertical space', name: 'vspace'},
									{label: 'Horizontal space', name: 'hspace'},
									{label: 'Border', name: 'border'}
								]
							}
						]
					}
				],
				onSubmit: onSubmitForm
			});
		} else {
			// Simple default dialog
			win = editor.windowManager.open({
				title: 'Edit image',
				data: data,
				body: generalFormItems,
				onSubmit: onSubmitForm
			});
		}
	}

	editor.addButton('image', {
		icon: 'image',
		tooltip: 'Insert/edit image',
		onclick: createImageList(showDialog),
		stateSelector: 'img:not([data-mce-object])'
	});

	editor.addMenuItem('image', {
		icon: 'image',
		text: 'Insert image',
		onclick: createImageList(showDialog),
		context: 'insert',
		prependToContext: true
	});
});