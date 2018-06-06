<?php
include 'header.html';
// Check connection
if (mysqli_connect_errno()) {
    printf("Connect failed: %s\n", mysqli_connect_error());
    exit();
}

if ($_GET["userid"]) {
    $xml = generateChart($_GET["userid"]);
    echo transformChart($xml);
} else if ($_POST["chart"]) {
    echo storeChart($_POST["chart"]);
} else {
    var_dump($_GET);
    var_dump($_POST);
}

function connect()
{
    // Connect using host, username, password and databasename
    // As root, with password in version control...
    return mysqli_connect('localhost', 'root', 'MyNewPass', 'xmlsters');
}

function generateChart($userid)
{
    $link = connect();
    $stmt = $link->prepare('SELECT * FROM user WHERE userid = ?');
    $stmt->bind_param('s', $userid);
    $stmt->execute();
    $result = $stmt->get_result();

    // Should only be one
    $row = $result->fetch_assoc();

    $userid = $row['userid'];
    $chartid = $row['chartid'];

    $xml = simplexml_load_file('skeleton.xml');
    $xml->head[0]->userid = $userid;
    $xml->head[0]->chartid = $chartid;

    $stmt = $link->prepare('SELECT * FROM chart WHERE chartid = ?');
    $stmt->bind_param('s', $chartid);
    $stmt->execute();
    $result = $stmt->get_result();

    for ($i = 0; $row = $result->fetch_assoc(); ++$i) {
        $xml->body[0]->addChild("release", $row['mbid']);
        $xml->body[0]->release[$i]['placement'] = $row['placement'];
    }

    return $xml;
}

function transformChart($xml)
{
    $xsl = new XSLTProcessor();
    $xsldoc = new DOMDocument();

    $xsldoc->load('index.xsl');
    $xsl->importStylesheet($xsldoc);

    return $xsl->transformToXml($xml);
}

function storeChart($chart)
{
    $xml = simplexml_load_string($chart);
    $userid = $xml->head[0]->userid;
    $chartid = $xml->head[0]->chartid;

    // Check if chartid exists already
    $link = connect();
    $stmt = $link->prepare('SELECT * FROM user WHERE chartid = ?');
    $stmt->bind_param('s', $chartid);
    $stmt->execute();
    $result = $stmt->get_result();

    // Check if chart owned by user
    $ownedByUser = false;
    if (mysqli_num_rows($result) == 0) {
        $ownedByUser = true; // New chart

        // Enter in user table
        $stmt = $link->prepare('INSERT INTO user VALUES (?, ?);');
        $stmt->bind_param('ss', $userid, $chartid);
        $stmt->execute();

        echo "entered in user";
    } else {
        while (!$ownedByUser && $row = $result->fetch_assoc()) { // Second part evalutates to NULL if done
            if ($row['userid'] == $userid) {
                $ownedByUser = true; // At least one row contains this combination, should hold for all
            }
        }
    }

    if ($ownedByUser) {
        $stmt = $link->prepare('REPLACE INTO chart VALUES (?, ?, ?);');
        for ($i = 0; $i < $xml->body[0]->release->count(); ++$i) {
            $mbid = (string)$xml->body[0]->release[$i];

            if ($mbid != '') {
                $placement = (string)$xml->body[0]->release[$i]['placement'];

                $stmt->bind_param('sss', $chartid, $placement, $mbid);
                $stmt->execute();
            }
        }
    } else {
        echo "chartid does not correspond to userid";
    }

    return $xml;
}

date_default_timezone_set("Europe/Stockholm");

include 'footer.html';
?>
