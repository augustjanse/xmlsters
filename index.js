// Simple Javascript file. Due to the specification of the assignment,
// no frontend frameworks will be used.
$(function () {
    $("img").each(function () {
        refreshArt($(this))
    });

    // https://stackoverflow.com/a/14472606/1729441
    $("form#add").on('submit', function (e) {
        e.preventDefault();

        // Reuses request from old userscript
        const input = $("#mbid_box").val();
        const mbid = input.match("[a-z0-9]+-[a-z0-9]+-[a-z0-9]+-[a-z0-9]+-[a-z0-9]+")[0];

        const $img = $("#tray").find('img[src="FFFFFF-1.png"]:first'); // First empty element in tray
        fillImg($img, mbid)
    });

    $("form#save").on('submit', function (e) {
        e.preventDefault();

        $.ajax({
            url: window.location.origin, // Might send GET parameters as well if no URL supplied
            type: "POST",
            data: {chart: serializeChart()},
            success: function (data, status) {
                console.log(data);
            },
            error: function () {
                console.log("error");
            }
        });
    });

    const url = new URL(window.location.href);
    const userid = url.searchParams.get("userid");
    const chartid = url.searchParams.get("chartid");

    $("#userid").val(userid);
    $("#chartid").val(chartid);
});

/**
 * Fill data-mbid and src fields of an $img
 * @param $img
 * @param mbid
 */
function fillImg($img, mbid) {
    if (mbid === undefined) {
        $img.removeData("mbid")
    } else {
        $img.data("mbid", mbid);
    }
    refreshArt($img)
}

/**
 * Takes $img with data("mbid") set, and sets the appropriate img src
 * @param $img
 */
function refreshArt($img) {
    const entity = "release";
    const mbid = $img.data("mbid");
    const url = "http://coverartarchive.org/" + entity + "/" + mbid + "/front";

    if (mbid === "") {
        // Skip the request
        $img.attr("src", "FFFFFF-1.png")
    } else {
        // API doesn't support CORS: https://stackoverflow.com/a/7910570/1729441
        $.ajax({
            context: $img,
            dataType: "json",
            url: 'http://www.whateverorigin.org/get?url=' + encodeURIComponent(url) + '&callback=?',
            success: setSrc
        });
    }
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
    event.dataTransfer.setData("mbid", $(event.srcElement).data("mbid"));
    fillImg($(event.target), undefined) // Empty source
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

function serializeChart() {
    const xmlString = "<chart><head><chartid/><userid/></head><body/></chart>";
    const $xmlDoc = $($.parseXML(xmlString));

    const url = new URL(window.location.href);
    const userid = url.searchParams.get("userid");
    const chartid = url.searchParams.get("chartid");

    $xmlDoc.find("userid").text(userid);
    $xmlDoc.find("chartid").text(chartid);

    $("img").not("#tray img").each(function (index, element) {
        // Make release node
        $release = $("<release/>");
        $release.attr("placement", index + 1);
        $release.text($(element).data("mbid"));

        $xmlDoc.find("body").append($release);
    });

    return new XMLSerializer().serializeToString($xmlDoc[0]);
}

window.allowDrop = allowDrop;
