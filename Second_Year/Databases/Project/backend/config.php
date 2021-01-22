<?php

define("DB_USERNAME", "op429584");
define("DB_PASSWORD", "*****");
define("DB_CONNECTION_STRING", "//labora.mimuw.edu.pl/LABS");

$conn = oci_connect(DB_USERNAME, DB_PASSWORD, DB_CONNECTION_STRING);

if (!$conn) {
	die("Could not connect. ".$e['message']);
}
?>
