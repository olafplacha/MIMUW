<html>
<head>
	<title>Best flights search engine</title>
	<META HTTP-EQUIV="content-type" CONTENT="text/html" CHARSET="utf-8">
	<link rel="stylesheet" href="style.css">
	<link rel="preconnect" href="https://fonts.gstatic.com">
	<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@500&display=swap" rel="stylesheet">
</head>
<?php
	require_once "config.php";
	
  	session_start();
  	
  	$error = '';
  	
  	if($_SERVER["REQUEST_METHOD"] == "POST") {
	      
		$myusername = $_POST['username'];
		$mypassword = $_POST['password'];
		
		if($_POST['clientType'] == 'customer') {
			$table = 'CUSTOMERS';
		}else {
			$table = 'AIRLINES';
		}

		$sql = "SELECT id FROM $table WHERE username = '$myusername' and passhash = '$mypassword'";
		$stmt = oci_parse($conn, $sql);
		oci_execute($stmt, OCI_NO_AUTO_COMMIT);
		$numrows = oci_fetch_all($stmt, $res);

		// If result matched $myusername and $mypassword, table row must be 1 row
			
		if($numrows == 1) {
			$_SESSION['id'] = $res['ID'][0];
			$_SESSION['login'] = $myusername;
			$_SESSION['clientType'] = $_POST['clientType'];
			$nextLocation = $_POST['clientType']."panel.php";
			$sql = "UPDATE $table SET DATE_LAST_ACTIVE = SYS_EXTRACT_UTC(SYSTIMESTAMP) WHERE id =".$res['ID'][0];
			$stmt = oci_parse($conn, $sql);
			oci_execute($stmt, OCI_NO_AUTO_COMMIT);
			$stmt = oci_parse($conn, "COMMIT");
			oci_execute($stmt, OCI_NO_AUTO_COMMIT);
			header("location: $nextLocation");
		}else {
			$error = "Your Login Name or Password is invalid";
		}
	}

?>

<body>
	<div id="nav">
		<div class="navpart"><a id="link" href="index.php">Search engine</a></div>
	</div>
	<header class="main_header">
			<h1>Log in</h1>
	</header>
	<div id="container">

		<form autocomplete="off" action = "" method = "post">
			<label>Username  :</label><input type = "text" name = "username" class = "box"/><br /><br />
			<label>Password  :</label><input type = "password" name = "password" class = "box" /><br/><br />
			<label for="cars">Account type: </label>

			<select name="clientType">
				<option value="customer">Customer</option>
				<option value="airline">Airline</option>
			</select><br/><br>
			<?php
			echo '<span style="font-size:12px">';
			echo $error;
			echo '</span>';
			?>
			<input type = "submit" value = " Submit "/><br/><br/>
			<a id="singinhref" href="signincustomer.php">Create customer account</a><br/><br/>
			<a id="singinhref" href="signinairline.php">Create airline account</a><br/>
		</form>

	</div>
</body>
</html>

