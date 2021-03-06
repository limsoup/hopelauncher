/* Load this script using conditional IE comments if you need to support IE 7 and IE 6. */

window.onload = function() {
	function addIcon(el, entity) {
		var html = el.innerHTML;
		el.innerHTML = '<span style="font-family: \'hopelauncher\'">' + entity + '</span>' + html;
	}
	var icons = {
			'h-icon-home' : '&#xe009;',
			'h-icon-quill' : '&#xe02f;',
			'h-icon-droplet' : '&#xe02c;',
			'h-icon-blog' : '&#xe02d;',
			'h-icon-images' : '&#xe028;',
			'h-icon-image' : '&#xe029;',
			'h-icon-headphones' : '&#xe025;',
			'h-icon-play' : '&#xe024;',
			'h-icon-camera' : '&#xe022;',
			'h-icon-bullhorn' : '&#xe01b;',
			'h-icon-podcast' : '&#xe019;',
			'h-icon-home-2' : '&#xe035;',
			'h-icon-office' : '&#xe033;',
			'h-icon-newspaper' : '&#xe032;',
			'h-icon-pencil' : '&#xe031;',
			'h-icon-paint-format' : '&#xe02b;',
			'h-icon-book' : '&#xe017;',
			'h-icon-library' : '&#xe015;',
			'h-icon-tags' : '&#xe003;',
			'h-icon-cart' : '&#xe00e;',
			'h-icon-coin' : '&#xe00f;',
			'h-icon-support' : '&#xe012;',
			'h-icon-phone' : '&#xe013;',
			'h-icon-phone-hang-up' : '&#xe014;',
			'h-icon-address-book' : '&#xe001;',
			'h-icon-notebook' : '&#xe016;',
			'h-icon-envelop' : '&#xe002;',
			'h-icon-alarm' : '&#xe021;',
			'h-icon-compass' : '&#xe004;',
			'h-icon-profile' : '&#xe005;',
			'h-icon-file' : '&#xe011;',
			'h-icon-paste' : '&#xe00b;',
			'h-icon-folder' : '&#xe006;',
			'h-icon-folder-open' : '&#xe007;',
			'h-icon-camera-2' : '&#xe027;',
			'h-icon-music' : '&#xe026;',
			'h-icon-calendar' : '&#xe008;',
			'h-icon-screen' : '&#xe00a;',
			'h-icon-laptop' : '&#xe02a;',
			'h-icon-mobile' : '&#xe00c;',
			'h-icon-mobile-2' : '&#xe00d;',
			'h-icon-tablet' : '&#xe010;',
			'h-icon-tv' : '&#xe02e;',
			'h-icon-bubble' : '&#xe041;',
			'h-icon-bubbles' : '&#xe042;',
			'h-icon-bubbles-2' : '&#xe043;',
			'h-icon-user' : '&#xe047;',
			'h-icon-users' : '&#xe048;',
			'h-icon-spinner' : '&#xe053;',
			'h-icon-busy' : '&#xe04e;',
			'h-icon-cog' : '&#xe065;',
			'h-icon-cogs' : '&#xe066;',
			'h-icon-bug' : '&#xe06b;',
			'h-icon-lab' : '&#xe07c;',
			'h-icon-rocket' : '&#xe076;',
			'h-icon-leaf' : '&#xe075;',
			'h-icon-lightning' : '&#xe083;',
			'h-icon-mug' : '&#xe073;',
			'h-icon-trophy' : '&#xe071;',
			'h-icon-gift' : '&#xe070;',
			'h-icon-equalizer' : '&#xe064;',
			'h-icon-wrench' : '&#xe062;',
			'h-icon-shield' : '&#xe082;',
			'h-icon-truck' : '&#xe018;',
			'h-icon-airplane' : '&#xe01a;',
			'h-icon-remove' : '&#xe01c;',
			'h-icon-briefcase' : '&#xe01d;',
			'h-icon-tree' : '&#xe08c;',
			'h-icon-cloud' : '&#xe08d;',
			'h-icon-eye' : '&#xe097;',
			'h-icon-paragraph-left' : '&#xe121;',
			'h-icon-paragraph-center' : '&#xe122;',
			'h-icon-paragraph-right' : '&#xe123;',
			'h-icon-paragraph-justify' : '&#xe124;',
			'h-icon-indent-increase' : '&#xe125;',
			'h-icon-indent-decrease' : '&#xe126;',
			'h-icon-close' : '&#xe0ce;',
			'h-icon-checkmark' : '&#xe0cf;',
			'h-icon-play-2' : '&#xe0d4;',
			'h-icon-pause' : '&#xe0d5;',
			'h-icon-stop' : '&#xe0d6;',
			'h-icon-backward' : '&#xe0d7;',
			'h-icon-forward' : '&#xe0d8;',
			'h-icon-enter' : '&#xe01e;',
			'h-icon-exit' : '&#xe0d3;',
			'h-icon-minus' : '&#xe0d2;',
			'h-icon-plus' : '&#xe01f;',
			'h-icon-arrow-up-left' : '&#xe0f6;',
			'h-icon-arrow-up' : '&#xe0f7;',
			'h-icon-arrow-up-right' : '&#xe0f8;',
			'h-icon-arrow-right' : '&#xe0f9;',
			'h-icon-arrow-down-right' : '&#xe0fa;',
			'h-icon-arrow-down' : '&#xe0fb;',
			'h-icon-arrow-down-left' : '&#xe0fc;',
			'h-icon-arrow-left' : '&#xe0fd;',
			'h-icon-reddit' : '&#xe16b;',
			'h-icon-youtube' : '&#xe140;',
			'h-icon-youtube-2' : '&#xe141;',
			'h-icon-feed' : '&#xe13f;',
			'h-icon-facebook' : '&#xe137;',
			'h-icon-google-plus' : '&#xe134;',
			'h-icon-tumblr' : '&#xe160;',
			'h-icon-delicious' : '&#xe16f;',
			'h-icon-thumbs-up' : '&#xe0a5;',
			'h-icon-thumbs-up-2' : '&#xe0a6;',
			'h-icon-star' : '&#xe0a1;',
			'h-icon-heart' : '&#xe0a2;',
			'h-icon-heart-2' : '&#xe0a3;',
			'h-icon-fire' : '&#xe07b;',
			'h-icon-hammer' : '&#xe07a;',
			'h-icon-wand' : '&#xe069;',
			'h-icon-hammer-2' : '&#xe068;',
			'h-icon-key' : '&#xe05e;',
			'h-icon-user-2' : '&#xe04c;',
			'h-icon-earth' : '&#xe020;',
			'h-icon-dribbble' : '&#xe023;',
			'h-icon-cone' : '&#xe030;',
			'h-icon-atom' : '&#xe034;',
			'h-icon-vimeo' : '&#xe144;',
			'h-icon-twitter' : '&#xe13a;'
		},
		els = document.getElementsByTagName('*'),
		i, attr, html, c, el;
	for (i = 0; ; i += 1) {
		el = els[i];
		if(!el) {
			break;
		}
		attr = el.getAttribute('data-icon');
		if (attr) {
			addIcon(el, attr);
		}
		c = el.className;
		c = c.match(/h-icon-[^\s'"]+/);
		if (c && icons[c[0]]) {
			addIcon(el, icons[c[0]]);
		}
	}
};