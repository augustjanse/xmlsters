// Simple Javascript file. Due to the specification of the assignment,
// no frontend frameworks will be used.
$(function () {
    // https://stackoverflow.com/a/14472606/1729441
    $("form").on('submit', function (e) {
        // Reuses request from old userscript
        var input = $("#mbid_box").val();
        var mbid = input.match("[a-z0-9]+-[a-z0-9]+-[a-z0-9]+-[a-z0-9]+-[a-z0-9]+")[0];
        entity = null;
        setEntity(input, mbid);

        url = "http://coverartarchive.org/" + entity + "/" + mbid + "/front";
        $.ajax({
            method: 'GET',
            url: url,
            success: addToTray,
            error: function (jqXHR, textStatus) {
                console.log(textStatus);
            }
        });

        e.preventDefault()
    })
});

function addToTray(data, status) {
    console.log(data);
    console.log(status)
}