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
		<div class="navpart"><a id="link" href="panelredirect.php">Panel</a></div>
	</div>
	<header class="main_header">
			<h1>find the best connection!</h1>
	</header>
	<div id="container">
	
		<?php
		
		require_once "config.php";
		
		$stmt = oci_parse($conn, "SELECT NAME FROM CITIES ORDER BY NAME");
		oci_execute($stmt, OCI_NO_AUTO_COMMIT);
		oci_fetch_all($stmt, $res);
		
		//prepare list of cities for form
		echo "<datalist id='citiesList'>";
		
		for ($i = 0; $i < count($res['NAME']); $i++) {
			$cityname = $res['NAME'][$i];
			echo "<option value='$cityname'></option>";
		}
		echo "</datalist>";
		
		
		?>

		<form autocomplete="off" action="bestconnection.php" method="post">
			Start city<br/>
			<input type="text" name="from_val" list="citiesList"/>

			Destination city<br/>
			<input type="text" name="to_val" list="citiesList"/><br><br/>
			Date of departure<br/>
			<input type="date" id="date_start" name="date_val" value="2030-01-01" min="2030-01-01"/><br><br/>
			How much is your hour worth? <p>$<span id="demo"></span></p> <br/>
			<input type="range" min="5" max="200" value="50" class="slider" id="coeff" name="coeff_val">
			
			<input type="submit" name="submit_button" value="Search"/>

			<script>
				var slider = document.getElementById("coeff");
				var output = document.getElementById("demo");
				output.innerHTML = slider.value;

				slider.oninput = function() {
				  output.innerHTML = this.value;
				}
			</script>
		</form>

	</div>
</body>
</html>

