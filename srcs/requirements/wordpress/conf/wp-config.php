<?php

//One of the most important files in your WordPress installation is the wp-config.php file. 
//This file is located in the root of your WordPress file directory and contains 
//your website’s base configuration details, such as database connection information.
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the website, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/
 *
 * @package WordPress
 */

// ** Database settings ** //

//These lines tell you where to find your database content wich is responsible for loading your pages and posting content
//WordPress will connect to this database to store and retrieve all its data, including posts, pages, user information, settings, and more

//Identifies which database to use
define( 'DB_NAME', getenv('DB_NAME') );
//Specifies the user with access to the database
//The database user must have the appropriate permissions to access the specified database. T
//This user should have sufficient privileges to read from and write to the database, create and modify tables, etc. -> this is done in the mariadb script
define( 'DB_USER', getenv('DB_USER') );
//Authenticates the database user
define( 'DB_PASSWORD', getenv('DB_PASSWORD') );
//Locates the database server (mariadb is defined as a server in the docker compose file)
define( 'DB_HOST', getenv('DB_HOST') );
//Defines the character set to be used: UTF-8 character encoding
//UTF-8 is a widely used encoding that can represent almost all characters in the Unicode character set, making it suitable for multilingual content.
define( 'DB_CHARSET', 'utf8' );
//Defines the collation for the database tables. Collation is a set of rules for comparing and sorting characters in the database.
//The empty string means that the we will use the default collation for UTF-8
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */

//These keys and salts improve the security of the cookies and password storage mechanisms in WordPress, 
//making it more difficult for potential attackers to gain unauthorized access to your website.
define('AUTH_KEY',         'x6~oEHrqJQ]nD4BjTO(wfd6 @%<1pvFlL);!~yGGrbVA.C|R*.9LL%+>2?m+#`*l');
define('SECURE_AUTH_KEY',  'F[.=RcktW(T(-bz4a0r]W4_3D1UM<6~bfs |5dBz-^>_jLH!!`pNq29a8b7E&d3V');
define('LOGGED_IN_KEY',    '<{?hO-Hta|p|8!q.J{LQzIHb3!g-Eg)r#`9|+9}>%xV1LnG7AG^zLNG[g>lr17ne');
define('NONCE_KEY',        'wiWR{3niENsnkR`p%WjKpJ.T+,%B|pJpHflPY3^(fe/)q49|x=OXK*f`$S!nLGmu');
define('AUTH_SALT',        'rdI-AY$ifI#*>-!X_vTsX#)N[$:qovX]vISRu=Z|-r|:oTSr+b-2cEF{Z0:~[^DL');
define('SECURE_AUTH_SALT', 'bHWDac:a];LY~YNMJt`q`nJSeSfkI(uV:f<K^LsIzu+TN0Vavnj6HVr6n 49A-J+');
define('LOGGED_IN_SALT',   'z9S0XnP b&Z3KunNupG)3.U^[1d&|*+!_-bI->EI[vhQ]z5a8o?:[6IP}j+1s&~;');
define('NONCE_SALT',       '[v[)qOK(!1r3aOCK>cG?8+|FCRdXNzS=(I!-Q}Y_X9d!<xbuEh,m0&KtQmfO&E8>');


/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://developer.wordpress.org/advanced-administration/debug/debug-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */


/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';