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
        const entity = "release-group";

        const url = "http://coverartarchive.org/" + entity + "/" + mbid + "/front";

        // API doesn't support CORS: https://stackoverflow.com/a/7910570/1729441
        $.ajax({
            dataType: "json",
            url: 'http://www.whateverorigin.org/get?url=' + encodeURIComponent(url) + '&callback=?',
            success: addToTray
        });

    })
});

function addToTray(data) {
    // data.contents contains "See: [URL]"
    const url = data.contents.match("See: (.*)")[1];

    $("#tray").find('img[src="FFFFFF-1.png"]:first').attr("src", url)
}

// Globally for lack of better way of exposing them
function drag(event) {
    $(event.srcElement).data("mbid", "test");
    event.dataTransfer.setData("mbid", $(event.srcElement).data("mbid"))
}

window.drag = drag;

function drop(event) {
    event.preventDefault();
    $(event.target).data("mbid", event.dataTransfer.getData("mbid"))
}

window.drop = drop;

function allowDrop(event) {
    event.preventDefault();
}

window.allowDrop = allowDrop;
