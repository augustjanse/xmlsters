<?php
// Check connection
if (mysqli_connect_errno()) {
    printf("Connect failed: %s\n", mysqli_connect_error());
    exit();
}

if ($_GET["userid"]) {
    echo generateChart($_GET["userid"]);
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
    while ($row = $result->fetch_assoc()) {
        echo $row['userid'];
        echo $row['chartid'];
    }
}

date_default_timezone_set("Europe/Stockholm")
?>
