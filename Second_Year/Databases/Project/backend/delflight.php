<html>
<head>
	<title>Best flights search engine</title>
	<META HTTP-EQUIV="content-type" CONTENT="text/html" CHARSET="utf-8">
	<link rel="stylesheet" href="style.css">
	<link rel="preconnect" href="https://fonts.gstatic.com">
	<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@500&display=swap" rel="stylesheet">
</head>
<body>
	<div id="nav">
		<div class="navpart"><a id="link" href="index.php">Search engine</a></div>
		<div class="navpart"><a id="link" href="panelredirect.php">Panel</a></div>
	</div>
	
	<?php
	
	require_once "config.php";
	
	session_start();

	//deleting booking specified by id
	$flightId = $_GET['flightId'];

	$stmt = oci_parse($conn, "SET TRANSACTION ISOLATION LEVEL SERIALIZABLE");
	oci_execute($stmt, OCI_NO_AUTO_COMMIT);

	$sql = "DELETE FROM FLIGHTS WHERE ID = $flightId";
	$stmt = oci_parse($conn, $sql);
	$flag = oci_execute($stmt, OCI_NO_AUTO_COMMIT);
	
	echo "<div id='container'>";
	
	if (!($flag)) {
		//update didn't succeed or wasn't done at all
		$stmt = oci_parse($conn, "ROLLBACK"); 
		oci_execute($stmt, OCI_NO_AUTO_COMMIT); 
		echo "Customers already booked this flight! You cannot delete it now";
	} else {
		$stmt = oci_parse($conn, "COMMIT");
		oci_execute($stmt, OCI_NO_AUTO_COMMIT);
		echo "You have successfully deleted a flight";
	}
	
	echo "</div>";

	?>
</body>
</html>
