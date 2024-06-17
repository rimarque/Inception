<!-- It's a default file. The important thing here is change some lines 
to use our database. For now, we'll use test values, but after we 
need to change it to the .env variables. -->
define( 'DB_NAME', getenv('thedatabase') );
define( 'DB_USER', getenv('theuser') );
define( 'DB_PASSWORD', getenv('abc') );
define( 'DB_HOST', getenv('mariadb') );
define( 'WP_HOME', getenv('https://login.42.fr') );
define( 'WP_SITEURL', getenv('https://login.42.fr') );