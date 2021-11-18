mapkey('r', '#8Open a URL', function () {
    Front.openOmnibar({ type: "URLs", extra: "getAllSites" });
});
map('t','on');
// unmap('t');
// map('t','on');
//map('gt', 'T');
unmap('<Ctrl-h>');
unmap('<Ctrl-j>');
// unmap('gh');
// unmap('i');
iunmap(":"); // disable extension-builtin emoji
//Hints.characters = 'asdgqwerzxcv';

unmap('cs');
map('cs','cS');

// unmap('B');
// unmap('F');
// map('F','gf');

// tab navigation;
map('gxj','gxt');
map('gxk','gxT');
map('gxe','gxt');
map('gxr','gxT');
unmap('gxt');
unmap('gxT');
map('gxe','gxt');
map('gxr','gxT');
map('gxE','gx0');
map('gxR','gx$');
// zr to zoom reset


removeSearchAliasX('y');
addSearchAliasX('y', 'yandex', 'https://yandex.com/search/?text=');
//addSearchAliasX('m', 'mdn', 'https://developer.mozilla.org/en-US/search?q=', 's');
// addSearchAliasX('w', 'wikipedia', 'https://www.wikipedia.org/w/index.php?title=Special:Search&search=%s');
// g google
// d duckduckgo
// e wikipedia
// w bing
// s stackoverflow
// h github
// y youtube


unmap('gs');
mapkey('gs', '#12Open Chrome Settings', function() {
    tabOpenLink("chrome://settings/");
});

//settings.tabsThreshold=8;
settings.tabsMRUOrder = false;

