<html>
<head>
	<title>book the best flight!</title>
	<link rel="stylesheet" href="style.css" type="text/css"/>
	<link rel="preconnect" href="https://fonts.gstatic.com">
	<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@500&display=swap" rel="stylesheet">	
</head>
<body>
	<div id="nav">
		<div class="navpart"><a id="link" href="index.php">Search engine</a></div>
		<div class="navpart"><a id="link" href="panelredirect.php">Panel</a></div>
	</div>
	<header class="main_header">
		<h1>Below is the best connection!</h1>
	</header>
	<div id="searchResult">
		<?php
		session_start();
		
		exec("/usr/bin/python3 dijkstra.py '".$_POST['from_val']."' '".$_POST['to_val']."' '".$_POST['date_val']."' ".$_POST['coeff_val']." 2>&1", $res);
		
		if (count($res) == 1 or IS_NULL($res)) {
			//no connection found
			echo "<div id='container'>No connection found. Make sure you entered a valid city. 
			      If so, try different date or change time-value coefficient!</div>";
		} else {
			
			echo '<div id="resholder">';
			//printing flights	
			for ($i = 0; $i < count($res) - 1; $i++) {
				echo $res[$i];
			}
			echo '</div>';
		}
		
		//save ids to session
		$ids = explode(',', $res[$i]);
		$_SESSION['flightIds'] = $ids;

		if (count($res) > 1) {
			if (isset($_SESSION['clientType']) && $_SESSION['clientType'] == 'airline') {
				echo "";
			} 
			else if (isset($_SESSION['clientType']) && $_SESSION['clientType'] == 'customer') {
				echo '<div id="footer"><div class="footerpart"><a class="footerlink" href="booking.php">Book it!</a></div></div>';
			} else {
				echo '<div id="footer"><div class="footerpart"><a class="footerlink" href="login.php">Log in to book flights!</a></div></div>';
			}
		}
			
		?>	
	
	</div>
	
</body>
</html>

