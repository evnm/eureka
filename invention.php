<!DOCTYPE html>

<html>
  <head>
    <meta http-equiv='Content-Type' content='text/html;charset=utf-8' />
    <link rel='stylesheet' type='text/css' media='all' href='/stylesheets/reset.css' />
    <link rel='stylesheet' type='text/css' media='all' href='/stylesheets/style.css' />
    <!--[if IE]>
      <script src='http://html5shiv.googlecode.com/svn/trunk/html5.js'></script>
    <![endif]-->
    <meta name="verify-v1" content="zGgDhC23bieRZOJnZewsB7vvECfaolGR8WfgLKf25SM=" />

    <title>Eureka - Generate Invention</title>
  </head>

  <body>
<?php
$dbh = require_once 'db_config.php';
mysql_select_db('eureka_db') or die('Could not select database');

$invention_desc = $_REQUEST["invention_to_save"];
if ($invention_desc) {
    // If invention description is passed, then insert it into saved_inventions table
    $query = sprintf("INSERT INTO saved_inventions (invention_desc) VALUES('%s');", mysql_real_escape_string($invention_desc));
    $result = mysql_query($query);
    $invention_id = mysql_insert_id();
    mysql_close();
} else {
    // Parse pieces of URI into invention ID
    $nav_string = $_SERVER['REQUEST_URI'];
    $parts = explode('/', $nav_string);
    // Extract invention ID and convert it to base 10
    $invention_id = base_convert(end($parts), 36, 10);
    $query = sprintf("SELECT invention_desc FROM saved_inventions WHERE invention_id = '%s'", mysql_real_escape_string($invention_id));
    $result = mysql_query($query) or die ('Query failed: ' . mysql_error());

    while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
        $invention_desc = $row["invention_desc"];
    }

    mysql_close();
}
?>

    <div id="wrapper">
      <header>
        <h1><a href='/'>Eureka</a></h1>
      </header>
      <nav>
        <ul>
          <li><a href='/'>Home</a></li>
          <li><a href='/about'>About</a></li>
        </ul>
      </nav>

      <article>
<?php if (strlen($invention_desc) > 0) { ?>
        <p class="invention_link">Invention URL: <span>http://eurekaapp.com/invention/<?php echo base_convert($invention_id, 10, 36) ?></span></p>
        <section class="invention">
          <p><?php echo($invention_desc); ?></p>
        </section>

<?php } else { ?>
        <p>There's no invention stored here! Try <a href="/">creating a new one?</a></p>
<?php } ?>
      </article>

      <footer>
        <p>Built by <a href='http://evanmeagher.net/'>Evan Meagher</a></p>
      </footer>
    </div>
  </body>
</html>