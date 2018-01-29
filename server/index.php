<?php
header("Content-type: text/xml; charset=utf-8");

// Connect using host, username, password and databasename
$link = mysqli_connect('localhost', 'rsslab', 'rsslab', 'rsslab');

// Check connection
if (mysqli_connect_errno()) {
    printf("Connect failed: %s\n", mysqli_connect_error());
    exit();
}

// The SQL query
$query = "SELECT link, title, description, creator, feeddate
            FROM exjobbsfeed
            ORDER BY feeddate ASC";

// Execute the query
if (($result = mysqli_query($link, $query)) === false) {
    printf("Query failed: %s<br />\n%s", $query, mysqli_error($link));
    exit();
}

date_default_timezone_set("Europe/Stockholm")
?>
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns="http://purl.org/rss/1.0/"
         xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:syn="http://purl.org/rss/1.0/modules/syndication/">

    <channel rdf:about="http://www.nada.kth.se/media/Theses/">
        <title>Examensarbeten medieteknik</title>
        <link>
        http://www.nada.kth.se/media/Theses/</link>
        <description>Examensarbeten inom medieteknik.</description>
        <dc:language>sv</dc:language>
        <dc:rights>Copyright KTH/Nada/Media</dc:rights>
        <dc:date><?= date(DATE_W3C) ?></dc:date>

        <dc:publisher>KTH/Nada/Media</dc:publisher>
        <dc:creator>bjornh@kth.se</dc:creator>
        <syn:updatePeriod>daily</syn:updatePeriod>
        <syn:updateFrequency>1</syn:updateFrequency>
        <syn:updateBase>2006-01-01T00:00+00:00</syn:updateBase>

        <items>
            <rdf:Seq>
                <?php
                while ($row = mysqli_fetch_assoc($result)) {
                    $element = '<rdf:li rdf:resource="?link"/>';

                    $link = $row["link"];
                    $link = htmlspecialchars($link, ENT_XML1 | ENT_QUOTES, 'UTF-8');
                    $link = str_replace(" ", "%20", $link);
                    $element = str_replace("?link", $link, $element);

                    echo $element . "\n";
                }
                ?>
            </rdf:Seq>
        </items>
        <image rdf:resource="http://www.nada.kth.se/media/images/kth.png"/>
    </channel>

    <?php
    mysqli_data_seek($result, 0);
    while ($row = mysqli_fetch_assoc($result)) {
        $element = '<item rdf:about="?link"> <title>?title</title> <link>?link</link> <description>?description</description> <dc:creator>?creator</dc:creator> <dc:date>?feeddate</dc:date> </item>';

        $link = $row["link"];
        $link = htmlspecialchars($link, ENT_XML1 | ENT_QUOTES, 'UTF-8');
        $link = str_replace(" ", "%20", $link);
        $element = str_replace("?link", $link, $element);

        $element = str_replace("?title", htmlspecialchars(utf8_encode($row["title"]), ENT_XML1 | ENT_QUOTES, 'UTF-8'), $element);
        $element = str_replace("?description", htmlspecialchars(utf8_encode($row["description"]), ENT_XML1 | ENT_QUOTES, 'UTF-8'), $element);
        $element = str_replace("?creator", htmlspecialchars(utf8_encode($row["creator"]), ENT_XML1 | ENT_QUOTES, 'UTF-8'), $element);
        $element = str_replace("?feeddate", date(DATE_W3C, strtotime($row["feeddate"])), $element);

        echo $element;
        echo "\n";
    }
    ?>
</rdf:RDF>