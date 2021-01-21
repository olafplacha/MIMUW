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
	</div>
	<header class="main_header">
			<h1>Here you can create a new account!</h1>
	</header>
	<div id="container">

		<form autocomplete="off" action="" method="post">
			<br/>
			Username
			<input type="text" name="username" value=""/><br><br/>
			Password<br/>
			<input type="password" name="password" value=""/><br><br/>
			Company Name
			<input type="text" name="companyname" value=""/><br><br/>
			Street
			<input type="text" name="street" value=""/><br><br/>
			Street Number
			<input type="text" name="streetnumber" value=""/><br><br/>
			Postal Code
			<input type="text" name="postalcode" value=""/><br><br/>
			City
			<input type="text" name="city" value=""/><br><br/>
			Country
			<input type="text" name="country" value=""/><br><br/>
			<?php	
			if($_SERVER["REQUEST_METHOD"] == "POST") {
		  	
			  	$conn = oci_connect("op429584","xyz","//labora.mimuw.edu.pl/LABS");
				
				$stmt = oci_parse($conn, "SET TRANSACTION ISOLATION LEVEL SERIALIZABLE");
				oci_execute($stmt, OCI_NO_AUTO_COMMIT);
				$stmt = oci_parse($conn, "SELECT MAX(id) AS M FROM AIRLINES");
				oci_execute($stmt, OCI_NO_AUTO_COMMIT);
				$numrows = oci_fetch_all($stmt, $res);
				if (is_null($res['M'][0])) {
					$newId = 0;
				} else {
					$newId = $res['M'][0] + 1;
				}
				
				$username = $_POST['username'];
				$password = $_POST['password'];
				$companyname = $_POST['companyname'];
				$street = $_POST['street'];
				$streetnumber = $_POST['streetnumber'];
				$postalcode = $_POST['postalcode'];
				$city = $_POST['city'];
				$country = $_POST['country'];
			      	
			      	$sql = "INSERT INTO AIRLINES 
			      		(id, username, passHash, company_name, street, 
			      		street_num, postal_code, city, country)
			      		VALUES ($newId, '$username', '$password', '$companyname', 
			      		'$street', '$streetnumber', '$postalcode', '$city', '$country')";
			      	$stmt = oci_parse($conn, $sql);
				$res = oci_execute($stmt, OCI_NO_AUTO_COMMIT);
				if ($res == false) {
					echo "Your username is not unique or you have improperly filled out the form!";
					$stmt = oci_parse($conn, "ROLLBACK"); 
					oci_execute($stmt, OCI_NO_AUTO_COMMIT); 
				} else {
					$stmt = oci_parse($conn, "COMMIT");
					oci_execute($stmt, OCI_NO_AUTO_COMMIT);
					$nextlocation = "login.php";
					header("Location: $nextlocation");
				}
			}

			?>
			<input type = "submit" value = "Submit"/><br />
		</form>

	</div>
</body>
</html>

