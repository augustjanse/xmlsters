// Simple Javascript file. Due to the specification of the assignment,
// no frontend frameworks will be used.

// Bootstrap requirements as in https://stackoverflow.com/a/47362344/1729441
window.jQuery = $ = require('jquery');
window.Popper = require('popper.js');
require('bootstrap');
require('bootstrap/dist/css/bootstrap.css');

// Other libraries
// ...

// Project files
require('../css/index.css');

$(function () {
    // https://stackoverflow.com/a/14472606/1729441
    $("form").on('submit', function (e) {
        // Reuses request from old userscript
        var input = $("#mbid_box").val();
        var mbid = input.match("[a-z0-9]+-[a-z0-9]+-[a-z0-9]+-[a-z0-9]+-[a-z0-9]+")[0];
        entity = null;
        setEntity(input, mbid);

        url = "http://coverartarchive.org/" + entity + "/" + mbid + "/front";

        // API doesn't support CORS: https://stackoverflow.com/a/7910570/1729441
        $.getJSON('http://www.whateverorigin.org/get?url=' + encodeURIComponent(url) + '&callback=?', addToTray);

        e.preventDefault()
    })
});

function addToTray(data) {
    // data.contents contains "See: [URL]"
    url = data.contents.match("See: (.*)")[1];

    $("#tray").find('img[src="image/FFFFFF-1.png"]:first').attr("src", url)
}