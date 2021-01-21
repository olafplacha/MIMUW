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
	
	$stmt = oci_parse($conn, "SET TRANSACTION ISOLATION LEVEL SERIALIZABLE");
	oci_execute($stmt, OCI_NO_AUTO_COMMIT);
	$stmt = oci_parse($conn, "SELECT MAX(id) AS M FROM BOOKINGS");
	oci_execute($stmt, OCI_NO_AUTO_COMMIT);
	$numrows = oci_fetch_all($stmt, $res);
	if (is_null($res['M'][0])) {
		$newId = -1;
	} else {
		$newId = $res['M'][0];
	}
	
	$idCustomer = $_SESSION['id'];
	$numoftickets = $_POST['numOfTickets'];
	
	for ($i = 0; $i < count($_SESSION['flightIds']); $i++) {
		//insert a new booking record
		$newId += 1;
		$idFlight = $_SESSION['flightIds'][$i];
		$sql = "INSERT INTO BOOKINGS VALUES ($newId, $idCustomer, $idFlight, $numoftickets)";
		$stmt = oci_parse($conn, $sql);
		$res = oci_execute($stmt, OCI_NO_AUTO_COMMIT);
		if ($res == false) {
			echo "<div id='container'>Something went wrong. Probably there are not enough seats</div>";
			$stmt = oci_parse($conn, "ROLLBACK"); 
			oci_execute($stmt, OCI_NO_AUTO_COMMIT); 
			break;
		}
		//update seats taken in flights table
		$sql = "UPDATE FLIGHTS SET SEATS_TAKEN = SEATS_TAKEN + $numoftickets WHERE ID = $idFlight";
		$stmt = oci_parse($conn, $sql);
		oci_execute($stmt, OCI_NO_AUTO_COMMIT);
		
	}
	//everything went fine, commit the transaction
	if ($res == true) {
		$stmt = oci_parse($conn, "COMMIT");
		oci_execute($stmt, OCI_NO_AUTO_COMMIT);
		echo "<div id='container'>You have successfully booked a flight!</div>";
	}	
	?>
</body>
</html>

