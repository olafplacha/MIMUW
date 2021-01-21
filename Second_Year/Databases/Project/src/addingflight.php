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
	<header class="main_header">
			<h1>Here you can create a new flight!</h1>
	</header>
	<div id="container">

		<form autocomplete="off" action="" method="post">
			Airplane ID
			<input type="text" name="planeid" list="airplanes"/><br/><br/>
			
			Airport of departure ID
			<input type="text" name="airportdept" list="airports"/><br/><br/>
			
			Airport of arrival ID
			<input type="text" name="airportarr" list="airports"/><br/><br/>
			
			Date of departure
			<input type="datetime-local" name="dateofdept" value="" min="2030-01-01T00:00"/><br><br/>
			
			Date of arrival
			<input type="datetime-local" name="dateofarr" value="" min="2030-01-01T00:00"/><br><br/>
			
			Price per ticket
			<input type="number" name="price" value="" min=1/><br><br/>
			
			<?php
	
				session_start();
				
				$conn = oci_connect("op429584","xyz","//labora.mimuw.edu.pl/LABS");
				$myId = $_SESSION['id'];
					
				//preparing list with ariplanes that the airline owns
				$sql = "SELECT AP.ID, AM.PRODUCER, AM.TYPE, AM.CAPACITY
					FROM AIRPLANES AP INNER JOIN AIRPLANEMODELS AM ON AP.MODELID = AM.ID
					WHERE AP.OWNERID = $myId ORDER BY AP.ID";
					
				$stmt = oci_parse($conn, $sql);
				oci_execute($stmt, OCI_NO_AUTO_COMMIT);
				oci_fetch_all($stmt, $res);
				
				echo "<datalist id='airplanes'>";
				
				for ($i = 0; $i < count($res['ID']); $i++) {
					$airplaneId = $res['ID'][$i];
					$val = $airplaneId." | ".$res['PRODUCER'][$i]." | ".$res['TYPE'][$i]." | Capacity:".$res['CAPACITY'][$i];
					echo "<option value='$airplaneId'>$val</option>";
				}
				echo "</datalist>";
				
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
				
				//creating a flight
				if($_SERVER["REQUEST_METHOD"] == "POST") {
					$airplaneid = $_POST["planeid"];
					$airportdept = $_POST["airportdept"];
					$airportarr = $_POST["airportarr"];
					$datedept = str_replace("T", " ", $_POST["dateofdept"]);
					$datearr = str_replace("T", " ", $_POST["dateofarr"]);
					$price = $_POST["price"];
					
					$stmt = oci_parse($conn, "SET TRANSACTION ISOLATION LEVEL SERIALIZABLE");
					oci_execute($stmt, OCI_NO_AUTO_COMMIT);
					$stmt = oci_parse($conn, "SELECT MAX(id) AS M FROM FLIGHTS");
					oci_execute($stmt, OCI_NO_AUTO_COMMIT);
					$numrows = oci_fetch_all($stmt, $res);
					if (is_null($res['M'][0])) {
						$newId = 0;
					} else {
						$newId = $res['M'][0] + 1;
					}
					
					$sql = "INSERT INTO FLIGHTS (id, planeId, price_per_ticket, date_dept, date_arr,
						airport_dept, airport_arr) 
						VALUES ($newId, $airplaneid, $price, TO_TIMESTAMP('$datedept', 'YYYY-MM-DD HH24:MI'), 
						TO_TIMESTAMP('$datearr', 'YYYY-MM-DD HH24:MI'), $airportdept, $airportarr)";
						
					echo '<span style="font-size:12px">';
					$stmt = oci_parse($conn, $sql);
					$res = oci_execute($stmt, OCI_NO_AUTO_COMMIT);
					if ($res == false) {
						echo "Something went wrong. Check if arrival date is bigger than departure date";
						$stmt = oci_parse($conn, "ROLLBACK"); 
						oci_execute($stmt, OCI_NO_AUTO_COMMIT); 
					} else {
						$stmt = oci_parse($conn, "COMMIT");
						oci_execute($stmt, OCI_NO_AUTO_COMMIT);
						echo "You have successfully created a new flight!";
					}
					echo '</span>';
				}

			?>			
			
			<input type = "submit" value = "Submit"/><br />
		</form>

	</div>
</body>
</html>

