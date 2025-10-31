<?php

$name = $_POST["name"];
$email = $_POST["email"];
$website = $_POST["website"];
$comment = $_POST["comment"];
$gender = $_POST["gender"];

$servername = "RDS-ENDPOINT";
$username = "root";
$password = "pass1234";
$dbname = "registration";

// Create connection
$conn = mysqli_connect($servername, $username, $password, $dbname);

// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

// Insert data
$sql = "INSERT INTO users (name, email, website, comment, gender) 
        VALUES ('$name', '$email', '$website', '$comment', '$gender')";

if (mysqli_query($conn, $sql)) {
    echo "<h1>New record created successfully</h1>";
} else {
    echo "Error: " . $sql . "<br>" . mysqli_error($conn);
}

mysqli_close($conn);
?>
