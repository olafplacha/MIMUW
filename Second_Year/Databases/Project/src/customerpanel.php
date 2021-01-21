<html>
<head>
	<title>Best flights search engine</title>
	<META HTTP-EQUIV="content-type" CONTENT="text/html" CHARSET="utf-8">
	<link rel="stylesheet" href="style.css">
	<link rel="preconnect" href="https://fonts.gstatic.com">
	<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@500&display=swap" rel="stylesheet">
</head>
<body>
	<<div id="nav">
		<div class="navpart"><a id="link" href="index.php">Search engine</a></div>
	</div>
	<header class="main_header">
			<h1>Below are your tickets!</h1>
	</header>
	
	<div id="container">

		<form autocomplete="off" action="" method="post">
			
			Airport of departure ID <br/>
			<span style="font-size:12px"> *blank means any</span>
			<input type="text" name="airportdept" list="airports"/><br/><br/>
			
			Airport of arrival ID  <br/>
			<span style="font-size:12px"> *blank means any</span>
			<input type="text" name="airportarr" list="airports"/><br/><br/>
			
			How many to display
			<input type="number" name="num" value=5 min=1/><br><br/>			
			
			<input type = "submit" value = "Search"/><br />
		</form>

	</div>
	
	<div id="resholder">

	<?php
	ini_set('display_errors', 1);
	ini_set('display_startup_errors', 1);
	error_reporting(E_ALL);
	
	session_start();
	
	$conn = oci_connect("op429584","xyz","//labora.mimuw.edu.pl/LABS");
	$myId = $_SESSION['id'];
	
	//preparing list with airports
	$sql = "SELECT ID, NAME FROM AIRPORTS ORDER BY ID";
		
	$stmt = oci_parse($conn, $sql);
	oci_execute($stmt, OCI_NO_AUTO_COMMIT);
	oci_fetch_all($stmt, $res);
	
	echo "<datalist id='airports'>";
	
	for ($i = 0; $i < count($res['ID']); $i++) {
		$id = $res['ID'][$i];
		$val = $res['NAME'][$i];
		echo "<option value=$id>$val</option>";
	}
	echo "</datalist>";
	
	if($_SERVER["REQUEST_METHOD"] == "POST") {
	
		$from = $_POST['airportdept'];
		$to = $_POST['airportarr'];
		$number = $_POST['num'];
		
		if ($from=="") {
			$firstcondition = "1=1";
		} else {
			$firstcondition = "A1.ID = $from";
		}
		
		if ($to=="") {
			$secondcondition = "1=1";
		} else {
			$secondcondition = "A2.ID = $to";
		}
	
		$sql = "SELECT * FROM (
			SELECT B.ID AS BID , F.ID AS FID, F.DATE_DEPT, F.DATE_ARR, A1.NAME AS N1 , A2.NAME AS N2, AL.COMPANY_NAME, 
			F.PRICE_PER_TICKET, SUM(B.NUMBER_OF_TICKETS) AS TICKETS
			FROM BOOKINGS B 
			JOIN FLIGHTS F ON B.FLIGHTID = F.ID 
			JOIN AIRPORTS A1 ON F.AIRPORT_DEPT = A1.ID
			JOIN AIRPORTS A2 ON F.AIRPORT_ARR = A2.ID
			JOIN AIRPLANES AP ON F.PLANEID = AP.ID
			JOIN AIRLINES AL ON AP.OWNERID = AL.ID
			WHERE B.CUSTOMERID = $myId AND $firstcondition AND $secondcondition
			GROUP BY B.ID, F.ID, F.DATE_DEPT, F.DATE_ARR, A1.NAME, A2.NAME, AL.COMPANY_NAME, F.PRICE_PER_TICKET
			ORDER BY F.DATE_DEPT) WHERE ROWNUM <= $number";
		$stmt = oci_parse($conn, $sql);
		oci_execute($stmt, OCI_NO_AUTO_COMMIT);
		oci_fetch_all($stmt, $res);

		//show all tickets that a customer has booked
		for ($i = 0; $i < count($res['FID']); $i++) {
			$flightid = $res["FID"][$i];
			$datedept = $res["DATE_DEPT"][$i];
			$datearr = $res["DATE_ARR"][$i];
			$name1 = $res["N1"][$i];
			$name2 = $res["N2"][$i];
			$companyname = $res["COMPANY_NAME"][$i];
			$price = $res["PRICE_PER_TICKET"][$i];
			$tickets = $res["TICKETS"][$i];
			
			echo "<div class='oneResult'>";
			echo "	<div class='customerpanelticket'>$flightid</div>";
			echo "	<div class='customerpanelticket'>$datedept</div>";
			echo "	<div class='customerpanelticket'>$datearr</div>";
			echo "	<div class='customerpanelticket'>$name1</div>";
			echo "	<div class='customerpanelticket'>$name2</div>";
			echo "	<div class='customerpanelticket'>$companyname</div>";
			echo "	<div class='customerpanelticket'>$ $price</div>";
			echo "	<div class='customerpanelticket'>$tickets tickets</div>";
			echo "	<div class='customerpanelticket'><a class='del' href='delticket.php?bookingId=".$res["BID"][$i]."'>delete</a></div>";
			echo "</div>";
		
			
		}
	}
	
	
	?>	
	
	<div id="footer">	
		<div class="footerpart"><a class="footerlink" href="logout.php">Log out</a></div>
	</div>
	</div>
</body>
</html>

