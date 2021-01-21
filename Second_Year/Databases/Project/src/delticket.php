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
	
	session_start();

	$conn = oci_connect("op429584","xyz","//labora.mimuw.edu.pl/LABS");

	//deleting booking specified by id
	$bookingId = $_GET['bookingId'];

	//get flight id and number of tickets from a booking
	$sql = "SELECT F.ID, B.NUMBER_OF_TICKETS
		FROM BOOKINGS B INNER JOIN FLIGHTS F ON B.FLIGHTID = F.ID
		WHERE B.ID = $bookingId";
	$stmt = oci_parse($conn, $sql);
	oci_execute($stmt, OCI_NO_AUTO_COMMIT);
	oci_fetch_all($stmt, $res);

	$stmt = oci_parse($conn, "SET TRANSACTION ISOLATION LEVEL SERIALIZABLE");
	oci_execute($stmt, OCI_NO_AUTO_COMMIT);

	$sql = "DELETE FROM BOOKINGS WHERE ID = $bookingId";
	$stmt = oci_parse($conn, $sql);
	$flag1 = oci_execute($stmt, OCI_NO_AUTO_COMMIT);
	$flag2 = false;

	if ($flag1) {

		$sql = "UPDATE FLIGHTS SET SEATS_TAKEN = SEATS_TAKEN - ".$res['NUMBER_OF_TICKETS'][0]." WHERE ID = ".$res['ID'][0];
		$stmt = oci_parse($conn, $sql);
		$flag2 = oci_execute($stmt, OCI_NO_AUTO_COMMIT);
	}
	
	echo "<div id='container'>";
	
	if (!($flag2)) {
		//update didn't succeed or wasn't done at all
		$stmt = oci_parse($conn, "ROLLBACK"); 
		oci_execute($stmt, OCI_NO_AUTO_COMMIT); 
		echo "Something went wrong";
	} else {
		$stmt = oci_parse($conn, "COMMIT");
		oci_execute($stmt, OCI_NO_AUTO_COMMIT);
		echo "You have successfully deleted a booking";
	}
	
	echo "</div>";

	?>
</body>
</html>
