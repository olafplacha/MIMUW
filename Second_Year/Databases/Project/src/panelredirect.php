<?php
	//if user is not signed in, redirect them to sign in page
	session_start();

	if (!(isset($_SESSION['login']) && $_SESSION['login'] != '')) {

		header ("Location: login.php");
		
	}else {
		$nextLocation = $_SESSION['clientType']."panel.php";
		header("location: $nextLocation");
	}
?>


