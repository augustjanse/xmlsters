import 'bootstrap';
import 'bootstrap/dist/css/bootstrap.min.css';
import '../src/index.css';

// Simple Javascript file. Due to the specification of the assignment,
// no frontend frameworks will be used.
$(function () {
    // https://stackoverflow.com/a/14472606/1729441
    $("form").on('submit', function (e) {
        e.preventDefault();

        // Reuses request from old userscript
        const input = $("#mbid_box").val();
        const mbid = input.match("[a-z0-9]+-[a-z0-9]+-[a-z0-9]+-[a-z0-9]+-[a-z0-9]+")[0];

        const $img = $("#tray").find('img[src="FFFFFF-1.png"]:first'); // First empty element in tray
        fillImg($img, mbid)
    })
});

/**
 * Fill data-mbid and src fields of an $img
 * @param $img
 * @param mbid
 */
function fillImg($img, mbid) {
    $img.data("mbid", mbid);
    refreshArt($img)
}

/**
 * Takes $img with data("mbid") set, and sets the appropriate img src
 * @param $img
 */
function refreshArt($img) {
    const entity = "release-group";
    const mbid = $img.data("mbid");
    const url = "http://coverartarchive.org/" + entity + "/" + mbid + "/front";

    // API doesn't support CORS: https://stackoverflow.com/a/7910570/1729441
    $.ajax({
        context: $img,
        dataType: "json",
        url: 'http://www.whateverorigin.org/get?url=' + encodeURIComponent(url) + '&callback=?',
        success: setSrc
    });
}

/**
 * Takes returned data from the MB API, does some slight parsing, and sets the src of this to the url.
 * @param data
 */
function setSrc(data) {
    // data.contents contains "See: [URL]"
    const url = data.contents.match("See: (.*)")[1];

    // this should be $img from context
    this.attr("src", url)
}

// Globally for lack of better way of exposing them
function drag(event) {
    event.dataTransfer.setData("mbid", $(event.srcElement).data("mbid"))
}

window.drag = drag;

function drop(event) {
    event.preventDefault();
    const mbid = event.dataTransfer.getData("mbid");
    fillImg($(event.target), mbid);
}

window.drop = drop;

function allowDrop(event) {
    event.preventDefault();
}

window.allowDrop = allowDrop;
