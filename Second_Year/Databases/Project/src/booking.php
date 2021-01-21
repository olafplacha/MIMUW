<html>
<head>
	<title>Best flights search engine</title>
	<META HTTP-EQUIV="content-type" CONTENT="text/html" CHARSET="utf-8">
	<link rel="stylesheet" href="style.css">
	<link rel="preconnect" href="https://fonts.gstatic.com">
	<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@500&display=swap" rel="stylesheet">
</head>
<?php
	ini_set('display_errors', 1);
	ini_set('display_startup_errors', 1);
	error_reporting(E_ALL);
	
	//if user is not logged in, redirect them to log in page
	session_start();

	if (!(isset($_SESSION['login']) && $_SESSION['login'] != '')) {

		header ("Location: login.php");
		
	}
	//user is logged in as a Customer
	$conn = oci_connect("op429584","xyz","//labora.mimuw.edu.pl/LABS");
	$sum = 0;
	for ($i = 0; $i < count($_SESSION['flightIds']); $i++) {
		$id = $_SESSION['flightIds'][$i];
		$sql = oci_parse($conn, "SELECT PRICE_PER_TICKET FROM FLIGHTS WHERE ID = $id");
		oci_execute($sql, OCI_NO_AUTO_COMMIT);
		oci_fetch_all($sql, $res);
		$sum += $res['PRICE_PER_TICKET'][0];
	}
?>

<body>
	<div id="nav">
		<div class="navpart"><a id="link" href="index.php">Search engine</a></div>
		<div class="navpart"><a id="link" href="panelredirect.php">Panel</a></div>
	</div>
	<header class="main_header">
			<h1>How many sets of tickets do you want to buy?</h1>
			<div id="container">
			<form autocomplete="off" action="bookinglogic.php" method="post">
				Number of tickets
				<input type="number" id="numOfTickets" name="numOfTickets" min=1 value=1/><br/>
				Total price: $<span id="demo"></span>
				<input type="submit" name="submit_button" value="Book"/>
			</form>
			</div>
			<script>
				var num = document.getElementById("numOfTickets");
				var output = document.getElementById("demo");
				var price = <?php echo $sum;?>;

				num.oninput = function() {
				  output.innerHTML = Math.max(price,price*this.value);
				}
			</script>
	</header>
</body>
</html>

