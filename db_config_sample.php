<?php
// This file contains MySQL settings and returns a database handle
// Insert the database name, username, and password below
// Once complete, rename this file to db_config.php

return mysql_connect('db_name', 'username', 'password')
        or die('Could not connect: ' . mysql_error());
?>