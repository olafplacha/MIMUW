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
			<h1>Here you can add a new airplane to your fleet!</h1>
	</header>
	<div id="container">

		<form autocomplete="off" action="" method="post">
			Airplane model
			<input type="text" name="model" list="airplanemodels"/><br/><br/>
			
			<?php	
			session_start();
			
			$conn = oci_connect("op429584","xyz","//labora.mimuw.edu.pl/LABS");
			$myId = $_SESSION['id'];
				
			//preparing list with ariplane models
			$sql = "SELECT ID, PRODUCER, TYPE, CAPACITY
				FROM AIRPLANEMODELS A";
				
			$stmt = oci_parse($conn, $sql);
			oci_execute($stmt, OCI_NO_AUTO_COMMIT);
			oci_fetch_all($stmt, $res);
			
			echo "<datalist id='airplanemodels'>";
			
			for ($i = 0; $i < count($res['ID']); $i++) {
				$airplanemodelId = $res['ID'][$i];
				$val = $airplanemodelId." | ".$res['PRODUCER'][$i]." | ".$res['TYPE'][$i]." | Capacity:".$res['CAPACITY'][$i];
				echo "<option value=$airplanemodelId>$val</option>";
			}
			echo "</datalist>";
			
			//creating airplane ownership
			if($_SERVER["REQUEST_METHOD"] == "POST") {
				$airplanemodelId = $_POST["model"];
				
				$stmt = oci_parse($conn, "SET TRANSACTION ISOLATION LEVEL SERIALIZABLE");
				oci_execute($stmt, OCI_NO_AUTO_COMMIT);
				$stmt = oci_parse($conn, "SELECT MAX(id) AS M FROM AIRPLANES");
				oci_execute($stmt, OCI_NO_AUTO_COMMIT);
				$numrows = oci_fetch_all($stmt, $res);
				if (is_null($res['M'][0])) {
					$newId = 0;
				} else {
					$newId = $res['M'][0] + 1;
				}
				
				$sql = "INSERT INTO AIRPLANES (id, ownerid, modelid) 
					VALUES ($newId, $myId, $airplanemodelId)";
					
				$stmt = oci_parse($conn, $sql);
				$res = oci_execute($stmt, OCI_NO_AUTO_COMMIT);
				
				echo '<span style="font-size:12px">';
				if ($res == false) {
					echo "Something went wrong";
					$stmt = oci_parse($conn, "ROLLBACK"); 
					oci_execute($stmt, OCI_NO_AUTO_COMMIT); 
				} else {
					$stmt = oci_parse($conn, "COMMIT");
					oci_execute($stmt, OCI_NO_AUTO_COMMIT);
					echo "You have successfully added a new airplane to your fleet!";
				}
				echo '</span>';
			}

			?>			
			
			<input type = "submit" value = "Submit"/><br />
		</form>

	</div>
</body>
</html>

