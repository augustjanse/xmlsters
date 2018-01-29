<?php
// Check connection
if (mysqli_connect_errno()) {
    printf("Connect failed: %s\n", mysqli_connect_error());
    exit();
}

if ($_GET["userid"]) {
    $xml = generateChart($_GET["userid"]);
    echo transformChart($xml);
}

if ($_POST["chart"]) {
    storeChart($_POST["chart"]);
    echo $_POST["chart"];
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

date_default_timezone_set("Europe/Stockholm")
?>
