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

        url = "http://coverartarchive.org/" + entity + "/front";
        jQuery.get(url, function (data) {
            alert(data)
        });

        e.preventDefault()
    })
});
